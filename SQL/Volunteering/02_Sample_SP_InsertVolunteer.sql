/************************************************************
* Stored Procedure: Volunteers.SP_InsertVolunteer
* Author: Karleny Pérez
* Date: 2025-11-12
*
* Description: Registers a new volunteer after validating
*              their id number, and foreign key references.
*
* Notes:
*  - Includes validation for inactive or invalid references.
*  - Exception handling with custom error messages.
*************************************************************/
ALTER PROCEDURE Volunteers.SP_InsertVolunteer
    @IdNumber VARCHAR(20),
    @FirstName VARCHAR(100),
    @LastName1 VARCHAR(100),
    @LastName2 VARCHAR(100) = NULL,
    @PhoneNumber VARCHAR(20) = NULL,
    @Email VARCHAR(150) = NULL,
    @VolunteerTypeId INT,
    @InstitutionId INT = NULL,
    @Major VARCHAR(150) = NULL,
    @Job VARCHAR(150) = NULL,
    @StartDate DATE,
    @EstimatedEndDate DATE = NULL, -- NULL for independent volunteers
    @MinHoursToComplete INT = NULL -- NULL for independent volunteers

AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Validate unique ID number
        IF EXISTS (
			SELECT 1 
			FROM Volunteers.Volunteer
			WHERE id_number = @IdNumber
		)
            THROW 52800, 'A volunteer with this ID number already exists.', 1;

        -- Validate volunteering type
        IF NOT EXISTS (
            SELECT 1 
			FROM Volunteers.VolunteerType 
            WHERE volunteer_type_id = @VolunteerTypeId
				AND record_status = 1
        )
            THROW 52801, 'The volunteer type does not exist or is inactive.', 1;

        -- Validate institution (if provided)
        IF @InstitutionId IS NOT NULL AND NOT EXISTS (
            SELECT 1 
			FROM Institutions.Institution
            WHERE institution_id = @InstitutionId
				AND record_status = 1
        )
            THROW 52802, 'The volunteer institution does not exist or is inactive.', 1;

        -- Insert record
        INSERT INTO Volunteers.Volunteer (
            id_number,
            first_name,
            last_name,
            second_last_name,
            phone_number,
            email,
            volunteer_type_id,
            institution_id,
            major,
            job,
            starting_date,
            estimated_end_date,
            min_hours_to_complete,
            record_status
        )
        VALUES (
            @IdNumber,
            @FirstName,
            @LastName1,
            @LastName2,
            @PhoneNumber,
            @Email,
            @VolunteerTypeId,
            @InstitutionId,
            @Major,
            @Job,
            @StartDate,
            @EstimatedEndDate,
            @MinHoursToComplete,
            1 -- Active by default
        );

        PRINT 'Volunteer successfully registered.';

    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000),
                @CustomMessage NVARCHAR(4000);

        SET @ErrorMessage = ERROR_MESSAGE();
        SET @CustomMessage = '❌ Error inserting volunteer: ' + @ErrorMessage;

        THROW 52803, @CustomMessage, 1;
    END CATCH;
END;
GO

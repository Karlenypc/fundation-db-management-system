/************************************************************
* Stored Procedure: Volunteers.SP_UpdateVolunteer
*
* Description: Updates an existing volunteer when needed.
*
* Notes:
*  - Includes validation for inactive or invalid references.
*  - Exception handling with custom error messages.
*
* Restriction:
*    The id number cannot be updated for security reasons. 
*    If the user enters the wrong id number, they must delete  
*    the entire record and generate it again.
*
* Author: Karleny Pérez
* Date: 2025-11-12
*************************************************************/
ALTER PROCEDURE Volunteers.SP_UpdateVolunteer
    @VolunteerId INT,
    @FirstName VARCHAR(100) = NULL,
    @LastName1 VARCHAR(100) = NULL,
    @LastName2 VARCHAR(100) = NULL,
    @PhoneNumber VARCHAR(20) = NULL,
    @Email VARCHAR(150) = NULL,
    @VolunteerTypeId INT = NULL,
    @InstitutionId INT = NULL,
    @Major VARCHAR(150) = NULL,
    @Job VARCHAR(150) = NULL,
    @StartDate DATE = NULL,
    @EstimatedEndDate DATE = NULL,
    @MinHoursToComplete INT = NULL 

AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY

		--Validate volunteer Id
		IF NOT EXISTS (
			SELECT 1 
			FROM Volunteers.Volunteer 
			WHERE volunteer_id = @VolunteerId
				AND record_status = 1
		)
			THROW 52104, 'The volunteer does not exist or is inactive.', 1

        -- Validate volunteering type (if provided)
        IF @VolunteerTypeId IS NOT NULL AND NOT EXISTS (
            SELECT 1 
			FROM Volunteers.VolunteerType 
            WHERE volunteer_type_id = @VolunteerTypeId
				AND record_status = 1
        )
            THROW 52105, 'The volunteer type does not exist or is inactive.', 1;

        -- Validate institution (if provided)
        IF @InstitutionId IS NOT NULL AND NOT EXISTS (
            SELECT 1 
			FROM Institutions.Institution
            WHERE institution_id = @InstitutionId
				AND record_status = 1
        )
            THROW 52106, 'The volunteer institution does not exist or is inactive.', 1;

        -- Update record
        UPDATE Volunteers.Volunteer 
		SET
            first_name = COALESCE(@FirstName, first_name),
            last_name = COALESCE(@LastName1, last_name),
            second_last_name = COALESCE(NULLIF(@LastName2, ''), second_last_name),
            phone_number = COALESCE(NULLIF(@PhoneNumber, ''), phone_number),
            email = COALESCE(NULLIF(@Email, ''), email),
            volunteer_type_id = COALESCE(@VolunteerTypeId, volunteer_type_id),
            institution_id = COALESCE(@InstitutionId, institution_id),
            major = COALESCE(NULLIF(@Major, ''), major),
            job = COALESCE(NULLIF(@Job, ''), job),
            starting_date = COALESCE(@StartDate, starting_date), 
            estimated_end_date = COALESCE(@EstimatedEndDate, estimated_end_date), 
            min_hours_to_complete = COALESCE(@MinHoursToComplete, min_hours_to_complete)
        WHERE volunteer_id = @VolunteerId;

        PRINT 'Volunteer successfully updated.';

    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage VARCHAR(4000),
                @CustomMessage VARCHAR(4000);

        SET @ErrorMessage = ERROR_MESSAGE();
        SET @CustomMessage = '❌ Error updating volunteer: ' + @ErrorMessage;

        THROW 52107, @CustomMessage, 1;
    END CATCH;
END;
GO

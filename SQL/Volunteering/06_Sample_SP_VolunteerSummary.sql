/************************************************************
* Stored Procedure: Volunteers.SP_VolunteerSummary
* Description: Returns a summary of each volunteer, including 
*              personal data, assigned volunteering type, 
*              institution, total hours completed, remaining 
*              hours, and current status.
*
* It includes functions that perform the calculations 
* corresponding to the derived attributes calls:
*     - 'CompletedHours'
*     - 'PendingHours' 
*     - 'Status'
*
* Notes:
* - Calculations do not apply to 'Independent' volunteering.
* - Handles scenarios with or without an organization.
*
* Author: Karleny Pérez
* Created: 2025-11-12
*************************************************************/
ALTER PROCEDURE Volunteers.SP_VolunteerSummary
	@VolunteerId INT

AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
		
		IF NOT EXISTS (
            SELECT 1 
            FROM Volunteers.Volunteer 
            WHERE volunteer_id = @VolunteerId
        )
            THROW 52814, 'The volunteer does not exist.', 1;

		-- Declare variables to capture the results of the functions in BIGINT
        DECLARE @CompletedHoursMin BIGINT;
        DECLARE @PendingHoursMin BIGINT;

        -- Capture the results of the functions in BIGINT variables
        SET @CompletedHoursMin = Volunteers.FN_WorkedHours(@VolunteerId);
        SET @PendingHoursMin = Volunteers.FN_RemainingHours(@VolunteerId); 

        SELECT 
            v.volunteer_id AS 'VolunteerId',
            v.id_number AS 'IdNumber',
            CONCAT(v.first_name, ' ', v.last_name, ' ', ISNULL(v.second_last_name, '')) AS 'FullName',
            v.phone_number AS 'Phone',
            v.email AS 'Email',
            vt.volunteer_type_name AS 'VolunteerType',
            ISNULL(i.institution_name, 'Not assigned') AS 'Institution',
            v.major AS 'Major',
            v.job AS 'Job',
            v.starting_date AS 'StartDate',
            v.estimated_end_date AS 'EstimatedEndDate',
            v.min_hours_to_complete AS 'RequiredHours',

			-- Results in legible format 'H:MM'
            CAST(@CompletedHoursMin / 60 AS VARCHAR(10)) + ':' + RIGHT('00' + CAST(@CompletedHoursMin % 60 AS VARCHAR(2)), 2) AS 'CompletedHours',
            CAST(@PendingHoursMin / 60 AS VARCHAR(10)) + ':' + RIGHT('00' + CAST(@PendingHoursMin % 60 AS VARCHAR(2)), 2) AS 'PendingHours',

            Volunteers.FN_VolunteerStatus(@VolunteerId) AS 'Status',

			-- Results BIGINT (for Power BI / calculations)
            @CompletedHoursMin AS 'CompletedHours_MinutesBIGINT',
            @PendingHoursMin AS 'PendingHours_MinutesBIGINT'

        FROM Volunteers.Volunteer v

			INNER JOIN Volunteers.VolunteerType vt 
				ON v.volunteer_type_id = vt.volunteer_type_id

			LEFT JOIN Institutions.Institution i 
				ON v.institution_id = i.institution_id

        WHERE v.volunteer_id = @VolunteerId

    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000),
                @CustomMessage NVARCHAR(4000);

        SET @ErrorMessage = ERROR_MESSAGE();
        SET @CustomMessage = '❌ Error retrieving volunteering summary: ' + @ErrorMessage;

        THROW 52830, @CustomMessage, 1;
    END CATCH;
END;
GO

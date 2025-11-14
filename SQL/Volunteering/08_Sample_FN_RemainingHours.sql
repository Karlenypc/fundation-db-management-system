/************************************************************
Function: Volunteers.FN_RemainingHours

Description: Calculates the remaining hours a volunteer needs 
             to complete their required volunteering hours.

Author: Karleny Pérez
Created: 2025-11-13
*************************************************************/
CREATE FUNCTION Volunteers.FN_RemainingHours (@VolunteerId INT)
RETURNS BIGINT

AS
BEGIN

    DECLARE @Required_Minutes BIGINT,
            @Worked_Minutes BIGINT,
			@VolunteerType VARCHAR(50),
            @Pending_Minutes BIGINT;

    SELECT 
		@Required_Minutes = CAST(v.min_hours_to_complete AS BIGINT) * 60,
		@VolunteerType = vt.volunteer_type_name
    FROM Volunteers.Volunteer v
	INNER JOIN Volunteers.VolunteerType vt 
		ON v.volunteer_type_id = vt.volunteer_type_id
    WHERE v.volunteer_id = @VolunteerId;

	IF (@VolunteerType = 'Independent Volunteer' OR @Required_Minutes IS NULL)
        RETURN NULL;

	-- Obtain the actual minutes from the first function
    SELECT @Worked_Minutes = Volunteers.FN_WorkedHours(@VolunteerId);

    SET @Pending_Minutes = CASE 
        WHEN @Required_Minutes - @Worked_Minutes < 0 THEN 0 --Volunteer has already completed the minimum number of hours required to work.
        ELSE @Required_Minutes - @Worked_Minutes
    END;

    RETURN @Pending_Minutes;
END;
GO

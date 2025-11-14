/************************************************************
Function: Volunteers.FN_VolunteerStatus

Description: Returns the current status of a volunteer based 
             on the total completed hours vs required hours 
             and type of volunteer.

Author: Karleny Pérez
Created: 2025-11-12
*************************************************************/
CREATE FUNCTION Volunteers.FN_VolunteerStatus(@VolunteerId INT)
RETURNS VARCHAR(20)

AS
BEGIN

	DECLARE @Type VARCHAR(50);

    -- Use of BIGINT to compare
    DECLARE @Required_Minutes BIGINT; 
    DECLARE @Worked_Minutes BIGINT;
    DECLARE @Status VARCHAR(20);

    SELECT 
        @Type = vt.nombre,
        @Required_Minutes = CAST(v.min_hours_to_complete AS BIGINT) * 60 
    FROM Volunteers.Volunteer v
    INNER JOIN Volunteers.VolunteerType vt 
		ON v.volunteer_type_id = vt.volunteer_type_id
    WHERE v.volunteer_id = @VolunteerId;

    IF (@Type = 'Independent Volunteer')
        RETURN 'Not applicable';

    IF (@Required_Minutes IS NULL) 
        RETURN 'Not defined';

    -- Obtain the actual minutes from the standardized function
    SELECT @Worked_Minutes = Volunteers.FN_WorkedHours(@VolunteerId);

    SET @Status = 
        CASE 
            WHEN @Worked_Minutes >= @Required_Minutes THEN 'Completed'
            WHEN @Worked_Minutes = 0 THEN 'Pending'
            ELSE 'In Progress'
        END;

    RETURN @Status;

END;
GO

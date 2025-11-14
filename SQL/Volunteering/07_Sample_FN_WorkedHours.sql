/************************************************************
Function: Volunteers.FN_WorkedHours

Description: Calculates the total number of hours completed 
             by a volunteer, based on recorded attendance.

Author: Karleny Pérez
Created: 2025-11-12
*************************************************************/
CREATE FUNCTION Volunteers.FN_WorkedHours (@VolunteerId INT)
RETURNS BIGINT
AS
BEGIN
    DECLARE @TotalHoursInMinutes BIGINT;

    SELECT @TotalHoursInMinutes = ISNULL(SUM(a.hours_completed + a.extra_hours), 0)
    FROM Volunteers.VolunteerAttendance a
    WHERE a.volunteer_id = @VolunteerId;

    RETURN @TotalHoursInMinutes;
END;
GO

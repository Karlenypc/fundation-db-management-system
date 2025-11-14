/*******************************************************************
* Stored Procedure: Volunteers.SP_DeactivateVolunteer
* Author: Karleny Pérez
* Date: 2025-11-12
*
* Description:
*   Deactivates a volunteer (soft delete technique) by updating
*   the record status flag to inactive (0).
*
* Parameters:
*   @VolunteerId INT   → ID of the volunteer to be deactivated.
*
* Error Handling:
*   - Throws a custom error if the volunteer does not exist.
*   - Captures and rethrows any unexpected SQL errors with a 
*     descriptive message.
*
* Example of execution:
*   EXEC Volunteers.SP_DeactivateVolunteer @VolunteerId = 3;
********************************************************************/
ALTER PROCEDURE Volunteers.SP_DeactivateVolunteer
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
            THROW 52810, 'The volunteer does not exist.', 1;

        UPDATE Volunteers.Volunteer
        SET record_status = 0
        WHERE volunteer_id = @VolunteerId
			AND record_status = 1;

		IF @@ROWCOUNT = 0
			PRINT 'The volunteer had already been deactivated.';
		ELSE
			PRINT 'Volunteer successfully deactivated.';

    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000),
                @CustomMessage NVARCHAR(4000);

        SET @ErrorMessage = ERROR_MESSAGE();
        SET @CustomMessage = '❌ Error deactivating volunteer: ' + @ErrorMessage;

        THROW 52811, @CustomMessage, 1;
    END CATCH;
END;
GO

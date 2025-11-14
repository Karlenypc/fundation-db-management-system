/*******************************************************************
* Stored Procedure: Volunteers.SP_ReactivateVolunteer
*
* Description:
*   Reactivates a previously inactive volunteer by
*   updating the record status flag to active (1).
*
* Parameters:
*   @VolunteerId INT   → ID of the volunteer to be reactivated.
*
* Error Handling:
*   - Throws a custom error if the volunteer does not exist.
*   - Captures and rethrows any unexpected SQL errors with a 
*     descriptive message.
*
* Author: Karleny Pérez
* Date: 2025-11-12
*
* Example of execution:
*   EXEC Volunteers.SP_ReactivateVolunteer @VolunteerId = 3;
********************************************************************/
ALTER PROCEDURE Volunteers.SP_ReactivateVolunteer
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
            THROW 52812, 'The volunteer does not exist.', 1;

        UPDATE Volunteers.Volunteer
        SET record_status = 1
        WHERE volunteer_id = @VolunteerId
			AND record_status = 0;

		IF @@ROWCOUNT = 0
			PRINT 'The volunteer had already been reactivated.';
		ELSE
			PRINT 'Volunteer successfully reactivated.';

    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage VARCHAR(4000),
                @CustomMessage VARCHAR(4000);

        SET @ErrorMessage = ERROR_MESSAGE();
        SET @CustomMessage = '❌ Error reactivating volunteer: ' + @ErrorMessage;

        THROW 52813, @CustomMessage, 1;
    END CATCH;
END;
GO

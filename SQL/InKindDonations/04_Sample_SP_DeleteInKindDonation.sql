/********************************************************************************************
* Stored Procedure: Donations.SP_DeleteInKindDonation
* Author: Karleny Pérez
* Date: 2025-11-11
*
* Description:
*   Deletes an existing in-kind donation from the Donations.DonationInKind table.
*   It validates that the donation exists before attempting deletion.
*
* Parameters:
*   @DonationId INT   → ID of the in-kind donation to be deleted.
*
* Error Handling:
*   - Throws a custom error if the donation does not exist.
*   - Captures and rethrows any unexpected SQL errors with a descriptive message.
*
* Security Management:
*   For the use of this stored procedure, a single user was created who has access to 
*   the donations module, which is one of the most sensitive.
*
* Example of execution:
*   EXEC Donations.SP_DeleteInKindDonation @DonationId = 3;
********************************************************************************************/
ALTER PROCEDURE Donations.SP_DeleteInKindDonation
    @DonationId INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Validate that the donation exists
        IF NOT EXISTS (
            SELECT 1 
            FROM Donations.DonationInKind 
            WHERE id_donation = @DonationId
        )
            THROW 52713, 'The in-kind donation does not exist.', 1;

        -- Delete the record
        DELETE FROM Donations.DonationInKind
        WHERE id_donation = @DonationId;

        PRINT '🗑️ In-kind donation successfully deleted.';

    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage VARCHAR(4000),
                @CustomMessage VARCHAR(4000);

        SET @ErrorMessage = ERROR_MESSAGE();
        SET @CustomMessage = '❌ Error deleting the In-Kind Donation: ' + @ErrorMessage;

        THROW 52714, @CustomMessage, 1;
    END CATCH;
END;
GO

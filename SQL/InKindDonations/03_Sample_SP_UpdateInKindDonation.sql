/************************************************************
* Stored Procedure: Donations.SP_UpdateInKindDonation
*
* Description: Updates an existing in-kind donation when needed.
*
* Security Management:
*   For the use of this stored procedure, a single user was created 
*   who has access to the donations module, which is one of the most 
*   sensitive.
*
* Notes:
*  - Includes validation for inactive or invalid references.
*  - Exception handling with custom error messages.
*
* Restriction:
*    The donor_id cannot be updated for security reasons. 
*    If the user enters the wrong donor_id, they must delete the 
*    entire record and generate it again.
*
* Author: Karleny Pérez
* Date: 2025-11-11
*************************************************************/
ALTER PROCEDURE Donations.SP_UpdateInKindDonation
	@DonationId INT,
    @Date DATE = NULL,
    @ItemType VARCHAR(50) = NULL,
    @Description VARCHAR(250) = NULL,
    @Quantity DECIMAL(12,2) = NULL,
    @UnitId INT = NULL,
    @EstimatedAmount DECIMAL(12,2) = NULL,
    @DestinationId INT = NULL,
    @ReceiptNumber VARCHAR(20) = NULL,
    @Impact VARCHAR(300) = NULL,
    @Notes VARCHAR(250) = NULL

AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
		-- Validate active InKindDonation
		IF NOT EXISTS (
			SELECT 1 
			FROM Donations.InKindDonation 
			WHERE donation_id = @DonationId
		)
            THROW 52706, 'The in kind donation does not exist.', 1;

        -- Validate active donor
        IF @DonorId IS NOT NULL AND NOT EXISTS (
            SELECT 1 
            FROM Donations.Donor
            WHERE donor_id = @DonorId 
              AND record_status = 1
        )
            THROW 52707, 'The donor does not exist or is inactive.', 1;

        -- Validate active measurement unit
        IF @UnitId IS NOT NULL AND NOT EXISTS (
            SELECT 1 
            FROM Donations.UnitOfMeasure
            WHERE unit_id = @UnitId 
              AND record_status = 1
        )
            THROW 52708, 'The unit of measure does not exist or is inactive.', 1;

        -- Validate estimated amount
        IF @EstimatedAmount IS NOT NULL AND @EstimatedAmount < 0
            THROW 52709, 'The estimated amount must be greater than zero.', 1;

        -- Validate active donation destination
        IF @DestinationId IS NOT NULL AND NOT EXISTS (
            SELECT 1 
            FROM Donations.DonationDestinationType
            WHERE destination_type_id = @DestinationId 
              AND record_status = 1
        )
            THROW 52710, 'The destination type does not exist or is inactive.', 1;

        -- Validate duplicate receipt number
        IF @ReceiptNumber IS NOT NULL AND EXISTS (
            SELECT 1 
            FROM Donations.InKindDonation 
            WHERE receipt_number = @ReceiptNumber 
        )
            THROW 52711, 'Another donation with the same receipt number already exists.', 1;

        -- Insert record
        UPDATE Donations.InKindDonation 
		SET
            donor_id = COALESCE(@DonorId, donor_id),
            donation_date = COALESCE(@Date, donation_date),
            item_type = COALESCE(@ItemType, item_type),
            item_description = COALESCE(NULLIF(@Description, ''), item_description),
            quantity = COALESCE(@Quantity, quantity), 
            unit_id = COALESCE(@UnitId, unit_id),
            estimated_amount = COALESCE(@EstimatedAmount, estimated_amount), 
            destination_id = COALESCE(@DestinationId, destination_id),  
            receipt_number = COALESCE(@ReceiptNumber, receipt_number),  
            impact = COALESCE(NULLIF(@Impact, ''), impact),
            notes = COALESCE(NULLIF(@Notes, ''), notes)
		WHERE donation_id = @DonationId;

        PRINT 'In-kind donation successfully updated.';

    END TRY

    BEGIN CATCH
        DECLARE @ErrorMessage VARCHAR(4000),
                @CustomMessage VARCHAR(4000);

        SET @ErrorMessage = ERROR_MESSAGE();
        SET @CustomMessage = '❌ Error updating in-kind donation: ' + @ErrorMessage;

        THROW 52712, @CustomMessage, 1;
    END CATCH
END;
GO

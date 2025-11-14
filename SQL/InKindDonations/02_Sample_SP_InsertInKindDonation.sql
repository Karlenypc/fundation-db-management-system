/************************************************************
* Stored Procedure: Donations.SP_InsertInKindDonation
* Author: Karleny Pérez
* Date: 2025-11-11
*
* Description: Registers a new in-kind donation after validating
*              donor, measurement unit, destination type, and 
*              possible duplicates based on the receipt number.
*
* Security Management:
*   For the use of this stored procedure, a single user was created 
*   who has access to the donations module, which is one of the most 
*   sensitive.
*
* Notes:
*  - Automatically assigns the current date if not provided.
*  - Includes validation for inactive or invalid references.
*  - Exception handling with custom error messages.
*************************************************************/
ALTER PROCEDURE Donations.SP_InsertInKindDonation
    @DonorId INT,
    @Date DATE = NULL,
    @ItemType VARCHAR(50),
    @Description VARCHAR(250) = NULL,
    @Quantity DECIMAL(12,2),
    @UnitId INT,
    @EstimatedAmount DECIMAL(12,2) = NULL,
    @DestinationId INT,
    @ReceiptNumber VARCHAR(20),
    @Impact VARCHAR(300) = NULL,
    @Notes VARCHAR(250) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Validate active donor
        IF NOT EXISTS (
            SELECT 1 
            FROM Donations.Donor
            WHERE donor_id = @DonorId 
              AND record_status = 1
        )
            THROW 52700, 'The donor does not exist or is inactive.', 1;

        -- Assign current date if not provided
        IF @Date IS NULL
            SET @Date = GETDATE();

        -- Validate active measurement unit
        IF NOT EXISTS (
            SELECT 1 
            FROM Donations.UnitOfMeasure
            WHERE unit_id = @UnitId 
              AND record_status = 1
        )
            THROW 52701, 'The unit of measure does not exist or is inactive.', 1;

        -- Validate estimated amount
        IF @EstimatedAmount IS NOT NULL AND @EstimatedAmount < 0
            THROW 52702, 'The estimated amount must be greater than zero.', 1;

        -- Validate active donation destination
        IF NOT EXISTS (
            SELECT 1 
            FROM Donations.DonationDestinationType
            WHERE destination_type_id = @DestinationId 
              AND record_status = 1
        )
            THROW 52703, 'The destination type does not exist or is inactive.', 1;

        -- Validate duplicate receipt number
        IF EXISTS (
            SELECT 1 
            FROM Donations.InKindDonation 
            WHERE receipt_number = @ReceiptNumber 
        )
            THROW 52704, 'Another donation with the same receipt number already exists.', 1;

        -- Insert record
        INSERT INTO Donations.InKindDonation (
            donor_id, 
            donation_date, 
            item_type, 
            item_description, 
            quantity, 
            unit_id,
            estimated_amount, 
            destination_id, 
            receipt_number, 
            impact, 
            notes
        )
        VALUES (
            @DonorId, 
            @Date, 
            @ItemType, 
            NULLIF(@Description, ''), 
            @Quantity, 
            @UnitId,
            @EstimatedAmount, 
            @DestinationId, 
            @ReceiptNumber, 
            NULLIF(@Impact, ''),
            NULLIF(@Notes, '')
        );

        PRINT 'In-kind donation successfully registered.';

    END TRY

    BEGIN CATCH
        DECLARE @ErrorMessage VARCHAR(4000),
                @CustomMessage VARCHAR(4000);

        SET @ErrorMessage = ERROR_MESSAGE();
        SET @CustomMessage = '❌ Error inserting in-kind donation: ' + @ErrorMessage;

        THROW 52705, @CustomMessage, 1;
    END CATCH
END;
GO

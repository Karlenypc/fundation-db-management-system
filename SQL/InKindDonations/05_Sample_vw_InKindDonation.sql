/********************************************************************************************
* View: Donations.vw_InKindDonation
*
* Author: Karleny Pérez
* Date: 2025-11-11
*
* Description:
*   Displays a consolidated view of all in-kind donations with donor, quantity, 
*   destination, and other descriptive information.
*
* Columns:
*   - DonationId          : Unique ID of the donation
*   - DonorIdNumber       : Identification number of the donor
*   - DonorName           : Full name or business name of the donor
*   - Date                : Donation date
*   - ItemType            : Type of in-kind donation
*   - Description         : Description of the item donated
*   - Quantity            : Quantity donated
*   - MeasurementUnit     : Measurement unit associated with the item
*   - EstimatedAmount     : Estimated monetary value
*   - DonationDestination : Destination type of the donation
*   - ReceiptNumber       : Official receipt number
*   - Impact              : Description of donation impact
*   - Observations        : Additional remarks
********************************************************************************************/
ALTER VIEW Donations.vw_InKindDonation
AS
SELECT 
    e.id_donation AS 'DonationId',
    d.id_number AS 'DonorIdNumber',
    d.full_name AS 'DonorName', 
    e.donation_date AS 'Date',
    e.item_type  AS 'ItemType',
    ISNULL(e.item_description, 'Not assigned') AS 'Description',
    e.quantity AS 'Quantity',
    um.unit_name AS 'MeasurementUnit',
    ISNULL(e.estimated_amount, 0) AS 'EstimatedAmount',
    td.destination_name AS 'DonationDestination',
    e.receipt_number AS 'ReceiptNumber',
    ISNULL(e.impact, 'Results not yet known') AS 'Impact',
    ISNULL(e.observations, '') AS 'Observations'
FROM Donations.DonationInKind e
INNER JOIN Donations.Donor d ON e.id_donor = d.id_donor
INNER JOIN Donations.UnitOfMeasure um ON e.unit_id = um.unit_id 
INNER JOIN Donations.DonationDestinationType td ON e.destination_id = td.destination_id;
GO

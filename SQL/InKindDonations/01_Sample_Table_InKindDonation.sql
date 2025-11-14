/*
  Table: InKindDonation
  Description:
    Manages in-kind donations such as food, clothing, or medical supplies.
    This example is part of a real database designed for a nonprofit organization to
    centralize data management.

  Note:
    This script is a sanitized version for demonstration purposes.
    All references and structures are generic.
*/

CREATE TABLE Donations.InKindDonation (
    donation_id INT IDENTITY(1,1) PRIMARY KEY,
    donor_id INT NOT NULL, -- FK to Donor
    donation_date DATE NOT NULL DEFAULT GETDATE(),
    item_type VARCHAR(50) NOT NULL, -- e.g., clothes, food, medicines, etc.
    item_description VARCHAR(250) NULL,
    quantity DECIMAL(12,2) NOT NULL,
    unit_id INT NOT NULL, -- FK to MeasurementUnit
    estimated_amount DECIMAL(12,2) NULL CHECK (estimated_value > 0),
    destination_id INT NOT NULL, -- FK to DestinationType (direct to beneficiaries, sale to generate funds, internal use etc...)
    receipt_number VARCHAR(20) NOT NULL UNIQUE,
    impact VARCHAR(300) NULL, -- describes the purpose or use of the donation and the results obtained
    notes VARCHAR(250) NULL,

    CONSTRAINT FK_InKindDonation_Donor
        FOREIGN KEY (donor_id) REFERENCES Donations.Donor(donor_id),

    CONSTRAINT FK_InKindDonation_Destination
        FOREIGN KEY (destination_id) REFERENCES Donations.DonationDestinationType(destination_id),

    CONSTRAINT FK_InKindDonation_Unit
        FOREIGN KEY (unit_id) REFERENCES Donations.UnitOfMeasure(unit_id)
);

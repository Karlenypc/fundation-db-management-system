/*
  Table: Volunteer
  Description:
    Stores information about the volunteers collaborating with the organization.
    This example is part of a real database designed for a nonprofit organization to
    centralize data management.

  Note:
    This script is a sanitized version for demonstration purposes.
    All references and structures are generic.
*/

CREATE TABLE Volunteers.Volunteer (
    volunteer_id INT PRIMARY KEY IDENTITY(1,1),
    id_number VARCHAR(20) NOT NULL UNIQUE,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    second_last_name VARCHAR(100) NULL,
    phone_number VARCHAR(20) NULL,
    email VARCHAR(150) NULL,
    volunteer_type_id INT NOT NULL, -- FK to VolunteerType
    institution_id INT NULL, -- FK to Institution, NULL for independent volunteers (people who are not because of TCU TCE etc...)
    major VARCHAR(150) NULL,
    job VARCHAR(150) NULL,
    starting_date DATE NOT NULL,
    estimated_end_date DATE NULL,
    min_hours_to_complete INT NULL,
    record_status BIT NOT NULL DEFAULT 1,

    CONSTRAINT FK_Volunteer_Type FOREIGN KEY (volunteer_type_id)
        REFERENCES Volunteers.VolunteerType (volunteer_type_id),

    CONSTRAINT FK_Volunteer_Institution FOREIGN KEY (institution_id)
        REFERENCES Institutions.Institution (institution_id)
);

-- Example of soft-delete technique using record_status
-- 1 = Active, 0 = Inactive

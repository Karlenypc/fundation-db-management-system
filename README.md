# Nonprofit Database Management System  
**Design and Implementation of a Local Database for Information Management**

This repository contains the structured SQL Server and in the next weeks will include the examples of Access-based system (since this project is still under development) as part of my TCU (University Communal Work) project. The goal of the system is to centralize, digitize, and optimize the information management processes of a nonprofit organization, replacing manual workflows previously carried out through Excel files and physical records.

> 🔒 **Note:** For confidentiality purposes, the foundation’s real name and sensitive information have been withheld. Only technical examples are included.

---

## 🚀 Project Purpose

**Objective:**  
Design and implement a centralized local database using **SQL Server Express** and **Microsoft Access** (connected via ODBC) to allow foundation to manage its operational data in a secure, organized, and user-friendly way throughout the third quarter of 2025.

---

## 📌 Scope of the System

Although this repository includes only a few technical examples (tables, views, scripts, stored procedures, and forms), the **full project** covers a complete end-to-end database solution supporting various modules of the foundation’s operations.

### **Main Modules Designed and Implemented**

#### 🧒 **Beneficiaries Module**
- Beneficiary registration
- Responsible guardian information
- Attendance tracking
- Study hours log
- Health attention records
- Vaccination history
- Administrative activation/inactivation flows

#### 🤝 **Volunteering Module**
- Volunteer profiles
- Attendance and hours tracking
- Hours completed / hours pending calculations (T-SQL functions)
- Catalog tables derived from normalization
- Administrative activation/inactivation flows

#### 💰 **Donations Module**
- Monetary donations
- In-kind donations
- Donor information
- Catalog tables derived from normalization
- Administrative activation/inactivation flows

#### 🍽️ **Food Service Control Module**
- Daily meal count
- Meal times (breakfast, lunch, snack, etc.)
- Food service reports per day, month or specific range of time defined by the user

---

## 🔧 System Features & Achievements

- ✔️ Full database normalization (1NF → 3NF)
- ✔️ Entity-Relationship and Logical Model diagrams
- ✔️ Automated business logic through stored procedures, functions, triggers, and views
- ✔️ Secure centralized data storage (previously scattered in Excel sheets)
- ✔️ Significant improvement in data lookup and reporting times
- ✔️ Access front-end with user-friendly forms and printed reports
- ✔️ ODBC DSN connection between Access and SQL Server Express
- ✔️ Foundation staff does not require SQL knowledge—interfaces handle all operations
- ✔️ Reusable modular design for future expansion

---

## 🏗️ Project Development Phases

This project was developed from scratch following standard software engineering stages:

1. **Requirements Gathering**  
   Visit to the fundation to interview staff, process review, data inventory, identification of user needs.

2. **Analysis & Design**  
   - ER modeling  
   - Logical modeling  
   - Normalization   

3. **Database Construction (SQL Server)**  
   - Table structure creation  
   - Views, stored procedures, and scalar functions  
   - Business logic triggers  

4. **ODBC Integration (Access ↔ SQL Server)**  
   Secure and persistent DSN connection.

5. **Current Phase --> Interface Design (Access)**  
   Week 10 of a 13-week schedule, currently finishing the interface and report design.
   - Interactive forms  
   - Validations and calculations  
   - VBA logic to interact with SQL Server  
   - User-friendly reports
  
---

## 🔭 Future Enhancements

The system is planned to expand with:

### 📡 Automated Scanning System  
- Barcode/ID scanning for:
  - Beneficiary attendance  
  - Daily food service registration  
- Automatic identification using ID badges  
- Precise counting of meals served  
- Accurate real-time attendance logs  

### 🏪 Garage (Internal Store) Module  
Management of donated clothing and other items that cannot be delivered directly to beneficiaries and are therefore sold for fundraising:

- Inventory management  
- Sales tracking  
- Revenue records  
- Classification of donated items

### 🕵️‍♂️ Auditing Module
- For traceability of changes and actions  

---

## 🧩 Repository Structure

```plaintext
📁 nonprofit-db-system
 ├── 📁 SQL
 │    ├── Tables
 │    ├── Views
 │    ├── Stored_Procedures
 │    ├── Functions
 │    └── Triggers
 ├── 📁 Documentation
 │    └──  ER Diagram
 ├── 📁 Access_Interface
 │    └── Screenshots (in development)
 ├── LICENSE
 ├── .gitignore
 └── README.md

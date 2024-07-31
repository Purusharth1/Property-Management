CREATE TABLE Company (
    Company_ID INT PRIMARY KEY,
    Name VARCHAR(255),
    Address VARCHAR(255),
    Contact_Number TEXT,
    CEO VARCHAR(255),
    Revenue_in_Crores DECIMAL(18, 2),
    Number_of_Employees INT
);
 

CREATE TABLE Landlord (
    Landlord_ID INT PRIMARY KEY,
    Name VARCHAR(255),
    Contact_Information VARCHAR(255),
    Bank_Account VARCHAR(255),
    Tax_ID VARCHAR(255)
);


-- Employee table
CREATE TABLE Employee (
    Employee_ID INT PRIMARY KEY,
    Name VARCHAR(255),
    Position VARCHAR(255),
    Contact_Information VARCHAR(255),
    Salary DECIMAL(18, 2),
    Department VARCHAR(255),
    Employment_Start_Date DATE,
    Employment_End_Date DATE,
    Company_ID INT,
    FOREIGN KEY (Company_ID) REFERENCES Company(Company_ID)
);

-- Contractor table
CREATE TABLE Contractor (
    Contractor_ID INT PRIMARY KEY,
    Name VARCHAR(255),
    Contact_Information VARCHAR(255),
    Specialization VARCHAR(255),
    Hourly_Rate DECIMAL(18, 2)
);

CREATE TABLE Workers (
    Worker_ID INT PRIMARY KEY,
    Name VARCHAR(255),
    Contact_Information VARCHAR(255),
    Salary DECIMAL(18, 2),
    Contractor_ID INT,
    FOREIGN KEY (Contractor_ID) REFERENCES Contractor(Contractor_ID)
);

CREATE TABLE MaintenanceRequest (
    Maintenance_Request_ID INT PRIMARY KEY,
    Description TEXT,
    Request_Date DATE,
    Status VARCHAR(255),
    Assigned_Contractor_ID INT,
    Completion_Date DATE,
    Cost DECIMAL(18, 2),
    FOREIGN KEY (Assigned_Contractor_ID) REFERENCES Contractor(Contractor_ID)
);




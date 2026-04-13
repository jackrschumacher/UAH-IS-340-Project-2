USE CyberShieldX

CREATE TABLE Analyst(
AnalystID INT NOT NULL,
AnalystFirstName varchar(25) NOT NULL,
AnalystLastName varchar(25) NOT NULL,
Email varchar(25) NOT NULL,
Role varchar(25) NOT NULL,
HireDate DATE NOT NULL,
PRIMARY KEY(AnalystID));

CREATE TABLE Incident(
IncidentID INT NOT NULL,
Title varchar(25) NOT NULL,
CreationTime DATETIME NOT NULL,
Severity varchar(25) NOT NULL,
ResponseDeadline DATETIME NOT NULL,
IsCoordinatedAttack BIT NOT NULL,
AnalystID INT NOT NULL,
PRIMARY KEY(IncidentID));

CREATE TABLE SLARuleTable(
Severity varchar(10) NOT NULL,
ResponseHours INT NOT NULL,
PRIMARY KEY(Severity));

-- TODO Create Lookup table for SLARuleTable

-- Alter Analyst table to add FK- An analyst can respond to many incidents
ALTER TABLE Incident 
ADD FOREIGN KEY (AnalystID) REFERENCES Analyst(AnalystID);


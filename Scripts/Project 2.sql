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
Severity varchar(10) NOT NULL,
ResponseDeadline DATETIME NOT NULL,
IsCoordinatedAttack BIT NOT NULL,
AnalystID INT NOT NULL,
ActionID INT NOT NULL,
PRIMARY KEY(IncidentID));

CREATE TABLE SLARuleTable(
Severity varchar(10) NOT NULL,
ResponseHours INT NOT NULL,
PRIMARY KEY(Severity));

CREATE TABLE Alerts(
AlertID INT NOT NULL,
IncidentID INT NOT NULL,
ToolName varchar(25) NOT NULL,
ThreatScore INT NOT NULL,
Timestamp DATETIME NOT NULL,
PRIMARY KEY(AlertID));

CREATE TABLE Action(
ActionID INT NOT NULL,
IncidentID INT NOT NULL,
AnalystID INT NOT NULL,
ActionDescription TEXT NOT NULL,
Status varchar(25) NOT NULL,
PRIMARY KEY (ActionID));

-- Alter Analyst table to add FK- An analyst can respond to many incidents
ALTER TABLE Incident 
ADD FOREIGN KEY (AnalystID) REFERENCES Analyst(AnalystID);
-- Alter Incident Table to add FK- SLARuleTable
ALTER TABLE Incident
ADD FOREIGN KEY (Severity) REFERENCES SLARuleTable(Severity);
-- Alter Incident table to add FK- ActionID 
ALTER TABLE Incident
ADD FOREIGN KEY (ActionID) REFRENCES Action(ActionID);
-- Alter Action Table to add FK- IncidentID in Action
ALTER TABLE ACTION
ADD FOREIGN KEY (IncidentID) REFERENCES Incident(IncidentID);
-- Alter Alert table to add FK- IncidentID
ALTER TABLE Alerts
ADD FOREIGN KEY (IncidentID) REFERENCES Incident(IncidentID);

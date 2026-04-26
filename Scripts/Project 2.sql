USE CyberShieldX

CREATE TABLE Analyst(
AnalystID INT NOT NULL,
AnalystFirstName varchar(25) NOT NULL,
AnalystLastName varchar(25) NOT NULL,
Email varchar(256) NOT NULL,
Role varchar(100) NOT NULL,
HireDate DATE NOT NULL,
PRIMARY KEY(AnalystID));

CREATE TABLE Incident(
IncidentID INT NOT NULL,
Title varchar(50) NOT NULL,
CreationTime DATETIME NOT NULL,
Severity varchar(10) NOT NULL,
ResponseDeadline DATETIME NOT NULL,
IsCoordinatedAttack BIT NOT NULL,
AnalystID INT,
PRIMARY KEY(IncidentID));

CREATE TABLE SLARuleTable(
Severity varchar(10) NOT NULL,
ResponseHours INT NOT NULL,
PRIMARY KEY(Severity));

CREATE TABLE Alerts(
AlertID INT NOT NULL,
IncidentID INT,
ToolName varchar(100) NOT NULL,
ThreatScore INT NOT NULL,
Timestamp DATETIME NOT NULL,
PRIMARY KEY(AlertID));

CREATE TABLE Action(
ActionID INT NOT NULL,
IncidentID INT,
AnalystID INT,
ActionDescription TEXT NOT NULL,
ActionTimestamp DATETIME NOT NULL,
Status varchar(25) NOT NULL,
PRIMARY KEY (ActionID));

CREATE TABLE ThreatIndicators(
IndicatorID INT NOT NULL,
IndicatorType varchar(30) NOT NULL,
IndicatorValue varchar(500) NOT NULL,
Categories varchar(30) NOT NULL,
PRIMARY KEY (IndicatorID));

CREATE TABLE IncidentThreatIndicators(
IncidentID INT NOT NULL,
IndicatorID INT NOT NULL);
-- Alter Incident Table to add FK- SLARuleTable
ALTER TABLE Incident
ADD FOREIGN KEY (Severity) REFERENCES SLARuleTable(Severity);
-- Alter Incident Table to add FK- AnalystID - One analyist is associated with the Incident response
ALTER TABLE Incident
ADD FOREIGN KEY (AnalystID) REFERENCES Analyst(AnalystID);
-- Alter Action Table to add FK- IncidentID in Action
ALTER TABLE Action
ADD FOREIGN KEY (IncidentID) REFERENCES Incident(IncidentID);
-- Alter Action table to add FK- AnalystID in Action - One Analyst is associated is with an action
ALTER TABLE Action
ADD FOREIGN KEY (AnalystID) REFERENCES Analyst(AnalystID);
-- Alter Alert table to add FK- IncidentID
ALTER TABLE Alerts
ADD FOREIGN KEY (IncidentID) REFERENCES Incident(IncidentID);
-- Alter IncidentThreatIndicators
ALTER TABLE IncidentThreatIndicators
ADD FOREIGN KEY (IncidentID) REFERENCES Incident(IncidentID);
ALTER TABLE IncidentThreatIndicators
ADD FOREIGN KEY (IndicatorID) REFERENCES ThreatIndicators(IndicatorID);

-- Loading data
BULK INSERT Action
FROM "C:\Users\jackr\Documents\UAH\UAH-IS-340-Project-2\Data\Action.csv"
WITH (
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n',
FIRSTROW = 2,
TABLOCK);

BULK INSERT Alerts
FROM "C:\Users\jackr\Documents\UAH\UAH-IS-340-Project-2\Data\Alerts.csv"
WITH (
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n',
FIRSTROW = 2,
TABLOCK);

BULK INSERT Analyst
FROM "C:\Users\jackr\Documents\UAH\UAH-IS-340-Project-2\Data\Analyst.csv"
WITH (
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n',
FIRSTROW = 2,
TABLOCK);

BULK INSERT Incident
FROM "C:\Users\jackr\Documents\UAH\UAH-IS-340-Project-2\Data\Incident.csv"
WITH (
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n',
FIRSTROW = 2,
TABLOCK);

BULK INSERT IncidentThreatIndicators
FROM "C:\Users\jackr\Documents\UAH\UAH-IS-340-Project-2\Data\IncidentThreatIndicators.csv"
WITH (
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n',
FIRSTROW = 2,
TABLOCK);

BULK INSERT SLARuleTable
FROM "C:\Users\jackr\Documents\UAH\UAH-IS-340-Project-2\Data\SLARuleTable.csv"
WITH (
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n',
FIRSTROW = 2,
TABLOCK);

BULK INSERT ThreatIndicators
FROM "C:\Users\jackr\Documents\UAH\UAH-IS-340-Project-2\Data\ThreatIndicators.csv"
WITH (
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n',
FIRSTROW = 2,
TABLOCK);

-- Queries



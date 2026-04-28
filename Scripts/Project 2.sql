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
CONSTRAINT IndicatorTypeValidation CHECK (IndicatorType IN ('IP Address', 'File Hash', 'Domain')),
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
ADD FOREIGN KEY (AnalystID) REFERENCES Analyst(AnalystID)
ON DELETE SET NULL
ON UPDATE SET NULL;
-- Alter Alert table to add FK- IncidentID
ALTER TABLE Alerts
ADD FOREIGN KEY (IncidentID) REFERENCES Incident(IncidentID);
-- Alter IncidentThreatIndicators
ALTER TABLE IncidentThreatIndicators
ADD FOREIGN KEY (IncidentID) REFERENCES Incident(IncidentID)
ON DELETE CASCADE;
ALTER TABLE IncidentThreatIndicators
ADD FOREIGN KEY (IndicatorID) REFERENCES ThreatIndicators(IndicatorID)
ON DELETE CASCADE;

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

-- Q1: List the analystIDs of those who acted on incidents that were marked Critical severity.
SELECT
	DISTINCT A.AnalystID
FROM
	Action A
JOIN Incident I
ON
	A.IncidentID = I.IncidentID
WHERE
	I.Severity = 'Critical';

-- Q2: The SOC lead wants a summary of how each monitoring tool is contributing to alert volume and threat intensity. For each monitoring tool: Report the total number of alerts it generated, and its average threat score. Sort the results in descending order of average threat score to prioritize tools generating the highest-risk signals.
SELECT
	ToolName,
	COUNT(AlertID) AS TotalAlerts,
	AVG(CAST(ThreatScore AS FLOAT)) AS AverageThreatScore
FROM
	Alerts
GROUP BY
	ToolName
ORDER BY
	AverageThreatScore DESC;

-- Q3: The SOC (Security Operations Center) Manager has noticed that some incidents remain open longer than expected, potentially due to insufficient action or delays in response. Prepare a report that highlights all incidents where: The current status of the incident is not "Complete", Only one action has been logged against the incident, and that action is also not marked as 'Complete'. Your output should be only one single table.
SELECT
	I.IncidentID,
	I.Title,
	I.Severity,
	A.ActionID,
	A.ActionDescription,
	A.ActionTimestamp,
	A.Status
FROM
	Incident I
JOIN Action A
ON
	I.IncidentID = A.IncidentID
WHERE
	A.Status <> 'Complete'
	AND I.IncidentID IN (
	SELECT
		IncidentID
	FROM
		Action
	GROUP BY
		IncidentID
	HAVING
		COUNT(*) = 1
);

-- Q4: The compliance officer needs to investigate how well the organization is adhering to its response time commitments. Generate a report listing all incidents where: The severity level has a defined SLA rule, no analyst action was recorded within the allowed SLA response deadline window and the incident is still not marked as "Complete". Include for each incident: the title, severity, creation time, response deadline, and how late the first response is (in hours, if any).
SELECT
	I.IncidentID,
	I.Title,
	I.Severity,
	I.CreationTime,
	I.ResponseDeadline,
	MIN(A.ActionTimestamp) AS FirstResponseTime,
	DATEDIFF(HOUR, I.ResponseDeadline, MIN(A.ActionTimestamp)) AS HoursLate
FROM
	Incident I
JOIN SLARuleTable S
ON
	I.Severity = S.Severity
LEFT JOIN Action A
ON
	I.IncidentID = A.IncidentID
WHERE
	I.IncidentID NOT IN (
	SELECT
		IncidentID
	FROM
		Action
	WHERE
		ActionTimestamp <= (
		SELECT
			ResponseDeadline
		FROM
			Incident
		WHERE
			Incident.IncidentID = Action.IncidentID
)
)
	AND I.IncidentID NOT IN (
	SELECT
		IncidentID
	FROM
		Action
	WHERE
		Status = 'Complete'
)
GROUP BY
	I.IncidentID,
	I.Title,
	I.Severity,
	I.CreationTime,
	I.ResponseDeadline;
-- Q5: Threat assesment standardization
SELECT
ToolName,
COUNT(AlertID) AS NumberOfAlerts,
STDEV(ThreatScore) AS ThreatScoreStandardDeviation
FROM
Alerts
GROUP BY
ToolName
HAVING
COUNT(AlertID) >= 4
ORDER BY
ThreatScoreStandardDeviation DESC;


-- Q6: The threat intel team wants to focus mitigation efforts on the type of indicator (e.g., IP Address, Domain, File Hash) that appears most frequently in phishing-related reports. Your task is to: Identify the IndicatorType with the highest number of ransomware-linked indicators. Then, list the IndicatorID, IndicatorValue, and IndicatorType for all ransomware indicators of that top type.
WITH TopIndicatorType AS (
SELECT
	TOP 1
IndicatorType,
	COUNT(*) AS IndicatorCount
FROM
	ThreatIndicators
WHERE
	Categories = 'Ransomware'
GROUP BY
	IndicatorType
ORDER BY
	COUNT(*) DESC
)
SELECT
	T.IndicatorID,
	T.IndicatorValue,
	T.IndicatorType
FROM
	ThreatIndicators T
JOIN TopIndicatorType X
ON
	T.IndicatorType = X.IndicatorType
WHERE
	T.Categories = 'Ransomware';
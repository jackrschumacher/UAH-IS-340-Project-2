USE CyberShieldX

CREATE TABLE Analyst(
AnalystID INT NOT NULL,
AnalystFirstName varchar(25) NOT NULL,
AnalystLastName varchar(25) NOT NULL,
Email varchar(25) NOT NULL,
Role varchar(25) NOT NULL,
HireDate DATE NOT NULL,
PRIMARY KEY(AnalystID));
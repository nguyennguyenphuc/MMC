-- Active: 1714632121882@@127.0.0.1@3306@information_schema
-- Create Database
CREATE DATABASE Testing_System_Db 

USE Testing_System_Db 

-- Table 1 :Department
CREATE TABLE Department (
    DepartmentID INT AUTO_INCREMENT PRIMARY KEY,
    DepartmentName VARCHAR(255) NOT NULL
);

-- Table 2: Position
CREATE TABLE PositionTable (
    PositionID INT AUTO_INCREMENT PRIMARY KEY,
    PositionName VARCHAR(100) NOT NULL
);


-- Table 3: Account
CREATE TABLE Account (
    AccountID INT AUTO_INCREMENT PRIMARY KEY,
    Email VARCHAR(255) NOT NULL,
    Username VARCHAR(50) NOT NULL,
    FullName VARCHAR(100) NOT NULL,
    DepartmentID INT,
    PositionID INT,
    CreateDate DATETIME NOT NULL,
    FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID),
    FOREIGN KEY (PositionID) REFERENCES PositionTable(PositionID)
);

-- Table 4: Group
CREATE TABLE GroupTable (
    GroupID INT AUTO_INCREMENT PRIMARY KEY,
    GroupName VARCHAR(100) NOT NULL,
    CreatorID INT,
    CreateDate DATETIME NOT NULL,
    FOREIGN KEY (CreatorID) REFERENCES Account(AccountID)
);

-- Table 5: GroupAccount
CREATE TABLE GroupAccount (
    GroupID INT,
    AccountID INT,
    JoinDate DATETIME NOT NULL,
    PRIMARY KEY (GroupID, AccountID),
    FOREIGN KEY (GroupID) REFERENCES GroupTable(GroupID),
    FOREIGN KEY (AccountID) REFERENCES Account(AccountID)
);

-- Table 6: TypeQuestion
CREATE TABLE TypeQuestion (
    TypeID INT AUTO_INCREMENT PRIMARY KEY,
    TypeName VARCHAR(50) NOT NULL
);

-- Table 7: CategoryQuestion
CREATE TABLE CategoryQuestion (
    CategoryID INT AUTO_INCREMENT PRIMARY KEY,
    CategoryName VARCHAR(100) NOT NULL
);

-- Table 8: Question
CREATE TABLE Question (
    QuestionID INT AUTO_INCREMENT PRIMARY KEY,
    Content TEXT NOT NULL,
    CategoryID INT,
    TypeID INT,
    CreatorID INT,
    CreateDate DATETIME NOT NULL,
    FOREIGN KEY (CategoryID) REFERENCES CategoryQuestion(CategoryID),
    FOREIGN KEY (TypeID) REFERENCES TypeQuestion(TypeID),
    FOREIGN KEY (CreatorID) REFERENCES Account(AccountID)
);

-- Table 9: Answer
CREATE TABLE Answer (
    AnswerID INT AUTO_INCREMENT PRIMARY KEY,
    Content TEXT NOT NULL,
    QuestionID INT,
    isCorrect BOOLEAN NOT NULL,
    FOREIGN KEY (QuestionID) REFERENCES Question(QuestionID)
);

-- Table 10: Exam
CREATE TABLE Exam (
    ExamID INT AUTO_INCREMENT PRIMARY KEY,
    Code VARCHAR(50) NOT NULL,
    Title VARCHAR(255) NOT NULL,
    CategoryID INT,
    Duration INT NOT NULL,
    CreatorID INT,
    CreateDate DATETIME NOT NULL,
    FOREIGN KEY (CategoryID) REFERENCES CategoryQuestion(CategoryID),
    FOREIGN KEY (CreatorID) REFERENCES Account(AccountID)
);

-- Table 11: ExamQuestion
CREATE TABLE ExamQuestion (
    ExamID INT,
    QuestionID INT,
    PRIMARY KEY (ExamID, QuestionID),
    FOREIGN KEY (ExamID) REFERENCES Exam(ExamID),
    FOREIGN KEY (QuestionID) REFERENCES Question(QuestionID)
);


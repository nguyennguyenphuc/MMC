/*============================== CREATE DATABASE =======================================*/
-- Create Database
DROP DATABASE IF EXISTS Testing_System_Db;
CREATE DATABASE Testing_System_Db ;

USE Testing_System_Db; 
/*============================== CREATE TABLE ========================================*/
-- Table 1 :Department
DROP TABLE IF EXISTS Department;
CREATE TABLE Department (
    DepartmentID                        TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    DepartmentName                      NVARCHAR(30) NOT NULL UNIQUE KEY
);

-- Table 2: Position
DROP TABLE IF EXISTS `Position`;
CREATE TABLE `Position` (
    PositionID                          TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    PositionName                        ENUM('Dev','Test','Scrum Master','PM') NOT NULL UNIQUE KEY
);


-- Table 3: Account
DROP TABLE IF EXISTS Account;
CREATE TABLE Account (
    AccountID                           TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    Email                               VARCHAR(50) NOT NULL UNIQUE KEY,
    Username                            VARCHAR(50) NOT NULL UNIQUE KEY,
    FullName                            NVARCHAR(50) NOT NULL,
    DepartmentID                        TINYINT UNSIGNED NOT NULL,
    PositionID                          TINYINT UNSIGNED NOT NULL,
    CreateDate                          DATETIME DEFAULT NOW(),
    FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID),
    FOREIGN KEY (PositionID) REFERENCES  `Position`(PositionID)
);

-- Table 4: Group
DROP TABLE IF EXISTS `Group`;
CREATE TABLE `Group` (
    GroupID                             TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    GroupName                           NVARCHAR(50) NOT NULL UNIQUE KEY,
    CreatorID                           TINYINT UNSIGNED,
    CreateDate                          DATETIME DEFAULT NOW(),
    FOREIGN KEY (CreatorID) REFERENCES Account(AccountID)
);

-- Table 5: GroupAccount
DROP TABLE IF EXISTS GroupAccount;
CREATE TABLE GroupAccount (
    GroupID                             TINYINT UNSIGNED NOT NULL,
    AccountID                           TINYINT UNSIGNED NOT NULL,
    JoinDate                            DATETIME DEFAULT NOW(),
    PRIMARY KEY (GroupID, AccountID),
    FOREIGN KEY (GroupID) REFERENCES `Group`(GroupID),
    FOREIGN KEY (AccountID) REFERENCES Account(AccountID)
);

-- Table 6: TypeQuestion
DROP TABLE IF EXISTS TypeQuestion;
CREATE TABLE TypeQuestion (
    TypeID                              TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    TypeName                            ENUM('Essay','Multiple-Choice') NOT NULL UNIQUE KEY
);

-- Table 7: CategoryQuestion
DROP TABLE IF EXISTS CategoryQuestion;
CREATE TABLE CategoryQuestion (
    CategoryID                          TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    CategoryName                        NVARCHAR(100) NOT NULL UNIQUE KEY
);

-- Table 8: Question
DROP TABLE IF EXISTS Question;
CREATE TABLE Question (
    QuestionID                          TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    Content                             NVARCHAR(100) NOT NULL,
    CategoryID                          TINYINT UNSIGNED NOT NULL,
    TypeID                              TINYINT UNSIGNED NOT NULL,
    CreatorID                           TINYINT UNSIGNED NOT NULL,
    CreateDate                          DATETIME DEFAULT NOW(),
    FOREIGN KEY (CategoryID) REFERENCES CategoryQuestion(CategoryID),
    FOREIGN KEY (TypeID) REFERENCES TypeQuestion(TypeID),
    FOREIGN KEY (CreatorID) REFERENCES Account(AccountID)
);

-- Table 9: Answer

DROP TABLE IF EXISTS Answer;
CREATE TABLE Answer (
    AnswerID                            TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    Content                             NVARCHAR(100) NOT NULL,
    QuestionID                          TINYINT UNSIGNED NOT NULL,
    isCorrect                           BIT DEFAULT 1,
    FOREIGN KEY (QuestionID) REFERENCES Question(QuestionID)
);

DROP TABLE IF EXISTS Exam;
-- Table 10: Exam
CREATE TABLE Exam (
    ExamID                              TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    Code                                CHAR(10) NOT NULL,
    Title                               NVARCHAR(50) NOT NULL,
    CategoryID                          TINYINT UNSIGNED NOT NULL,
    Duration                            TINYINT UNSIGNED NOT NULL,
    CreatorID                           TINYINT UNSIGNED NOT NULL,
    CreateDate                          DATETIME DEFAULT NOW(),
    FOREIGN KEY (CategoryID) REFERENCES CategoryQuestion(CategoryID),
    FOREIGN KEY (CreatorID) REFERENCES Account(AccountID)
);

-- Table 11: ExamQuestion
DROP TABLE IF EXISTS ExamQuestion;
CREATE TABLE ExamQuestion (
    ExamID                              TINYINT UNSIGNED NOT NULL,
    QuestionID                          TINYINT UNSIGNED NOT NULL,
    PRIMARY KEY (ExamID, QuestionID),
    FOREIGN KEY (ExamID) REFERENCES Exam(ExamID),
    FOREIGN KEY (QuestionID) REFERENCES Question(QuestionID)
);
/*============================== INSERT DATABASE =======================================*/
INSERT INTO Department  (DepartmentName) 
VALUES                  (N'Phòng Kỹ thuật'),
                        (N'Phòng Nhân sự'),
                        (N'Phòng Kế toán'),
                        (N'Phòng Kinh doanh'),
                        (N'Phòng Marketing'),
                        (N'Phòng Đào tạo'),
                        (N'Phòng Hỗ trợ kỹ thuật'),
                        (N'Phòng Nghiên cứu và phát triển');

-- Add data position
INSERT INTO `Position`	(PositionName	) 
VALUES 					('Dev'			),
						('Test'			),
						('Scrum Master' ),
						('PM'			); 


-- Add data Account
INSERT INTO `Account`(Email								, Username			, FullName				, DepartmentID	, PositionID, CreateDate    )
VALUES 				('nguyen.van.minh@gmail.com'        , 'nguyenvanminh'   , 'Nguyễn Văn Minh'     , 1             , 1         , '2020-03-15'  ),
                    ('tran.thi.hoa@gmail.com'           , 'tranthihoa'      , 'Trần Thị Hoa'        , 2             , 2         , '2020-07-22'  ),
                    ('le.van.tuan@gmail.com'            , 'levantuan'       , 'Lê Văn Tuấn'         , 3             , 3         , '2021-11-30'  ),
                    ('hoang.thi.lan@gmail.com'          , 'hoangthilan'     , 'Hoàng Thị Lan'       , 4             , 4         , NULL          ),
                    ('pham.van.khoi@gmail.com'          , 'phamvankhoi'     , 'Phạm Văn Khoái'      , 5             , 1         , '2020-01-09'  ),
                    ('vu.thi.bao@gmail.com'             , 'vuthibao'        , 'Vũ Thị Bảo'          , 6             , 2         , NULL          ),
                    ('dao.van.quan@gmail.com'           , 'daovanquan'      , 'Đào Văn Quân'        , 7             , 3         , '2021-05-19'  ),
                    ('nguyen.thi.mai@gmail.com'         , 'nguyenthimai'    , 'Nguyễn Thị Mai'      , 8             , 4         , '2021-12-01'  ),
                    ('tran.van.nam@gmail.com'           , 'tranvannam'      , 'Trần Văn Nam'        , 1             , 1         , '2020-02-18'  ),
                    ('le.thi.hue@gmail.com'             , 'lethihue'        , 'Lê Thị Huệ'          , 2             , 2         , '2021-08-23'  ),
                    ('nguyen.van.kien@gmail.com'        , 'nguyenvankien'   , 'Nguyễn Văn Kiên'     , 3             , 3         , NULL          ),
                    ('tran.thi.diem@gmail.com'          , 'tranthidiem'     , 'Trần Thị Diễm'       , 4             , 4         , '2020-06-07'  ),
                    ('le.van.duc@gmail.com'             , 'levanduc'        , 'Lê Văn Đức'          , 5             , 1         , '2021-03-03'  ),
                    ('hoang.thi.nga@gmail.com'          , 'hoangthinga'     , 'Hoàng Thị Nga'       , 6             , 2         , '2020-12-12'  ),
                    ('pham.van.thanh@gmail.com'         , 'phamvanthanh'    , 'Phạm Văn Thành', 7, 3, NULL);

-- Add data Group
INSERT INTO `Group`	(  GroupName			        , CreatorID		, CreateDate    )
VALUES 				(N'Nhóm Phát triển sản phẩm'    , 1             , '2020-03-20'  ),
                    (N'Nhóm Marketing dự án'        , 5             , '2020-06-15'  ),
                    (N'Nhóm Tài chính'              , 7             , '2021-01-25'  ),
                    (N'Nhóm Đào tạo'                , 6             , '2020-11-08'  ),
                    (N'Nhóm Hỗ trợ kỹ thuật'        , 8             , '2021-04-17'  );
-- Add data GroupAccount
INSERT INTO `GroupAccount`	(   GroupID	    , AccountID	    , JoinDate	    )
VALUES 						(   1           , 1             , '2020-04-05'  ),
                            (   1           , 5             , '2020-04-15'  ),
                            (   1           , 9             , '2020-05-01'  ),
                            (   2           , 2             , '2020-07-20'  ),
                            (   2           , 5             , '2020-08-23'  ),
                            (   2           , 10            , '2020-09-19'  ),
                            (   3           , 3             , '2020-10-10'  ),
                            (   3           , 7             , '2020-10-22'  ),
                            (   3           , 8             , '2020-11-05'  ),
                            (   4           , 6             , '2021-01-16'  ),
                            (   4           , 14            , '2021-02-20'  ),
                            (   4           , 15            , '2021-03-14'  ),
                            (   1           , 8             , '2021-04-22'  ),
                            (   2           , 11            , '2021-05-25'  ),
                            (   3           , 12            , '2021-06-17'  );


-- Add data TypeQuestion
INSERT INTO TypeQuestion	(TypeName			) 
VALUES 						('Multiple-Choice'	),  
                            ('Essay'            );


-- Add data CategoryQuestion
INSERT INTO CategoryQuestion		(CategoryName	)
VALUES 								('Python'       ),
                                    ('JavaScript'   ),
                                    ('C++'          ),
                                    ('Java'         ),
                                    ('Ruby'         ),
                                    ('PHP'          ),
                                    ('Swift'        ),
                                    ('Kotlin'       ),
                                    ('Scala'        ),
                                    ('Go'           );
													
-- Add data Question
INSERT INTO Question	(Content			                                                                    , CategoryID, TypeID		, CreatorID	, CreateDate    )
VALUES 					(N'What keyword is used to create a function in Python?'                                , 1         , 1             , 1         , '2020-05-05'  ),
                        (N'What is the default behavior of JavaScript functions when they return no value?'     , 2         , 2             , 2         , '2020-06-15'  ),
                        (N'How can memory leaks be prevented in C++?'                                           , 3         , 2             , 3         , '2020-06-20'  ),
                        (N'What is the difference between abstract classes and interfaces in Java?'             , 4         , 1             , 1         , '2020-07-01'  ),
                        (N'How do you declare a variable in JavaScript?'                                        , 2         , 1             , 2         , '2020-07-15'  ),
                        (N'What is Ruby\'s approach to concurrency?'                                            , 5         , 2             , 3         , '2020-08-05'  ),
                        (N'How can you achieve polymorphism in Java?'                                           , 4         , 1             , 1         , '2020-08-15'  ),
                        (N'What are the major features introduced in PHP 7?'                                    , 6         , 2             , 2         , '2020-08-25'  ),
                        (N'What is Swift\'s primary use?'                                                       , 7         , 2             , 1         , '2020-09-10'  ),
                        (N'What does the keyword "var" do in Kotlin?'                                           , 8         , 1             , 1         , '2020-09-20'  );

-- Add data Answers
INSERT INTO Answer	(Content		                                                        , QuestionID	, isCorrect	)
VALUES 				(N'def'                                                                 , 1             , 1         ),
                    (N'undefined'                                                           , 2             , 1         ),
                    (N'Proper memory management'                                            , 3             , 0         ),
                    (N'Interfaces support multiple inheritance, abstract classes do not.'   , 4             , 1         ),
                    (N'let or var'                                                          , 5             , 1         ),
                    (N'Threads and fibers'                                                  , 6             , 0         ),
                    (N'Using inheritance and interfaces'                                    , 7             , 1         ),
                    (N'Improved performance and new type system'                            , 8             , 1         ),
                    (N'Develop iOS applications'                                            , 9             , 1         ),
                    (N'Declares a variable'                                                 , 10            , 1         );
-- Add data Exam
INSERT INTO Exam	(`Code`			, Title					                        , CategoryID	, Duration	, CreatorID		, CreateDate    )
VALUES 				('EXM101'       ,  N'Python Fundamentals'                       , 1             , 60        , 1             , '2020-10-01'  ),
                    ('EXM102'       , N'Advanced JavaScript'                        , 2             , 90        , 2             , '2020-10-10'  ),
                    ('EXM103'       , N'C++ Memory Management'                      , 3             , 90        , 3             , '2020-11-01'  ),
                    ('EXM104'       , N'Java Interfaces and Abstract Classes'       , 4             , 60        , 4             , '2020-11-10'  ),
                    ('EXM105'       , N'JavaScript Variables and Scopes'            , 2             , 60        , 2             , '2020-11-15'  ),
                    ('EXM106'       , N'Concurrent Programming in Ruby'             , 5             , 60        , 5             , '2020-12-01'  ),
                    ('EXM107'       , N'Polymorphism in Java'                       , 4             , 60        , 4             , '2020-12-10'  ),
                    ('EXM108'       , N'PHP 7 Features'                             , 6             , 90        , 6             , '2021-01-01'  ),
                    ('EXM109'       , N'Swift for iOS Development'                  , 7             , 90        , 7             , '2021-01-10'  ),
                    ('EXM110'       , N'Introduction to Kotlin'                     , 8             , 60        , 8             , '2021-01-20'  );
                    
                    
-- Add data ExamQuestion
INSERT INTO ExamQuestion(ExamID	, QuestionID	) 
VALUES 					(1      , 1             ),    -- Python Fundamentals includes a Python question
                        (2      , 2             ),    -- Advanced JavaScript includes a JavaScript question
                        (2      , 5             ),    -- Also includes another JavaScript question
                        (3      , 3             ),    -- C++ Memory Management includes a C++ question
                        (4      , 4             ),    -- Java Interfaces and Abstract Classes includes a Java question
                        (4      , 7             ),    -- Also includes another Java question
                        (5      , 5             ),    -- JavaScript Variables and Scopes includes a JavaScript question
                        (6      , 6             ),    -- Concurrent Programming in Ruby includes a Ruby question
                        (7      , 7             ),    -- Polymorphism in Java includes a Java question
                        (8      , 8             ),    -- PHP 7 Features includes a PHP question
                        (9      , 9             ),    -- Swift for iOS Development includes a Swift question
                        (10     , 10            );  -- Introduction to Kotlin includes a Kotlin question


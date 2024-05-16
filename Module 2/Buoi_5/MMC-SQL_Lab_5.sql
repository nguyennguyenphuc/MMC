USE testing_system_db;

-- Question 1: Tạo view có chứa danh sách nhân viên thuộc phòng ban sale
CREATE VIEW employees_sales AS
	SELECT a.*
    FROM account a
    INNER JOIN department p ON a.DepartmentID=p.DepartmentID
    WHERE p.DepartmentName="Phòng Marketing";

-- Question 2: Tạo view có chứa thông tin các account tham gia vào nhiều group nhất
CREATE VIEW MostAccount AS
	SELECT a.*, COUNT(1) As GroupCounts
	FROM account a
	INNER JOIN groupaccount ga 
	WHERE ga.AccountID=a.AccountID
	GROUP BY ga.AccountID
	HAVING COUNT(1)=(SELECT MAX(GroupCount) 
					FROM	(SELECT COUNT(1) AS GroupCount
							FROM groupaccount 
							GROUP BY AccountID) AS Counts)
;

-- Question 3: Tạo view có chứa câu hỏi có những content quá dài (content quá 300 từ được coi là quá dài) và xóa nó đi
CREATE VIEW LongContentQuestions AS
SELECT 
    QuestionID, 
    Content, 
    CategoryID, 
    TypeID, 
    CreatorID, 
    CreateDate
FROM 
    Question
WHERE 
    LENGTH(Content)  > 300;
DELETE FROM Question
WHERE QuestionID IN (
    SELECT QuestionID 
    FROM LongContentQuestions
);
-- Question 4: Tạo view có chứa danh sách các phòng ban có nhiều nhân viên nhất
CREATE VIEW DepartmentsWithMostEmployees AS
SELECT
    d.DepartmentID,
    d.DepartmentName,
    a.EmployeeCount
FROM
    Department d
INNER JOIN
    (
        SELECT
            DepartmentID,
            COUNT(AccountID) AS EmployeeCount
        FROM
            Account
        GROUP BY
            DepartmentID
        HAVING
            COUNT(AccountID) = (
                SELECT MAX(EmployeeCount)
                FROM (
                    SELECT COUNT(AccountID) AS EmployeeCount
                    FROM Account
                    GROUP BY DepartmentID
                ) AS SubQuery
            )
    ) AS a
ON
    d.DepartmentID = a.DepartmentID;


--  Question 5: Tạo view chứa tất cả các câu hỏi do người dùng họ Nguyễn tạo
CREATE VIEW QuestionsByNguyen AS
SELECT
    q.*,
    a.FullName
FROM
    Question q
INNER JOIN
    Account a ON q.CreatorID = a.AccountID
WHERE
    a.FullName LIKE 'Nguyễn%';
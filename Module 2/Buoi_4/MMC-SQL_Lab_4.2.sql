USE testing_system_db;
-- Question 1: Viết lệnh để lấy ra danh sách nhân viên và thông tin phòng ban của họ
SELECT a.AccountID, a.FullName, a.Email, d.DepartmentName
FROM account a
INNER JOIN department d ON a.DepartmentID = d.DepartmentID;

-- Question 2: Viết lệnh để lấy ra thông tin các account được tạo sau ngày 20/12/2010

SELECT *
FROM account
WHERE CreateDate > '2010-12-20';

-- Question 3: Viết lệnh để lấy ra tất cả các developer

SELECT a.AccountID, a.FullName, a.Email, p.PositionName
FROM Account a
JOIN Position p ON a.PositionID = p.PositionID
WHERE p.PositionName = 'Dev';

-- Question 4: Viết lệnh để lấy ra danh sách các phòng ban có >3 nhân viên

SELECT		D.*, COUNT(A.DepartmentID) AS 'SL'
FROM		`Account` A
INNER JOIN	Department D
ON			A.DepartmentID = D.DepartmentID
GROUP BY	A.DepartmentID
HAVING		COUNT(A.DepartmentID) > 3;

-- Question 5: Viết lệnh để lấy ra danh sách câu hỏi được sử dụng trong đề thi nhiều nhất

SELECT q.*, COUNT(1) AS UsageCount
FROM Question q
INNER JOIN ExamQuestion eq ON q.QuestionID = eq.QuestionID
GROUP BY q.QuestionID
HAVING COUNT(1) = (SELECT MAX(QuestionCount) 
					FROM ( SELECT COUNT(*) AS QuestionCount 
							FROM ExamQuestion 
							GROUP BY QuestionID) AS Counts);
-- Question 6: Thống kê mỗi category Question được sử dụng trong bao nhiêu Question
SELECT cq.*, COUNT(1) AS UsageCount
FROM Question q
INNER JOIN CategoryQuestion cq on q.CategoryID=cq.CategoryID
GROUP BY CategoryID;

-- Question 7: Thống kê mỗi Question được sử dụng trong bao nhiêu Exam
                                              
SELECT q.QuestionID, q.Content, q.TypeID, q.CreateDate, COUNT(1) AS UsageCount
FROM Question q
INNER JOIN ExamQuestion eq on q.QuestionID=eq.QuestionID
GROUP BY QuestionID;

-- Question 8: Lấy ra Question có nhiều câu trả lời nhất
SELECT q.QuestionID, q.Content, q.TypeID, q.CreateDate, COUNT(1) AS UsageCount
FROM Question q
INNER JOIN Answer a ON q.QuestionID = a.QuestionID
GROUP BY a.QuestionID
HAVING COUNT(1) = (SELECT MAX(QuestionCount) 
					FROM ( SELECT COUNT(*) AS QuestionCount 
							FROM Answer 
						    GROUP BY QuestionID) AS Counts);
-- Question 9: Thống kê số lượng account trong mỗi group
SELECT g.*, COUNT(AccountID) as NumberofAccount
FROM GroupAccount ga
INNER JOIN `group` g on g.GroupID=ga.GroupID
GROUP BY GroupID;

-- Question 10: Tìm chức vụ có ít người nhất
SELECT p.*, COUNT(a.AccountID) AS NumberOfAcount
FROM account a
INNER JOIN position p ON p.PositionID=a.PositionID
GROUP BY a.PositionID
HAVING COUNT(a.AccountID) = (SELECT MIN(AccountCount)
							FROM (SELECT COUNT(1) as AccountCount
								  From account
                                  GROUP BY PositionID)
							as Counts)
;

-- Question 11: Thống kê mỗi phòng ban có bao nhiêu dev, test, scrum master, PM
SELECT 
    d.DepartmentName,
    p.PositionName,
    COUNT(a.AccountID) AS NumberOfEmployees
FROM Department d
LEFT JOIN Account a ON d.DepartmentID = a.DepartmentID
LEFT JOIN Position p ON a.PositionID = p.PositionID
GROUP BY d.DepartmentName, p.PositionName;
-- Question 12: Lấy thông tin chi tiết của câu hỏi bao gồm: thông tin cơ bản của
-- question, loại câu hỏi, ai là người tạo ra câu hỏi, câu trả lời là gì, …

SELECT 
    q.QuestionID,
    q.Content AS QuestionContent,
    cq.CategoryName,
    tq.TypeName AS QuestionType,
    a.FullName AS CreatorName,
    q.CreateDate AS QuestionCreateDate,
    ans.AnswerID,
    ans.Content AS AnswerContent,
    ans.isCorrect 
FROM Question q
LEFT JOIN CategoryQuestion cq ON q.CategoryID = cq.CategoryID
LEFT JOIN TypeQuestion tq ON q.TypeID = tq.TypeID
LEFT JOIN Account a ON q.CreatorID = a.AccountID
LEFT JOIN Answer ans ON q.QuestionID = ans.QuestionID;
-- Question 14: Lấy ra group không có account nào
SELECT GroupID, GroupName
FROM `group`
WHERE GroupID NOT IN (SELECT DISTINCT GroupID FROM GroupAccount);

-- Question 13: Lấy ra số lượng câu hỏi của mỗi loại tự luận hay trắc nghiệm
SELECT 
    tq.TypeName AS QuestionType,
    COUNT(q.QuestionID) AS NumberOfQuestions
FROM TypeQuestion tq
LEFT JOIN Question q ON tq.TypeID = q.TypeID
GROUP BY tq.TypeID;

-- Question 16: Lấy ra question không có answer nào

SELECT q.QuestionID, q.Content
FROM Question q
LEFT JOIN Answer a ON q.QuestionID = a.QuestionID
WHERE a.AnswerID IS NULL;

-- Question 17:
-- a) Lấy các account thuộc nhóm thứ 1

SELECT a.*
FROM `GroupAccount` ga
INNER JOIN Account a ON ga.AccountID = a.AccountID
WHERE ga.GroupID = 1;

-- b) Lấy các account thuộc nhóm thứ  2

SELECT a.*
FROM `GroupAccount` ga
JOIN Account a ON ga.AccountID = a.AccountID
WHERE ga.GroupID = 2;

-- c) Ghép 2 kết quả từ câu a) và câu b)

-- Sử dụng UNION để ghép kết quả
(SELECT a.*
 FROM `GroupAccount` ga
 JOIN Account a ON ga.AccountID = a.AccountID
 WHERE ga.GroupID = 1)
UNION
(SELECT a.*
 FROM `GroupAccount` ga
 JOIN Account a ON ga.AccountID = a.AccountID
 WHERE ga.GroupID = 2);
 
 -- Question 18:
 -- a) Lấy các group có lớn hơn 5 thành viên
SELECT g.GroupID, g.GroupName
FROM `group` g
JOIN GroupAccount ga ON g.GroupID = ga.GroupID
GROUP BY g.GroupID, g.GroupName
HAVING COUNT(ga.AccountID) > 5;

 -- b) Lấy các group có nhỏ hơn 7 thành viên
 
SELECT g.GroupID, g.GroupName
FROM `group` g
JOIN GroupAccount ga ON g.GroupID = ga.GroupID
GROUP BY g.GroupID, g.GroupName
HAVING COUNT(ga.AccountID) < 7;

 -- c) Ghép 2 kết quả từ câu a) và câu b)
(SELECT g.GroupID, g.GroupName
 FROM `group` g
JOIN GroupAccount ga ON g.GroupID = ga.GroupID
GROUP BY g.GroupID, g.GroupName
HAVING COUNT(ga.AccountID) > 5)
UNION
(SELECT g.GroupID, g.GroupName
FROM `group` g
JOIN GroupAccount ga ON g.GroupID = ga.GroupID
GROUP BY g.GroupID, g.GroupName
HAVING COUNT(ga.AccountID) < 7);
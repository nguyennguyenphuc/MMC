USE testing_system_db;
-- Question 1: Tạo store để người dùng nhập vào tên phòng ban và in ra tất cả các account
-- thuộc phòng ban đó
DROP PROCEDURE IF EXISTS GetAccountsByDepartment;
DELIMITER //
CREATE PROCEDURE GetAccountsByDepartment(IN departmentName VARCHAR(255))
BEGIN
    SELECT 
        a.*,
        d.DepartmentName
    FROM 
        account a
    INNER JOIN 
        Department d ON a.DepartmentID = d.DepartmentID
    WHERE 
        d.DepartmentName = departmentName;
END //
DELIMITER ;

CALL GetAccountsByDepartment('Phòng Kỹ Thuật');

-- Question 2: Tạo store để in ra số lượng account trong mỗi group
DROP PROCEDURE IF EXISTS GetAccountCountByGroup;
DELIMITER //
CREATE PROCEDURE GetAccountCountByGroup()
BEGIN
    SELECT 
        g.GroupName,
        COUNT(ga.AccountID) AS AccountCount
    FROM 
        `Group` g
    LEFT JOIN 
        GroupAccount ga ON g.GroupID = ga.GroupID
    GROUP BY 
        g.GroupID, g.GroupName;
END //
DELIMITER ;

CALL GetAccountCountByGroup();

-- Question 3: Tạo store để thống kê mỗi type question có bao nhiêu question được tạo
-- trong tháng hiện tại
DROP PROCEDURE IF EXISTS GetQuestionCountByTypeForCurrentMonth;
DELIMITER //
CREATE PROCEDURE GetQuestionCountByTypeForCurrentMonth()
BEGIN
    SELECT 
        tq.TypeName,
        COUNT(q.QuestionID) AS QuestionCount
    FROM 
        Question q
    INNER JOIN 
        TypeQuestion tq ON q.TypeID = tq.TypeID
    WHERE 
        MONTH(q.CreateDate) = MONTH(CURRENT_DATE)
        AND YEAR(q.CreateDate) = YEAR(CURRENT_DATE)
    GROUP BY 
        tq.TypeID, tq.TypeName;
END //
DELIMITER ;

CALL GetQuestionCountByTypeForCurrentMonth();

-- Question 4: Tạo store để trả ra id của type question có nhiều câu hỏi nhất
DROP PROCEDURE IF EXISTS GetTypeQuestionWithMostQuestions;
DELIMITER //
CREATE PROCEDURE GetTypeQuestionWithMostQuestions()
BEGIN
    -- Tìm số lượng câu hỏi nhiều nhất cho mỗi loại câu hỏi
    SELECT 
        q.TypeID
    FROM 
        Question q
    GROUP BY 
        q.TypeID
    HAVING 
        COUNT(q.QuestionID) = (
            SELECT 
                MAX(QuestionCount)
            FROM 
                (SELECT 
                    COUNT(q2.QuestionID) AS QuestionCount
                FROM 
                    Question q2
                GROUP BY 
                    q2.TypeID) AS SubQuery
        );
END //
DELIMITER ;

CALL GetTypeQuestionWithMostQuestions();

-- Question 6: Viết 1 store cho phép người dùng nhập vào 1 chuỗi và trả về group có tên
-- chứa chuỗi của người dùng nhập vào hoặc trả về user có username chứa chuỗi của
-- người dùng nhập vào
DROP PROCEDURE IF EXISTS SearchGroupsAndUsers;
DELIMITER //
CREATE PROCEDURE SearchGroupsAndUsers(IN searchString VARCHAR(255))
BEGIN
    -- Truy vấn các nhóm có tên chứa chuỗi tìm kiếm
    SELECT 
        'Group' AS ResultType,
        g.GroupID AS ID,
        g.GroupName AS Name
    FROM 
        `Group` g
    WHERE 
        g.GroupName LIKE CONCAT('%', searchString, '%')
    UNION ALL
    -- Truy vấn các người dùng có tên người dùng chứa chuỗi tìm kiếm
    SELECT 
        'User' AS ResultType,
        a.AccountID AS ID,
        a.Username AS Name
    FROM 
        Account a
    WHERE 
        a.Username LIKE CONCAT('%', searchString, '%');
END //
DELIMITER ;
CALL SearchGroupsAndUsers('Nhóm');
-- Question 7: Viết 1 store cho phép người dùng nhập vào thông tin fullName, email và
-- 				trong store sẽ tự động gán:
-- 					username sẽ giống email nhưng bỏ phần @..mail đi
-- 					positionID: sẽ có default là developer
-- 					departmentID: sẽ được cho vào 1 phòng chờ
-- 				Sau đó in ra kết quả tạo thành công
DROP PROCEDURE IF EXISTS CreateUser;
DELIMITER //
CREATE PROCEDURE CreateUser(
    IN fullName VARCHAR(255),
    IN email VARCHAR(255)
)
BEGIN
    -- Khai báo các biến để lưu các giá trị gán tự động
    DECLARE username VARCHAR(255);
    DECLARE defaultPositionID INT DEFAULT 1; -- Giả sử positionID của Developer là 1
    DECLARE waitingDepartmentID INT DEFAULT 1; -- Giả sử departmentID của phòng chờ là 1

    -- Gán giá trị cho biến username bằng cách bỏ phần @..mail đi
    SET username = LEFT(email, INSTR(email, '@') - 1);

    -- Thêm bản ghi mới vào bảng Account
    INSERT INTO Account (FullName, Email, Username, PositionID, DepartmentID, CreateDate)
    VALUES (fullName, email, username, defaultPositionID, waitingDepartmentID, NOW());

    -- In ra kết quả tạo thành công
    SELECT 'User created successfully' AS Message, 
           LAST_INSERT_ID() AS AccountID, 
           fullName AS FullName, 
           email AS Email, 
           username AS Username, 
           defaultPositionID AS PositionID, 
           waitingDepartmentID AS DepartmentID;
END //
DELIMITER ;
CALL CreateUser('Nguyen Thi Hong Diep', 'diep.nguyen@example.com');
-- Question 8: Viết 1 store cho phép người dùng nhập vào Essay hoặc Multiple-Choice để
-- thống kê câu hỏi essay hoặc multiple-choice nào có content dài nhất
DROP PROCEDURE IF EXISTS GetLongestQuestionsByType;
DELIMITER //

CREATE PROCEDURE GetLongestQuestionsByType(IN questionType VARCHAR(255))
BEGIN
    -- Tìm độ dài lớn nhất của nội dung câu hỏi theo loại câu hỏi
    DECLARE maxLength INT;

    SELECT 
        MAX(LENGTH(q.Content))
    INTO 
        maxLength
    FROM 
        Question q
    INNER JOIN 
        TypeQuestion tq ON q.TypeID = tq.TypeID
    WHERE 
        tq.TypeName = questionType;

    -- Lấy tất cả các câu hỏi có độ dài nội dung bằng với độ dài lớn nhất
    SELECT 
        q.QuestionID,
        q.Content,
        LENGTH(q.Content) AS ContentLength,
        tq.TypeName
    FROM 
        Question q
    INNER JOIN 
        TypeQuestion tq ON q.TypeID = tq.TypeID
    WHERE 
        tq.TypeName = questionType
        AND LENGTH(q.Content) = maxLength;
END //
DELIMITER ;
CALL GetLongestQuestionsByType('Essay');
CALL GetLongestQuestionsByType('Multiple-Choice');

-- Question 9: Viết 1 store cho phép người dùng xóa exam dựa vào ID
DROP PROCEDURE IF EXISTS DeleteExamByID;
DELIMITER //
CREATE PROCEDURE DeleteExamByID(IN examID INT)
BEGIN
    -- Xóa các bản ghi trong bảng ExamQuestion liên quan đến ExamID
    DELETE FROM ExamQuestion
    WHERE ExamID = examID;

    -- Xóa bản ghi trong bảng Exam dựa vào ExamID
    DELETE FROM Exam
    WHERE ExamID = examID;

    -- Trả về thông báo thành công
    SELECT CONCAT('Exam with ID ', examID, ' has been successfully deleted.') AS Message;
END //
DELIMITER ;

-- Question 10: Tìm ra các exam được tạo từ 3 năm trước và xóa các exam đó đi (sử dụng
-- store ở câu 9 để xóa). Sau đó in số lượng record đã remove từ các table liên quan trong khi removing
DROP PROCEDURE IF EXISTS DeleteOldExams;
DELIMITER //
CREATE PROCEDURE DeleteOldExams()
BEGIN
    -- Khai báo biến để lưu tổng số bài thi đã xóa
    DECLARE totalExamsDeleted INT DEFAULT 0;
    DECLARE totalExamQuestionsDeleted INT DEFAULT 0;

    -- Khai báo biến để lưu ExamID
    DECLARE examID INT;

    -- Khai báo con trỏ để duyệt qua các ExamID cần xóa
    DECLARE cur CURSOR FOR
    SELECT ExamID FROM Exam WHERE CreateDate <= DATE_SUB(CURDATE(), INTERVAL 3 YEAR);

    -- Khai báo lỗi để xử lý kết thúc con trỏ
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- Khai báo biến để kiểm tra kết thúc con trỏ
    DECLARE done INT DEFAULT 0;

    -- Mở con trỏ
    OPEN cur;

    -- Lặp qua từng ExamID và xóa
    read_loop: LOOP
        FETCH cur INTO examID;
        IF done THEN
            LEAVE read_loop;
        END IF;
      
        -- Gọi stored procedure để xóa bản ghi trong bảng Exam
        CALL DeleteExamByID(examID);
        SET totalExamsDeleted = totalExamsDeleted + ROW_COUNT();
        SET totalExamQuestionsDeleted = totalExamQuestionsDeleted + ROW_COUNT();
    END LOOP;

    -- Đóng con trỏ
    CLOSE cur;

    -- Trả về số lượng bản ghi đã xóa
    SELECT totalExamQuestionsDeleted AS ExamQuestionsDeleted, totalExamsDeleted AS ExamsDeleted;
END //

DELIMITER ;

-- Question 12: Viết store để in ra mỗi tháng có bao nhiêu câu hỏi được tạo trong năm nay
DROP PROCEDURE IF EXISTS GetMonthlyQuestionCountForCurrentYear;
DELIMITER //
CREATE PROCEDURE GetMonthlyQuestionCountForCurrentYear()
BEGIN
    SELECT 
        MONTH(CreateDate) AS Month,
        COUNT(QuestionID) AS QuestionCount
    FROM 
        Question
    WHERE 
        YEAR(CreateDate) = YEAR(CURDATE())
    GROUP BY 
        MONTH(CreateDate)
    ORDER BY 
        MONTH(CreateDate);
END //
DELIMITER ;
CALL GetMonthlyQuestionCountForCurrentYear();
-- Question 13: Viết store để in ra mỗi tháng có bao nhiêu câu hỏi được tạo trong 6 tháng
-- gần đây nhất
-- (Nếu tháng nào không có thì sẽ in ra là "không có câu hỏi nào trong tháng")
DROP PROCEDURE IF EXISTS GetMonthlyQuestionCountForLastSixMonths;
DELIMITER //

CREATE PROCEDURE GetMonthlyQuestionCountForLastSixMonths()
BEGIN
    -- Truy vấn để lấy số lượng câu hỏi được tạo trong mỗi tháng trong 6 tháng gần đây nhất
    SELECT
        DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL seq MONTH), '%Y-%m') AS MonthYear,
        IFNULL(q.QuestionCount, 0) AS QuestionCount,
        IFNULL(CONCAT('Có ', q.QuestionCount, ' câu hỏi trong tháng'), 'Không có câu hỏi nào trong tháng') AS Message
    FROM (
        SELECT 0 AS seq UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5
    ) AS seq_table
    LEFT JOIN (
        SELECT 
            DATE_FORMAT(CreateDate, '%Y-%m') AS MonthYear,
            COUNT(QuestionID) AS QuestionCount
        FROM 
            Question
        WHERE 
            CreateDate >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
        GROUP BY 
            DATE_FORMAT(CreateDate, '%Y-%m')
    ) AS q ON DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL seq_table.seq MONTH), '%Y-%m') = q.MonthYear
    ORDER BY 
        MonthYear;
END //

DELIMITER ;
CALL GetMonthlyQuestionCountForLastSixMonths();



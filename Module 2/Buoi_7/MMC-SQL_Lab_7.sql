USE testing_system_db;
-- Question 1: Tạo trigger không cho phép người dùng nhập vào Group có ngày tạo trước 1 năm trước
DROP TRIGGER IF EXISTS check_group_create_date_before_insert;
DELIMITER //
CREATE TRIGGER check_group_create_date_before_insert
BEFORE INSERT ON `Group`
FOR EACH ROW
BEGIN
    -- Kiểm tra nếu ngày tạo của nhóm trước 1 năm so với ngày hiện tại
    IF NEW.CreateDate < DATE_SUB(CURDATE(), INTERVAL 1 YEAR) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Không được phép tạo nhóm có ngày tạo trước 1 năm trước';
    END IF;
END//
DELIMITER ;
-- Question 2: Tạo trigger Không cho phép người dùng thêm bất kỳ user nào vào
-- department "Sale" nữa, khi thêm thì hiện ra thông báo "Department "Sale" cannot add
-- more user"
DROP TRIGGER IF EXISTS check_department_before_insert;
DELIMITER //
CREATE TRIGGER check_department_before_insert
BEFORE INSERT ON Account
FOR EACH ROW
BEGIN
    DECLARE deptName VARCHAR(255);
    -- Lấy tên phòng ban từ bảng Department
    SELECT DepartmentName INTO deptName
    FROM Department
    WHERE DepartmentID = NEW.DepartmentID;
    -- Kiểm tra nếu tên phòng ban là "Sale"
    IF deptName = 'Sale' THEN
        SIGNAL SQLSTATE '45001'
        SET MESSAGE_TEXT = 'Department "Sale" cannot add more user';
    END IF;
END//
DELIMITER ;
-- Question 3: Cấu hình 1 group có nhiều nhất là 5 user
DROP TRIGGER IF EXISTS check_group_user_limit_before_insert;
DELIMITER //
CREATE TRIGGER check_group_user_limit_before_insert
BEFORE INSERT ON GroupAccount
FOR EACH ROW
BEGIN
    DECLARE userCount INT;
    -- Đếm số lượng user hiện tại trong group
    SELECT COUNT(*) INTO userCount
    FROM GroupAccount
    WHERE GroupID = NEW.GroupID;
    -- Kiểm tra nếu số lượng user trong group đã đạt đến giới hạn 5
    IF userCount >= 5 THEN
        SIGNAL SQLSTATE '45002'
        SET MESSAGE_TEXT = 'A group cannot have more than 5 users';
    END IF;
END//
DELIMITER ;
-- Question 4: Cấu hình 1 bài thi có nhiều nhất là 10 Question
DROP TRIGGER IF EXISTS check_exam_question_limit_before_insert;
DELIMITER //
CREATE TRIGGER check_exam_question_limit_before_insert
BEFORE INSERT ON ExamQuestion
FOR EACH ROW
BEGIN
    DECLARE questionCount INT;

    -- Đếm số lượng câu hỏi hiện tại trong bài thi
    SELECT COUNT(*) INTO questionCount
    FROM ExamQuestion
    WHERE ExamID = NEW.ExamID;

    -- Kiểm tra nếu số lượng câu hỏi trong bài thi đã đạt đến giới hạn 10
    IF questionCount >= 10 THEN
        SIGNAL SQLSTATE '45003'
        SET MESSAGE_TEXT = 'An exam cannot have more than 10 questions';
    END IF;
END//
DELIMITER ;
-- Question 5: Tạo trigger không cho phép người dùng xóa tài khoản có email là
-- admin@gmail.com (đây là tài khoản admin, không cho phép user xóa), còn lại các tài
-- khoản khác thì sẽ cho phép xóa và sẽ xóa tất cả các thông tin liên quan tới user đó.
DROP TRIGGER IF EXISTS before_account_delete;
DELIMITER //
CREATE TRIGGER before_account_delete
BEFORE DELETE ON Account
FOR EACH ROW
BEGIN
    IF OLD.Email = 'admin@gmail.com' THEN
        SIGNAL SQLSTATE '45004'
        SET MESSAGE_TEXT = 'Cannot delete admin account';
    ELSE
        DELETE FROM GroupAccount WHERE AccountID = OLD.AccountID;
        DELETE FROM `Group` WHERE CreatorID = OLD.AccountID;
    END IF;
END//
DELIMITER ;
-- Question 6: Không sử dụng cấu hình default cho field DepartmentID của table Account,
-- hãy tạo trigger cho phép người dùng khi tạo account không điền vào departmentID thì
-- sẽ được phân vào phòng ban "waiting Department".
DROP TRIGGER IF EXISTS before_account_insert;
DELIMITER //
CREATE TRIGGER before_account_insert
BEFORE INSERT ON Account
FOR EACH ROW
BEGIN
    IF NEW.DepartmentID IS NULL THEN
        SET NEW.DepartmentID = (SELECT DepartmentID FROM Department WHERE DepartmentName = 'waiting Department' LIMIT 1);
    END IF;
END//
DELIMITER ;

-- Question 7: Cấu hình 1 bài thi chỉ cho phép user tạo tối đa 4 answers cho mỗi question, trong đó có tối đa 2 đáp án đúng.
DROP TRIGGER IF EXISTS before_answer_insert;
DELIMITER //
CREATE TRIGGER before_answer_insert
BEFORE INSERT ON Answer
FOR EACH ROW
BEGIN
    DECLARE answer_count INT;
    DECLARE correct_count INT;
    
    -- Kiểm tra số lượng câu trả lời cho câu hỏi này
    SELECT COUNT(*) INTO answer_count
    FROM Answer
    WHERE QuestionID = NEW.QuestionID;
    
    IF answer_count >= 4 THEN
        SIGNAL SQLSTATE '45005'
        SET MESSAGE_TEXT = 'Không thể thêm quá 4 câu trả lời cho mỗi câu hỏi';
    END IF;

    -- Kiểm tra số lượng đáp án đúng cho câu hỏi này
    SELECT COUNT(*) INTO correct_count
    FROM Answer
    WHERE QuestionID = NEW.QuestionID AND isCorrect = TRUE;
    
    IF NEW.isCorrect = TRUE AND correct_count >= 2 THEN
        SIGNAL SQLSTATE '45006'
        SET MESSAGE_TEXT = 'Không thể có quá 2 đáp án đúng cho mỗi câu hỏi';
    END IF;
END//
DELIMITER ;
-- Question 8: Viết trigger sửa lại dữ liệu cho đúng:
-- Nếu người dùng nhập vào gender của account là nam, nữ, chưa xác định
-- Thì sẽ đổi lại thành M, F, U cho giống với cấu hình ở database
DROP TRIGGER IF EXISTS before_account_insert;
DELIMITER //
CREATE TRIGGER before_account_insert
BEFORE INSERT ON Account
FOR EACH ROW
BEGIN
    IF NEW.gender = 'nam' THEN
        SET NEW.gender = 'M';
    ELSEIF NEW.gender = 'nữ' THEN
        SET NEW.gender = 'F';
    ELSEIF NEW.gender = 'chưa xác định' THEN
        SET NEW.gender = 'U';
    END IF;
END//
DELIMITER ;
DROP TRIGGER IF EXISTS before_account_update;
DELIMITER //
CREATE TRIGGER before_account_update
BEFORE UPDATE ON Account
FOR EACH ROW
BEGIN
    IF NEW.gender = 'nam' THEN
        SET NEW.gender = 'M';
    ELSEIF NEW.gender = 'nữ' THEN
        SET NEW.gender = 'F';
    ELSEIF NEW.gender = 'chưa xác định' THEN
        SET NEW.gender = 'U';
    END IF;
END//
DELIMITER ;
-- Question 9: Viết trigger không cho phép người dùng xóa bài thi mới tạo được 2 ngày
DROP TRIGGER IF EXISTS before_exam_delete;
DELIMITER //
CREATE TRIGGER before_exam_delete
BEFORE DELETE ON Exam
FOR EACH ROW
BEGIN
    DECLARE current_date DATETIME;
    SET current_date = NOW();
    
    -- Kiểm tra xem bài thi đã được tạo hơn 2 ngày hay chưa
    IF TIMESTAMPDIFF(DAY, OLD.CreateDate, current_date) < 2 THEN
        SIGNAL SQLSTATE '45007'
        SET MESSAGE_TEXT = 'Không thể xóa bài thi được tạo trong vòng 2 ngày qua';
    END IF;
END//
DELIMITER ;
-- Question 10: Viết trigger chỉ cho phép người dùng chỉ được update, delete các question
-- khi question đó chưa nằm trong exam nào
DROP TRIGGER IF EXISTS before_question_update;
DELIMITER //
CREATE TRIGGER before_question_update
BEFORE UPDATE ON Question
FOR EACH ROW
BEGIN
    DECLARE exam_count INT;

    -- Kiểm tra nếu câu hỏi nằm trong bất kỳ bài thi nào
    SELECT COUNT(*) INTO exam_count
    FROM ExamQuestion
    WHERE QuestionID = OLD.QuestionID;

    IF exam_count > 0 THEN
        SIGNAL SQLSTATE '45008'
        SET MESSAGE_TEXT = 'Không thể cập nhật câu hỏi đã nằm trong bài thi';
    END IF;
END//
DELIMITER ;
DROP TRIGGER IF EXISTS before_question_delete;
DELIMITER //
CREATE TRIGGER before_question_delete
BEFORE DELETE ON Question
FOR EACH ROW
BEGIN
    DECLARE exam_count INT;

    -- Kiểm tra nếu câu hỏi nằm trong bất kỳ bài thi nào
    SELECT COUNT(*) INTO exam_count
    FROM ExamQuestion
    WHERE QuestionID = OLD.QuestionID;

    IF exam_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Không thể xóa câu hỏi đã nằm trong bài thi';
    END IF;
END//
DELIMITER ;
-- Question 12: Lấy ra thông tin exam trong đó:
-- Duration <= 30 thì sẽ đổi thành giá trị "Short time"
-- 30 < Duration <= 60 thì sẽ đổi thành giá trị "Medium time"
-- Duration > 60 thì sẽ đổi thành giá trị "Long time"
SELECT 
    ExamID,
    Code,
    Title,
    CategoryID,
    CreatorID,
    CreateDate,
    CASE
        WHEN Duration <= 30 THEN 'Short time'
        WHEN Duration > 30 AND Duration <= 60 THEN 'Medium time'
        ELSE 'Long time'
    END AS DurationCategory
FROM Exam;
-- Question 13: Thống kê số account trong mỗi group và in ra thêm 1 column nữa có tên là
-- the_number_user_amount và mang giá trị được quy định như sau:
-- Nếu số lượng user trong group =< 5 thì sẽ có giá trị là few
-- Nếu số lượng user trong group <= 20 và > 5 thì sẽ có giá trị là normal
-- Nếu số lượng user trong group > 20 thì sẽ có giá trị là higher
SELECT 
    g.GroupID,
    g.GroupName,
    COUNT(ga.AccountID) AS user_count,
    CASE
        WHEN COUNT(ga.AccountID) <= 5 THEN 'few'
        WHEN COUNT(ga.AccountID) <= 20 THEN 'normal'
        ELSE 'higher'
    END AS the_number_user_amount
FROM `Group` g
LEFT JOIN GroupAccount ga ON g.GroupID = ga.GroupID
GROUP BY g.GroupID, g.GroupName;

-- Question 14: Thống kê số mỗi phòng ban có bao nhiêu user, nếu phòng ban nào
-- không có user thì sẽ thay đổi giá trị 0 thành "Không có User"
SELECT 
    d.DepartmentID,
    d.DepartmentName,
    CASE
        WHEN COUNT(a.AccountID) = 0 THEN 'Không có User'
        ELSE COUNT(a.AccountID)
    END AS user_count
FROM Department d
LEFT JOIN Account a ON d.DepartmentID = a.DepartmentID
GROUP BY d.DepartmentID, d.DepartmentName;


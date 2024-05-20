DROP DATABASE IF EXISTS TestingExamSQLFinal;
CREATE DATABASE TestingExamSQLFinal;
USE TestingExamSQLFinal;
-- Câu 1: Tạo bảng vớiràng buộc và kiểu dữ liệu. Sau đó, thêm ít nhất 5 bản ghi vào bảng.
-- Tạo bảng 
DROP TABLE IF EXISTS CUSTOMER;
CREATE TABLE CUSTOMER (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Phone VARCHAR(20),
    Email VARCHAR(255),
    Address VARCHAR(255),
    Note TEXT
);
DROP TABLE IF EXISTS CAR;
CREATE TABLE CAR (
    CarID INT PRIMARY KEY,
    Maker ENUM('HONDA', 'TOYOTA', 'NISSAN') NOT NULL,
    Model VARCHAR(255) NOT NULL,
    Year YEAR NOT NULL,
    Color VARCHAR(50),
    Note TEXT
);
DROP TABLE IF EXISTS CAR_ORDER;
CREATE TABLE CAR_ORDER (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT,
    CarID INT,
    Amount INT DEFAULT 1,
    SalePrice DECIMAL(10, 2) NOT NULL,
    OrderDate DATE NOT NULL,
    DeliveryDate DATE,
    DeliveryAddress VARCHAR(255),
    Status TINYINT DEFAULT 0,
    Note TEXT,
    FOREIGN KEY (CustomerID) REFERENCES CUSTOMER(CustomerID),
    FOREIGN KEY (CarID) REFERENCES CAR(CarID)
);
-- Thêm 5 bảng ghi

INSERT INTO CUSTOMER (Name, Phone, Email, Address, Note) VALUES
('Nguyen Van A', '0901234567', 'a@example.com', '123 Nguyen Trai', 'Khach hang VIP'),
('Tran Thi B', '0902345678', 'b@example.com', '456 Le Loi', ''),
('Le Van C', '0903456789', 'c@example.com', '789 Tran Hung Dao', 'Moi tham gia'),
('Pham Thi D', '0904567890', 'd@example.com', '101 Nguyen Hue', ''),
('Hoang Van E', '0905678901', 'e@example.com', '102 Bach Dang', 'Khach hang tiem nang');

INSERT INTO CAR (CarID, Maker, Model, Year, Color, Note) VALUES
(1, 'HONDA', 'Civic', 2020, 'Black', 'Mau xe pho bien'),
(2, 'TOYOTA', 'Corolla', 2021, 'White', ''),
(3, 'NISSAN', 'Altima', 2022, 'Blue', 'Mau xe moi'),
(4, 'HONDA', 'Accord', 2020, 'Red', 'Xe sang trong'),
(5, 'TOYOTA', 'Camry', 2021, 'Black', 'Mau xe pho bien');

INSERT INTO CAR_ORDER (CustomerID, CarID, Amount, SalePrice, OrderDate, DeliveryDate, DeliveryAddress, Status, Note) VALUES
(1, 1, 1, 20000, '2023-01-01', '2023-01-10', '123 Nguyen Trai', 1, ''),
(2, 2, 2, 18000, '2023-02-01', '2023-02-15', '456 Le Loi', 1, ''),
(3, 3, 1, 22000, '2023-03-01', '2023-03-10', '789 Tran Hung Dao', 1, ''),
(4, 4, 3, 25000, '2023-04-01', '2023-04-20', '101 Nguyen Hue', 0, 'Giao trong thang nay'),
(5, 5, 2, 21000, '2023-05-01', '2023-05-15', '102 Bach Dang', 0, 'Chua giao hang');

-- Question 2:  Viết lệnh lấy ra thông tin của khách hàng: tên, số lượng oto khách hàng đã mua và sắp sếp tăng dần theo số lượng oto đã mua.
SELECT 
    c.Name AS CustomerName,
    COUNT(co.CarID) AS NumberOfCarsPurchased
FROM 
    CUSTOMER c
JOIN 
    CAR_ORDER co ON c.CustomerID = co.CustomerID
GROUP BY 
    c.Name
ORDER BY 
    NumberOfCarsPurchased ASC;
    
-- Question 3: Viết lệnh lấy ra thông tin của khách hàng: tên, số lượng oto khách hàng đã mua và sắp sếp tăng dần theo số lượng oto đã mua.
SELECT c.Maker
FROM CAR_ORDER co
JOIN CAR c ON co.CarID = c.CarID
WHERE YEAR(co.OrderDate) = YEAR(CURDATE())
GROUP BY c.Maker
HAVING SUM(co.Amount) = (
    SELECT MAX(TotalSold) FROM (
        SELECT SUM(co.Amount) AS TotalSold
        FROM CAR_ORDER co
        JOIN CAR c ON co.CarID = c.CarID
        WHERE YEAR(co.OrderDate) = YEAR(CURDATE())
        GROUP BY c.Maker
    ) AS SalesPerMaker
);
-- Question 4: Viết 1 thủ tục (không có parameter) để xóa các đơn hàng đã bị hủy của những năm trước. In ra số lượng bản ghi đã bị xóa.
DROP PROCEDURE IF EXISTS DeleteCancelledOrders;
DELIMITER //
CREATE PROCEDURE DeleteCancelledOrders()
BEGIN
    DECLARE rows_deleted INT;
    
    -- Xóa các đơn hàng bị hủy của những năm trước
    DELETE FROM CAR_ORDER
    WHERE Status = 2 AND YEAR(OrderDate) < YEAR(CURDATE());

    -- Lấy số lượng bản ghi đã bị xóa
    SET rows_deleted = ROW_COUNT();

    -- In ra số lượng bản ghi đã bị xóa
    SELECT CONCAT('Number of records deleted: ', rows_deleted) AS Result;
END;
//
DELIMITER ;
CALL DeleteCancelledOrders();
-- Question 5: Viết 1 thủ tục (có CustomerID parameter) để in ra thông tin của các đơn
-- hàng đã đặt hàng bao gồm: tên của khách hàng, mã đơn hàng, số lượng
-- oto và tên hãng sản xuất.
DROP PROCEDURE IF EXISTS GetCustomerOrders;
DELIMITER //
CREATE PROCEDURE GetCustomerOrders(IN CustomerID INT)
BEGIN
    SELECT 
        c.Name AS CustomerName,
        co.OrderID,
        co.Amount AS NumberOfCars,
        car.Maker AS CarMaker
    FROM 
        CUSTOMER c
    JOIN 
        CAR_ORDER co ON c.CustomerID = co.CustomerID
    JOIN 
        CAR car ON co.CarID = car.CarID
    WHERE 
        c.CustomerID = CustomerID
    AND
        co.Status = 0; -- Chỉ lấy các đơn hàng đã đặt hàng (Status = 0)
END;
//
DELIMITER ;
CALL GetCustomerOrders(1);
-- Question 6: Viết trigger để tránh trường hợp người dụng nhập thông tin không hợp lệ
-- vào database (DeliveryDate < OrderDate + 15).
DROP TRIGGER IF EXISTS check_delivery_date_before_insert;
DELIMITER //
CREATE TRIGGER check_delivery_date_before_insert
BEFORE INSERT ON CAR_ORDER
FOR EACH ROW
BEGIN
    IF NEW.DeliveryDate < NEW.OrderDate + INTERVAL 15 DAY THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'DeliveryDate must be at least 15 days after OrderDate';
    END IF;
END;
//
DROP TRIGGER IF EXISTS check_delivery_date_before_update;
CREATE TRIGGER check_delivery_date_before_update
BEFORE UPDATE ON CAR_ORDER
FOR EACH ROW
BEGIN
    IF NEW.DeliveryDate < NEW.OrderDate + INTERVAL 15 DAY THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'DeliveryDate must be at least 15 days after OrderDate';
    END IF;
END;
//
DELIMITER ;
-- Ví dụ INSERT không hợp lệ 
INSERT INTO CAR_ORDER (CustomerID, CarID, Amount, SalePrice, OrderDate, DeliveryDate, DeliveryAddress, Status, Note) 
VALUES (1, 1, 1, 20000, '2023-01-01', '2023-01-10', '123 Nguyen Trai', 0, 'Test');

-- Ví dụ UPDATE không hợp lệ 
UPDATE CAR_ORDER 
SET DeliveryDate = '2023-01-10' 
WHERE OrderID = 1;



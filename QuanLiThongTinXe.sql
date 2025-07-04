CREATE DATABASE QuanLyThongTinXe;
GO

USE QuanLyThongTinXe;
GO

-- Bảng Hãng Xe
CREATE TABLE HangXe (
    MaHangXe INT PRIMARY KEY,
    TenHang NVARCHAR(100)
);

-- Bảng Dung Tích Động Cơ
CREATE TABLE DungTichDongCo (
    MaDungTich INT PRIMARY KEY,
    DungTich FLOAT
);

-- Bảng Mẫu Xe
CREATE TABLE MauXe (
    MaMauXe INT PRIMARY KEY,
    TenMauXe NVARCHAR(100),
    MaHangXe INT FOREIGN KEY REFERENCES HangXe(MaHangXe),
    MaDungTich INT FOREIGN KEY REFERENCES DungTichDongCo(MaDungTich)
);

-- Bảng Màu Sắc
CREATE TABLE MauSac (
    MaMau INT PRIMARY KEY,
    TenMau NVARCHAR(50)
);

-- Bảng Xe
CREATE TABLE Xe (
    MaXe INT PRIMARY KEY,
    MaMauXe INT FOREIGN KEY REFERENCES MauXe(MaMauXe),
    MaMau INT FOREIGN KEY REFERENCES MauSac(MaMau),
    NamSanXuat INT,
    GiaBan DECIMAL(18, 2)
);

-- Bảng Đặc Tính Kỹ Thuật
CREATE TABLE DacTinhKyThuat (
    MaDacTinh INT PRIMARY KEY,
    TenDacTinh NVARCHAR(100),
    MoTa NVARCHAR(255)
);

-- Bảng trung gian Chi Tiết Đặc Tính
CREATE TABLE ChiTietDacTinh (
    MaMauXe INT,
    MaDacTinh INT,
    PRIMARY KEY (MaMauXe, MaDacTinh),
    FOREIGN KEY (MaMauXe) REFERENCES MauXe(MaMauXe),
    FOREIGN KEY (MaDacTinh) REFERENCES DacTinhKyThuat(MaDacTinh)
);

-- HangXe
INSERT INTO HangXe VALUES
(1, N'Toyota'),
(2, N'Honda'),
(3, N'Ford'),
(4, N'Hyundai'),
(5, N'Kia'),
(6, N'Mazda'),
(7, N'Suzuki'),
(8, N'Mitsubishi'),
(9, N'Nissan'),
(10, N'Chevrolet'),
(11, N'VinFast'),
(12, N'BMW'),
(13, N'Mercedes'),
(14, N'Audi'),
(15, N'Lexus');

-- DungTichDongCo
INSERT INTO DungTichDongCo VALUES
(1, 1.0), (2, 1.2), (3, 1.4), (4, 1.5), (5, 1.6),
(6, 1.8), (7, 2.0), (8, 2.2), (9, 2.4), (10, 2.5),
(11, 2.7), (12, 3.0), (13, 3.2), (14, 3.5), (15, 4.0);

-- MauXe
INSERT INTO MauXe VALUES
(1, N'Camry', 1, 7), (2, N'City', 2, 4), (3, N'Focus', 3, 5),
(4, N'Accent', 4, 4), (5, N'Morning', 5, 2), (6, N'CX-5', 6, 10),
(7, N'Ciaz', 7, 6), (8, N'Attrage', 8, 4), (9, N'Sunny', 9, 5),
(10, N'Spark', 10, 1), (11, N'Lux A2.0', 11, 11), (12, N'X5', 12, 14),
(13, N'C-Class', 13, 13), (14, N'A4', 14, 12), (15, N'RX', 15, 15);

-- MauSac
INSERT INTO MauSac VALUES
(1, N'Đen'), (2, N'Trắng'), (3, N'Bạc'), (4, N'Xanh'), (5, N'Đỏ'),
(6, N'Nâu'), (7, N'Cam'), (8, N'Vàng'), (9, N'Xám'), (10, N'Xanh rêu'),
(11, N'Hồng'), (12, N'Xanh dương'), (13, N'Ghi bạc'), (14, N'Be'), (15, N'Tím');

-- Xe
INSERT INTO Xe VALUES
(101, 1, 1, 2022, 850000000), (102, 2, 2, 2023, 650000000), (103, 3, 3, 2021, 580000000),
(104, 4, 4, 2023, 540000000), (105, 5, 5, 2020, 430000000), (106, 6, 6, 2022, 960000000),
(107, 7, 7, 2023, 520000000), (108, 8, 8, 2022, 470000000), (109, 9, 9, 2021, 490000000),
(110, 10, 10, 2023, 310000000), (111, 11, 11, 2023, 1150000000), (112, 12, 12, 2022, 1800000000),
(113, 13, 13, 2022, 2000000000), (114, 14, 14, 2023, 1700000000), (115, 15, 15, 2023, 1950000000);

-- DacTinhKyThuat
INSERT INTO DacTinhKyThuat VALUES
(1, N'Phanh ABS', N'Hệ thống chống bó cứng phanh'),
(2, N'Cảm biến lùi', N'Hỗ trợ đỗ xe an toàn'),
(3, N'Cân bằng điện tử', N'Giúp ổn định khi cua gấp'),
(4, N'Cruise Control', N'Duy trì tốc độ không cần ga'),
(5, N'Túi khí', N'Bảo vệ người lái và hành khách'),
(6, N'Đèn LED', N'Tiết kiệm điện và sáng mạnh'),
(7, N'Cảm biến áp suất lốp', N'Cảnh báo lốp non hơi'),
(8, N'Cảnh báo điểm mù', N'Tăng an toàn chuyển làn'),
(9, N'Camera 360', N'Quan sát toàn cảnh quanh xe'),
(10, N'Khởi hành ngang dốc', N'Hỗ trợ leo dốc an toàn'),
(11, N'Hệ thống ga tự động', N'Tiện lợi đường cao tốc'),
(12, N'Hệ thống âm thanh cao cấp', N'Giải trí chất lượng'),
(13, N'Sưởi ghế', N'Tiện nghi mùa đông'),
(14, N'Kết nối Apple CarPlay', N'Kết nối thiết bị Apple'),
(15, N'Kết nối Android Auto', N'Kết nối thiết bị Android');

-- ChiTietDacTinh
INSERT INTO ChiTietDacTinh VALUES
(1, 1), (1, 2), (2, 1), (2, 5), (3, 1), (3, 4), (4, 1), (4, 3),
(5, 2), (5, 5), (6, 6), (6, 7), (7, 1), (7, 8), (8, 10);

-- UPDATE
UPDATE HangXe SET TenHang = N'Toyota Motors' WHERE MaHangXe = 1;
UPDATE DungTichDongCo SET DungTich = 1.55 WHERE MaDungTich = 4;
UPDATE MauXe SET TenMauXe = N'Camry SE' WHERE MaMauXe = 1;
UPDATE Xe SET GiaBan = 870000000 WHERE MaXe = 101;
UPDATE MauSac SET TenMau = N'Xanh tím than' WHERE MaMau = 4;
UPDATE DacTinhKyThuat SET MoTa = N'Giúp ổn định khi cua hoặc chuyển hướng gấp' WHERE MaDacTinh = 3;

-- DELETE
DELETE FROM ChiTietDacTinh WHERE MaMauXe = 15;
DELETE FROM Xe WHERE MaXe = 115;
DELETE FROM MauXe WHERE MaMauXe = 15;
DELETE FROM MauSac WHERE MaMau = 15;
DELETE FROM DacTinhKyThuat WHERE MaDacTinh = 15;

-- 1. Tìm xe có giá nhỏ hơn 600 triệu
PRINT N'Tìm xe có giá < 600 triệu:';
SELECT * FROM Xe WHERE GiaBan < 600000000;
GO

-- 2. Tìm xe sản xuất năm 2023
PRINT N'Tìm xe sản xuất năm 2023:';
SELECT * FROM Xe WHERE NamSanXuat = 2023;
GO

-- 3. Tính giá trung bình các xe
PRINT N'Giá trung bình các xe:';
SELECT AVG(GiaBan) AS GiaTrungBinh FROM Xe;
GO

-- 4. Đếm tổng số mẫu xe
PRINT N'Tổng số mẫu xe:';
SELECT COUNT(*) AS SoLuongMauXe FROM MauXe;
GO

-- 5. Lọc mẫu xe có dung tích động cơ > 2.0
PRINT N'Mẫu xe có dung tích > 2.0:';
SELECT mx.TenMauXe, dt.DungTich
FROM MauXe mx
JOIN DungTichDongCo dt ON mx.MaDungTich = dt.MaDungTich
WHERE dt.DungTich > 2.0;
GO

-- 6. Tổng doanh thu tất cả các xe
PRINT N'Tổng doanh thu các xe:';
SELECT SUM(GiaBan) AS TongDoanhThu FROM Xe;
GO

-- 7. Liệt kê các màu sắc phổ biến
PRINT N'Liệt kê tất cả các màu sắc:';
SELECT * FROM MauSac;
GO

-- 8. Mẫu xe có tên chứa chữ ''C''
PRINT N'Mẫu xe có tên chứa chữ C:';
SELECT * FROM MauXe WHERE TenMauXe LIKE N'%C%';
GO

-- 9. Tính số lượng xe theo từng năm sản xuất
PRINT N'Số lượng xe theo năm sản xuất:';
SELECT NamSanXuat, COUNT(*) AS SoLuong
FROM Xe
GROUP BY NamSanXuat;
GO

-- 10. Tìm hãng có mã từ 1 đến 5
PRINT N'Hãng xe có mã từ 1 đến 5:';
SELECT * FROM HangXe WHERE MaHangXe BETWEEN 1 AND 5;
GO
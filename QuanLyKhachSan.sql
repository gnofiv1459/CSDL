
-- ========================================
-- 1. TẠO CƠ SỞ DỮ LIỆU
-- ========================================
DROP DATABASE IF EXISTS QuanLyKhachSan;
CREATE DATABASE QuanLyKhachSan;
USE QuanLyKhachSan;

-- ========================================
-- 2. TẠO CÁC BẢNG CHÍNH
-- ========================================

-- Bảng khách hàng
CREATE TABLE KhachHang (
    MaKH INT PRIMARY KEY AUTO_INCREMENT,
    TenKH VARCHAR(100) NOT NULL,
    CMND VARCHAR(12) UNIQUE NOT NULL,
    SDT VARCHAR(15),
    Email VARCHAR(100),
    DiaChi TEXT
);

-- Bảng loại phòng
CREATE TABLE LoaiPhong (
    MaLoaiPhong INT PRIMARY KEY AUTO_INCREMENT,
    TenLoai VARCHAR(50) NOT NULL,
    MoTa TEXT,
    Gia DECIMAL(12,2) NOT NULL CHECK (Gia >= 0)
);

-- Bảng phòng
CREATE TABLE Phong (
    MaPhong INT PRIMARY KEY AUTO_INCREMENT,
    TenPhong VARCHAR(50) NOT NULL,
    MaLoaiPhong INT NOT NULL,
    TinhTrang ENUM('Trống', 'Đã đặt', 'Đang sử dụng', 'Bảo trì') DEFAULT 'Trống',
    GhiChu TEXT,
    FOREIGN KEY (MaLoaiPhong) REFERENCES LoaiPhong(MaLoaiPhong)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Bảng nhân viên
CREATE TABLE NhanVien (
    MaNV INT PRIMARY KEY AUTO_INCREMENT,
    TenNV VARCHAR(100) NOT NULL,
    ChucVu VARCHAR(50),
    SDT VARCHAR(15),
    Email VARCHAR(100)
);

-- Bảng đặt phòng
CREATE TABLE DatPhong (
    MaDatPhong INT PRIMARY KEY AUTO_INCREMENT,
    MaKH INT NOT NULL,
    MaPhong INT NOT NULL,
    NgayDat DATE NOT NULL,
    NgayNhan DATE NOT NULL,
    NgayTra DATE NOT NULL,
    TrangThai ENUM('Đã đặt', 'Đang sử dụng', 'Đã trả', 'Hủy') DEFAULT 'Đã đặt',
    GhiChu TEXT,
    FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (MaPhong) REFERENCES Phong(MaPhong)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Bảng thanh toán
CREATE TABLE ThanhToan (
    MaThanhToan INT PRIMARY KEY AUTO_INCREMENT,
    MaDatPhong INT NOT NULL,
    NgayThanhToan DATE NOT NULL,
    SoTien DECIMAL(12,2) NOT NULL CHECK (SoTien >= 0),
    HinhThuc ENUM('Tiền mặt', 'Chuyển khoản', 'Thẻ') DEFAULT 'Tiền mặt',
    GhiChu TEXT,
    FOREIGN KEY (MaDatPhong) REFERENCES DatPhong(MaDatPhong)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- ========================================
-- 3. THÊM DỮ LIỆU MẪU
-- ========================================

-- Loại phòng
INSERT INTO LoaiPhong (TenLoai, MoTa, Gia) VALUES
('Đơn', 'Phòng cho 1 người', 300000),
('Đôi', 'Phòng cho 2 người', 500000),
('Gia đình', 'Phòng lớn cho gia đình', 700000),
('VIP', 'Phòng cao cấp có view', 1200000);

-- Phòng
INSERT INTO Phong (TenPhong, MaLoaiPhong, TinhTrang, GhiChu) VALUES
('P101', 1, 'Trống', ''),
('P102', 1, 'Đã đặt', ''),
('P201', 2, 'Trống', ''),
('P301', 4, 'Trống', 'Có ban công');

-- Khách hàng
INSERT INTO KhachHang (TenKH, CMND, SDT, Email, DiaChi) VALUES
('Nguyễn Văn A', '123456789', '0912345678', 'a@gmail.com', 'Hà Nội'),
('Trần Thị B', '987654321', '0987654321', 'b@yahoo.com', 'TP. Hồ Chí Minh');

-- Nhân viên
INSERT INTO NhanVien (TenNV, ChucVu, SDT, Email) VALUES
('Lê Văn C', 'Lễ tân', '0909090909', 'c@hotel.com'),
('Phạm Thị D', 'Quản lý', '0910101010', 'd@hotel.com');

-- Đặt phòng
INSERT INTO DatPhong (MaKH, MaPhong, NgayDat, NgayNhan, NgayTra, TrangThai) VALUES
(1, 1, '2025-07-01', '2025-07-02', '2025-07-04', 'Đã đặt'),
(2, 2, '2025-07-01', '2025-07-03', '2025-07-05', 'Đang sử dụng');

-- Thanh toán
INSERT INTO ThanhToan (MaDatPhong, NgayThanhToan, SoTien, HinhThuc) VALUES
(1, '2025-07-02', 600000, 'Chuyển khoản'),
(2, '2025-07-03', 1000000, 'Tiền mặt');

-- ========================================
-- 4. TRUY VẤN THƯỜNG DÙNG
-- ========================================

-- 4.1. Danh sách phòng trống
SELECT * FROM Phong WHERE TinhTrang = 'Trống';

-- 4.2. Lịch sử đặt phòng của khách
SELECT kh.TenKH, dp.NgayDat, dp.NgayNhan, dp.NgayTra, p.TenPhong, dp.TrangThai
FROM DatPhong dp
JOIN KhachHang kh ON dp.MaKH = kh.MaKH
JOIN Phong p ON dp.MaPhong = p.MaPhong;

-- 4.3. Danh sách thanh toán theo khách
SELECT kh.TenKH, tt.NgayThanhToan, tt.SoTien, tt.HinhThuc
FROM ThanhToan tt
JOIN DatPhong dp ON tt.MaDatPhong = dp.MaDatPhong
JOIN KhachHang kh ON dp.MaKH = kh.MaKH;

-- 4.4. Thống kê doanh thu theo ngày
SELECT NgayThanhToan, SUM(SoTien) AS TongDoanhThu
FROM ThanhToan
GROUP BY NgayThanhToan
ORDER BY NgayThanhToan;

-- 4.5. Tổng số lần đặt phòng của từng khách
SELECT kh.TenKH, COUNT(dp.MaDatPhong) AS SoLanDat
FROM KhachHang kh
LEFT JOIN DatPhong dp ON kh.MaKH = dp.MaKH
GROUP BY kh.TenKH;

-- 4.6. Phòng chưa bao giờ được đặt
SELECT p.*
FROM Phong p
LEFT JOIN DatPhong dp ON p.MaPhong = dp.MaPhong
WHERE dp.MaDatPhong IS NULL;

-- 4.7. Tổng số khách hàng đã thanh toán
SELECT COUNT(DISTINCT dp.MaKH) AS SoKhachDaThanhToan
FROM ThanhToan tt
JOIN DatPhong dp ON tt.MaDatPhong = dp.MaDatPhong;

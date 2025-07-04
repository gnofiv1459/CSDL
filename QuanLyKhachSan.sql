-- ========================================
-- 1. TẠO CƠ SỞ DỮ LIỆU
-- ========================================
IF DB_ID('QuanLyKhachSan') IS NOT NULL
    DROP DATABASE QuanLyKhachSan;
GO

CREATE DATABASE QuanLyKhachSan;
GO

USE QuanLyKhachSan;
GO

-- ========================================
-- 2. TẠO CÁC BẢNG CHÍNH
-- ========================================

-- Bảng khách hàng
CREATE TABLE KhachHang (
    MaKH INT PRIMARY KEY IDENTITY(1,1),
    TenKH NVARCHAR(100) NOT NULL,
    CMND VARCHAR(12) UNIQUE NOT NULL,
    SDT VARCHAR(15),
    Email VARCHAR(100),
    DiaChi NVARCHAR(MAX)
);
GO

-- Bảng loại phòng
CREATE TABLE LoaiPhong (
    MaLoaiPhong INT PRIMARY KEY IDENTITY(1,1),
    TenLoai NVARCHAR(50) NOT NULL,
    MoTa NVARCHAR(MAX),
    Gia DECIMAL(12,2) NOT NULL CHECK (Gia >= 0)
);
GO

-- Bảng phòng
CREATE TABLE Phong (
    MaPhong INT PRIMARY KEY IDENTITY(1,1),
    TenPhong NVARCHAR(50) NOT NULL,
    MaLoaiPhong INT NOT NULL,
    TinhTrang NVARCHAR(20) DEFAULT N'Trống',
    GhiChu NVARCHAR(MAX),
    FOREIGN KEY (MaLoaiPhong) REFERENCES LoaiPhong(MaLoaiPhong)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
GO

-- Bảng nhân viên
CREATE TABLE NhanVien (
    MaNV INT PRIMARY KEY IDENTITY(1,1),
    TenNV NVARCHAR(100) NOT NULL,
    ChucVu NVARCHAR(50),
    SDT VARCHAR(15),
    Email VARCHAR(100)
);
GO

-- Bảng đặt phòng
CREATE TABLE DatPhong (
    MaDatPhong INT PRIMARY KEY IDENTITY(1,1),
    MaKH INT NOT NULL,
    MaPhong INT NOT NULL,
    NgayDat DATE NOT NULL,
    NgayNhan DATE NOT NULL,
    NgayTra DATE NOT NULL,
    TrangThai NVARCHAR(20) DEFAULT N'Đã đặt',
    GhiChu NVARCHAR(MAX),
    FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (MaPhong) REFERENCES Phong(MaPhong)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
GO

-- Bảng thanh toán
CREATE TABLE ThanhToan (
    MaThanhToan INT PRIMARY KEY IDENTITY(1,1),
    MaDatPhong INT NOT NULL,
    NgayThanhToan DATE NOT NULL,
    SoTien DECIMAL(12,2) NOT NULL CHECK (SoTien >= 0),
    HinhThuc NVARCHAR(20) DEFAULT N'Tiền mặt',
    GhiChu NVARCHAR(MAX),
    FOREIGN KEY (MaDatPhong) REFERENCES DatPhong(MaDatPhong)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
GO

-- ========================================
-- 3. THÊM DỮ LIỆU MẪU
-- ========================================

-- Loại phòng
INSERT INTO LoaiPhong (TenLoai, MoTa, Gia) VALUES
(N'Đơn', N'Phòng cho 1 người', 300000),
(N'Đôi', N'Phòng cho 2 người', 500000),
(N'Gia đình', N'Phòng lớn cho gia đình', 700000),
(N'VIP', N'Phòng cao cấp có view', 1200000);
GO

-- Phòng
INSERT INTO Phong (TenPhong, MaLoaiPhong, TinhTrang, GhiChu) VALUES
(N'P101', 1, N'Trống', N''),
(N'P102', 1, N'Đã đặt', N''),
(N'P201', 2, N'Trống', N''),
(N'P301', 4, N'Trống', N'Có ban công');
GO

-- Khách hàng
INSERT INTO KhachHang (TenKH, CMND, SDT, Email, DiaChi) VALUES
(N'Nguyễn Văn A', '123456789', '0912345678', 'a@gmail.com', N'Hà Nội'),
(N'Trần Thị B', '987654321', '0987654321', 'b@yahoo.com', N'TP. Hồ Chí Minh');
GO

-- Nhân viên
INSERT INTO NhanVien (TenNV, ChucVu, SDT, Email) VALUES
(N'Lê Văn C', N'Lễ tân', '0909090909', 'c@hotel.com'),
(N'Phạm Thị D', N'Quản lý', '0910101010', 'd@hotel.com');
GO

-- Đặt phòng
INSERT INTO DatPhong (MaKH, MaPhong, NgayDat, NgayNhan, NgayTra, TrangThai) VALUES
(1, 1, '2025-07-01', '2025-07-02', '2025-07-04', N'Đã đặt'),
(2, 2, '2025-07-01', '2025-07-03', '2025-07-05', N'Đang sử dụng');
GO

-- Thanh toán
INSERT INTO ThanhToan (MaDatPhong, NgayThanhToan, SoTien, HinhThuc) VALUES
(1, '2025-07-02', 600000, N'Chuyển khoản'),
(2, '2025-07-03', 1000000, N'Tiền mặt');
GO

-- ========================================
-- 4. TRUY VẤN THƯỜNG DÙNG
-- ========================================

-- 4.1. Danh sách phòng trống
SELECT * FROM Phong WHERE TinhTrang = N'Trống';
GO

-- 4.2. Lịch sử đặt phòng của khách
SELECT kh.TenKH, dp.NgayDat, dp.NgayNhan, dp.NgayTra, p.TenPhong, dp.TrangThai
FROM DatPhong dp
JOIN KhachHang kh ON dp.MaKH = kh.MaKH
JOIN Phong p ON dp.MaPhong = p.MaPhong;
GO

-- 4.3. Danh sách thanh toán theo khách
SELECT kh.TenKH, tt.NgayThanhToan, tt.SoTien, tt.HinhThuc
FROM ThanhToan tt
JOIN DatPhong dp ON tt.MaDatPhong = dp.MaDatPhong
JOIN KhachHang kh ON dp.MaKH = kh.MaKH;
GO

-- 4.4. Thống kê doanh thu theo ngày
SELECT NgayThanhToan, SUM(SoTien) AS TongDoanhThu
FROM ThanhToan
GROUP BY NgayThanhToan
ORDER BY NgayThanhToan;
GO

-- 4.5. Tổng số lần đặt phòng của từng khách
SELECT kh.TenKH, COUNT(dp.MaDatPhong) AS SoLanDat
FROM KhachHang kh
LEFT JOIN DatPhong dp ON kh.MaKH = dp.MaKH
GROUP BY kh.TenKH;
GO

-- 4.6. Phòng chưa bao giờ được đặt
SELECT p.*
FROM Phong p
LEFT JOIN DatPhong dp ON p.MaPhong = dp.MaPhong
WHERE dp.MaDatPhong IS NULL;
GO

-- 4.7. Tổng số khách hàng đã thanh toán
SELECT COUNT(DISTINCT dp.MaKH) AS SoKhachDaThanhToan
FROM ThanhToan tt
JOIN DatPhong dp ON tt.MaDatPhong = dp.MaDatPhong;
GO

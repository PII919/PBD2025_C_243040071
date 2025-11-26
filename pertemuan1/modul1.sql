CREATE DATABASE TokoRetailDB;

USE TokoRetailDB;

--Membuat Tabel

CREATE TABLE Produk (
ProdukID INT,
SKU VARCHAR(15),
NamaProduk VARCHAR(100),
Harga DECIMAL(10, 2),
Stok INT
);


-- Cek Struktur Tabel 

EXEC sp_help 'Produk' ;

---------------------------
---------------------------

-- Tabel Pelanggan 

CREATE TABLE Pelanggan (
PelangganID INT IDENTITY(1,1) PRIMARY KEY,
NamaDepan VARCHAR(50) NOT NULL,
NamaBelakang VARCHAR(50) NULL,
Email VARCHAR(100) NOT NULL UNIQUE,
TanggalDaftar DATE DEFAULT GETDATE()
);

-- Cek Struktur dan Constraint

EXEC sp_help 'Pelanggan';

-------------------------------
-------------------------------


-- Tabel Pemesanan 

CREATE TABLE PesananHeader (
PesananID INT IDENTITY(1,1) PRIMARY KEY,
TanggalPesanan DATETIME2 NOT NULL,

-- ini kolom foreign key 
PelangganID INT NOT NULL,
StatusPesanan VARCHAR(10) NOT NULL,

-- Constraint foreign key (out of line)
CONSTRAINT FK_Pesanan_Pelanggan 
FOREIGN KEY (PelangganID)
REFERENCES Pelanggan(PelangganID),

-- Mendeefinisikan constraint Check
CONSTRAINT CHK_StatusPesanan 
CHECK (StatusPesanan IN ('Baru','proses', 'Selesai'))
);

----------------------------------
----------------------------------


-- 1. Menambahkan Primary Key ke tabel Produk 
ALTER TABLE Produk 
ALTER COLUMN ProdukID INT NOT NULL; 
GO 
ALTER TABLE Produk 
ADD CONSTRAINT PK_Produk PRIMARY KEY (ProdukID); 
GO

-- 2. Menambahkan kolom NoTelepon ke tabel Pelanggan 
ALTER TABLE Pelanggan 
ADD NoTelepon VARCHAR(20) NULL; 
GO

-- 3. Mengubah kolom Harga di Produk agar wajib diisi 
ALTER TABLE Produk 
ALTER COLUMN Harga DECIMAL(10, 2) NOT NULL; 
GO 

EXEC sp_help 'Produk'; 
EXEC sp_help 'Pelanggan'; 

--------------------------------
--------------------------------


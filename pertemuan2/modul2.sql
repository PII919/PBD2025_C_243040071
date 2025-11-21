-- hapus Database TokoRetailDB yang sudah ada 
IF DB_ID('TokoRetailDB') IS NOT NULL
BEGIN 
	USE master;
	DROP DATABASE TokoRetailDB;
END
GO

-- Buat Database baru 
CREATE DATABASE TokoRetailDB;
GO 

-- Gunakan database tersebut 
USE TokoRetailDB;
GO

-- 1. Buat tabel kategori 
CREATE TABLE KategoriProduk ( 
    KategoriID INT IDENTITY(1,1) PRIMARY KEY, 
    NamaKategori VARCHAR(100) NOT NULL UNIQUE 
); 
GO

-- 2. Buat tabel produk 
CREATE TABLE Produk ( 
    ProdukID INT IDENTITY(1001, 1) PRIMARY KEY, 
    SKU VARCHAR(20) NOT NULL UNIQUE, 
    NamaProduk VARCHAR(150) NOT NULL, 
    Harga DECIMAL(10, 2) NOT NULL, 
    Stok INT NOT NULL, 
    KategoriID INT NULL, 
 
 -- cara menulis constraint 
 -- CONSTRAINT nama_constraint jenis constraint (nama kolom yg akan ditambah constraint
    CONSTRAINT CHK_HargaPositif CHECK (Harga >= 0), 
    CONSTRAINT CHK_StokPositif CHECK (Stok >= 0), 
    CONSTRAINT FK_Produk_Kategori  
        FOREIGN KEY (KategoriID)  
        REFERENCES KategoriProduk(KategoriID) 
); 
GO 

-- 3. Buat tabel pelanggan 
CREATE TABLE Pelanggan ( 
    PelangganID INT IDENTITY(1,1) PRIMARY KEY, 
    NamaDepan VARCHAR(50) NOT NULL, 
    NamaBelakang VARCHAR(50) NULL, 
    Email VARCHAR(100) NOT NULL UNIQUE, 
    NoTelepon VARCHAR(20) NULL,
    TanggalDaftar DATE DEFAULT GETDATE() 
); 
GO 

-- 4. Buat tabel Pesanan Header
CREATE TABLE PesananHeader ( 
    PesananID INT IDENTITY(50001, 1) PRIMARY KEY, 
    PelangganID INT NOT NULL, 
    TanggalPesanan DATETIME2 DEFAULT GETDATE(), 
    StatusPesanan VARCHAR(20) NOT NULL, 
     
    CONSTRAINT CHK_StatusPesanan CHECK (StatusPesanan IN ('Baru', 'Proses', 
'Selesai', 'Batal')), 
    CONSTRAINT FK_Pesanan_Pelanggan  
        FOREIGN KEY (PelangganID)  
        REFERENCES Pelanggan(PelangganID)  
); 
GO

-- 5. Buat tabel Pesanan Detail 
CREATE TABLE PesananDetail ( 
    PesananDetailID INT IDENTITY(1,1) PRIMARY KEY, 
    PesananID INT NOT NULL, 
    ProdukID INT NOT NULL, 
    Jumlah INT NOT NULL, 
    HargaSatuan DECIMAL(10, 2) NOT NULL, 
 
    CONSTRAINT CHK_JumlahPositif CHECK (Jumlah > 0), 
    -- FK PesananDetail & PesananHeader
    CONSTRAINT FK_Detail_Header 
        FOREIGN KEY (PesananID)  
        REFERENCES PesananHeader(PesananID) 
        ON DELETE CASCADE,   -- jika header dihapus, detail juga ikut terhapus
     
    CONSTRAINT FK_Detail_Produk 
        FOREIGN KEY (ProdukID)  
        REFERENCES Produk(ProdukID) 
); 
GO

------------------------
-- latihan 2 INSERT
------------------------

-- 1. Memasukan data Pelanggan 
INSERT INTO Pelanggan (NamaDepan, NamaBelakang, Email, NoTelepon) 
VALUES  
('Budi', 'Santoso', 'budi.santoso@email.com', '081234567890'), 
('Raffi', 'Khoirunnijam', 'faisal.mulki15@email.com', NULL);

-- Verifikasi Data
PRINT 'Data Pelanggan';
SELECT * FROM Pelanggan;

PRINT 'Data Kategori';
SELECT * FROM KategoriProduk;

-- 2. Memasukan data Kategori (Multi-row)
INSERT INTO KategoriProduk (NamaKategori)
VALUES 
('Elektronik'), 
('Pakaian'), 
('Buku');
 
 -- Masukan data Produk yang merujuk ke KategoriID
INSERT INTO Produk (SKU, NamaProduk, Harga, Stok, KategoriID) 
VALUES
('ELEC-001', 'Laptop Pro 14 inch', 15000000.00, 50, 1),
('PAK-001', 'Kaos Polos Putih', 75000.00, 200, 2),
('BUK-001', 'Dasar-Dasar SQL', 120000.00, 50, 1);

PRINT 'Data Produk:'; 
SELECT P.*, K.NamaKategori 
FROM Produk AS P 
JOIN KategoriProduk AS K ON P.KategoriID = K.KategoriID; 

--------------------------------
-- Latihan 3 Uji Coba CONSTRAINT 
---------------------------------

-- 1. Pelanggaran UNIQUE Constraint 
-- Error: Mencoba mendaftarkan email yang SAMA dengan Budi Santoso 
PRINT 'Uji Coba Error 1 (UNIQUE):'; 
INSERT INTO Pelanggan (NamaDepan, Email)  
VALUES ('Budi', 'budi.santoso@email.com'); 
GO

-- 2. Pelanggaran FOREIGN KEY Constraint
-- Error: Mencoba memasukkan produk dengan KategoriID 99 (tidak ada di tabel KategoriProduk) 
PRINT 'Uji Coba Error 2 (FOREIGN KEY):'; 
INSERT INTO Produk (SKU, NamaProduk, Harga, Stok, KategoriID) 
VALUES ('XXX-001', 'Produk Aneh', 1000, 10, 99); 
GO

-- 3. Pelanggaran CHECK Constraint
-- Error: Mencoba memasukkan harga negatif 
PRINT 'Uji Coba Error 3 (CHECK):'; 
INSERT INTO Produk (SKU, NamaProduk, Harga, Stok, KategoriID) 
VALUES ('NGT-001', 'Produk Minus', -50000, 10, 1); 
GO

----------------------------------------
-- Latihan 4 UPDATE (satu baris spesifik)
----------------------------------------

-- Cek data SEBELUM di-update
PRINT 'Data Raffi SEBELUM Update:'; 
SELECT * FROM Pelanggan WHERE PelangganID = 3; 
BEGIN TRANSACTION; 
UPDATE Pelanggan 
SET NoTelepon = '089656327071' 
WHERE PelangganID = 3;
-- Cek data SETELAH di-update (masih di dalam transaksi) 
PRINT 'Data Raffi SETELAH Update (Belum di-COMMIT):'; 
SELECT * FROM Pelanggan WHERE PelangganID = 3;
COMMIT TRANSACTION;
PRINT 'Data Raffi setelah di-COMMIT:'; 
SELECT * FROM Pelanggan WHERE PelangganID = 3; 

----------------------------------------
-- Latihan 5 UPDATE (Beberapa baris/kriteria)
----------------------------------------

PRINT 'Data Elektronik SEBELUM Update:'; 
SELECT * FROM Produk WHERE KategoriID = 1; 
BEGIN TRANSACTION; 
UPDATE Produk 
SET Harga = Harga * 1.10   
WHERE KategoriID = 1; 
PRINT 'Data Elektronik SETELAH Update (Belum di-COMMIT):'; 
SELECT * FROM Produk WHERE KategoriID = 1;

-- Cek apakah ada kesalahan? Jika tidak, commit. 
COMMIT TRANSACTION; 

----------------------------------------
-- Latihan 6 DELETE (satu baris spesifik)
----------------------------------------

PRINT 'Data Produk SEBELUM Delete:'; 
SELECT * FROM Produk WHERE SKU = 'BUK-001'; 
BEGIN TRANSACTION; 
DELETE FROM Produk 
WHERE SKU = 'BUK-001'; 
PRINT 'Data Produk SETELAH Delete (Belum di-COMMIT):'; 
SELECT * FROM Produk WHERE SKU = 'BUK-001'; 
COMMIT TRANSACTION;

----------------------------------------
-- Latihan 7: Bencana & ROLLBACK
----------------------------------------

-- Cek data stok. Harusnya 50 dan 200 
PRINT 'Data Stok SEBELUM Bencana:'; 
SELECT SKU, NamaProduk, Stok FROM Produk; 

BEGIN TRANSACTION;

-- BENCANA TERJADI: Lupa klausa WHERE! 
UPDATE Produk 
SET Stok = 0; 

-- Cek data setelah bencana. SEMUA STOK JADI 0!
PRINT 'Data Stok SETELAH Bencana (PANIK!):'; 
SELECT SKU, NamaProduk, Stok FROM Produk; 

PRINT 'Melakukan ROLLBACK...'; 
ROLLBACK TRANSACTION; 

/* Cek data setelah diselamatkan */ 
PRINT 'Data Stok SETELAH di-ROLLBACK (AMAN):'; 
SELECT SKU, NamaProduk, Stok FROM Produk; 

------------------------------------------------
-- Latihan 8: DELETE dan Pelanggaran FOREIGN KEY 
------------------------------------------------

/* 1. Buat 1 pesanan untuk Budi */ 
INSERT INTO PesananHeader (PelangganID, StatusPesanan) 
VALUES (1, 'Baru'); 
PRINT 'Data Pesanan Budi:'; 
SELECT * FROM PesananHeader WHERE PelangganID = 1; 
GO 

/* 2. Coba hapus Pelanggan Budi (PelangganID 1) */ 
PRINT 'Mencoba menghapus Budi...'; 
BEGIN TRANSACTION; 

DELETE FROM Pelanggan 
WHERE PelangganID = 1; 

ROLLBACK TRANSACTION;

-------------------------------------------
-- Latihan 9 (Tantangan): INSERT ... SELECT 
-------------------------------------------

-- 1. Buat tabel arsip (DDL) 
CREATE TABLE ProdukArsip ( 
ProdukID INT PRIMARY KEY,  
SKU VARCHAR(20) NOT NULL, 
NamaProduk VARCHAR(150) NOT NULL, 
Harga DECIMAL(10, 2) NOT NULL, 
TanggalArsip DATE DEFAULT GETDATE() 
); 
GO 

BEGIN TRANSACTION; 

-- 2. Habiskan stok Kaos (SKU PAK-001)  
UPDATE Produk SET Stok = 0 WHERE SKU = 'PAK-001'; 

-- 3. Salin data dari Produk ke ProdukArsip (INSERT ... SELECT)
INSERT INTO ProdukArsip (ProdukID, SKU, NamaProduk, Harga) 
SELECT ProdukID, SKU, NamaProduk, Harga 
FROM Produk 
WHERE Stok = 0;

-- 4. Hapus data yang sudah diarsip dari tabel Produk 
DELETE FROM Produk 
WHERE Stok = 0; 

-- Verifikasi 
PRINT 'Cek Produk Aktif (Kaos harus hilang):'; 
SELECT * FROM Produk; 
PRINT 'Cek Produk Arsip (Kaos harus ada):'; 
SELECT * FROM ProdukArsip;

-- Jika yakin, commit 
COMMIT TRANSACTION;
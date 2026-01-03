use Kampus;

-- nyoba view 
-- tampilkan daftar ruangan 
CREATE OR ALTER VIEW vw_ruangan
AS
SELECT
	KodeRuangan,
	Gedung,
	Kapasitas
FROM Ruangan;

SELECT * FROM vw_ruangan

-- buat view jumlah mahasiswa per prodi 
CREATE OR ALTER VIEW vw_JumlahMahasiswaPerProdi
AS 
SELECT
	Prodi,
	COUNT(*) AS JumlahMahasiswa
FROM Mahasiswa
GROUP BY Prodi;

SELECT * FROM vw_JumlahMahasiswaPerProdi

-- tampil mahasiswa dan matakuliah yang diambil 
CREATE OR ALTER VIEW vw_Mahasiswa_KRS
AS 
SELECT 
	m.NamaMahasiswa,
	k.Semester
FROM Mahasiswa AS m
JOIN KRS AS k
ON m.MahasiswaID = k.MahasiswaID;

SELECT * FROM vw_Mahasiswa_KRS;

-- INI PROCEDURE
-- tampilkan semua mahasiswa
CREATE OR ALTER PROCEDURE sp_LihatMahasiswa
AS
BEGIN
	SELECT * FROM Mahasiswa;
END;

EXEC sp_LihatMahasiswa;

-- tambah mahasiswa baru 
CREATE OR ALTER PROCEDURE sp_TambahMahasiswa
	@Nama VARCHAR(100),
	@Prodi VARCHAR(50),
	@Angkatan INT
AS
BEGIN
	INSERT INTO Mahasiswa(NamaMahasiswa, Prodi, Angkatan)
	VALUES (@Nama, @Prodi, @Angkatan);
END;

EXEC sp_TambahMahasiswa
'aidil', 'INFORMATIKA', 2400;

SELECT * FROM Mahasiswa;

EXEC sp_TambahMahasiswa
	@Nama = 'Bahlil',
	@Prodi = 'kehutanan',
	@Angkatan = 2000;

-- membuat prosedur menghapus mahasiswa 
CREATE OR ALTER PROCEDURE sp_HapusMahasiswa
	@NamaMahasiswa VARCHAR(100)
AS
BEGIN
	DELETE FROM Mahasiswa 
	WHERE NamaMahasiswa = @NamaMahasiswa
END;

EXEC sp_HapusMahasiswa
	@NamaMahasiswa = 'Bahlil';


-- INI TRIGGER 
-- buatkan trigger ketika ada nilai yang kosong 
CREATE OR ALTER TRIGGER t_CekNilai
ON Nilai 
AFTER INSERT 
AS
BEGIN 
	IF EXISTS (
		SELECT * FROM inserted 
		WHERE NilaiAkhir IS NULL
		)
		BEGIN 
			RAISERROR ('nilai gak boleh kosong', 16, 1);
			ROLLBACK;
		END;
	END;

INSERT INTO Nilai(MahasiswaID, NilaiAkhir)
	VALUES (5, NULL);


-- UDF 
-- Buat fungsi konversi nilai 
CREATE OR ALTER FUNCTION fn_NilaiAngka (@nilai INT)
RETURNS CHAR(1)
AS 
BEGIN
	RETURN
	CASE
		WHEN @nilai >= 85 THEN 'A'
		WHEN @nilai >= 70 THEN 'B'
		WHEN @nilai >= 55 THEN 'C'
		WHEN @nilai >= 40 THEN 'D'
		ELSE 'E'
	END;
END;

SELECT dbo.fn_NilaiAngka(100);
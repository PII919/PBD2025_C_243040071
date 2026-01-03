USE Kampus;

-- pengen nampilin dosen yang mengajar basis data 
SELECT NamaDosen 
FROM Dosen 
WHERE DosenID = (
	SELECT DosenID 
	FROM MataKuliah
	WHERE NamaMK = 'Basis Data'
);

-- menampilkan mahasiswa yang memiliki nilai 'A'
SELECT NamaMahasiswa
FROM Mahasiswa 
WHERE MahasiswaID IN (
	SELECT MahasiswaID
	FROM Nilai
	WHERE NilaiAKhir = 'A'
);

-- menampilkan daftar prodi yang mahasiswa > 2
SELECT Prodi, TotalMhs
FROM (
	SELECT Prodi, COUNT(*) AS TotalMhs
	FROM Mahasiswa
	GROUP BY Prodi
) AS HitungMhs
WHERE TotalMhs > 2;

-- menampilkan mata kuliah yang diajar oleh dosen dari prodi informatika 
SELECT NamaMK
FROM MataKuliah
WHERE DosenID IN (
	SELECT DosenID 
	FROM Dosen
	WHERE Prodi = 'Informatika'
);

-- INI CTE
-- daftar mahasiswa di informatika 
WITH MhsIF AS ( 
	SELECT * 
	FROM Mahasiswa
	WHERE Prodi = 'Informatika'
)
SELECT NamaMahasiswa, Angkatan
FROM MhsIF;

-- menghitung jumlah mahasiswa per prodi 
WITH JumlahPerProdi AS (
	SELECT Prodi, COUNT (*) AS TotalMhs 
	FROM Mahasiswa 
	GROUP BY Prodi
)
SELECT * 
FROM JumlahPerProdi;

-- bagian set operator 
-- UNION 

-- menggabungkan nama dosen dan nama mahasiswa
SELECT NamaDosen AS Nama
FROM Dosen
UNION 
SELECT NamaMahasiswa 
FROM Mahasiswa;

-- gabung ruangan > 20 dan < 20

SELECT KodeRuangan, Kapasitas 
FROM Ruangan 
WHERE Kapasitas < 20 
UNION 
SELECT KodeRuangan, Kapasitas 
FROM Ruangan 
WHERE kapasitas > 20;

-- INTERSECT 
-- tampilkan mahasiswa yang ada di tabel krs dan tabel nilai 
SELECT MahasiswaID
FROM KRS
INTERSECT
SELECT MahasiswaID
FROM Nilai;

-- EXCEPT 
-- tampilkan mahasiswa yang ada di krs tpi blm ada nilai 
SELECT MahasiswaID
FROM KRS
EXCEPT
SELECT MahasiswaID
FROM Nilai;


-- ROLL UP 
-- Tampilkan jumlah mahasiswa per prodi dan total keseluruhan 
SELECT Prodi, COUNT (*) AS TotalMahasiswa 
FROM Mahasiswa 
GROUP BY ROLLUP (Prodi);

-- CUDE 
-- tampil jumlah mahasiswa berdasarkan prodi dan angkatan 
SELECT Prodi, Angkatan, COUNT(*) AS TotalMahasiswa 
FROM Mahasiswa 
GROUP BY CUBE (Prodi, Angkatan);

-- WINDOW FUNCTION 
-- tampilkan nama mahasiswa sama total per prodi 
SELECT NamaMahasiswa, Prodi,
COUNT (*) OVER (PARTITION BY Prodi) AS TotalMhsPerProdi
FROM Mahasiswa;
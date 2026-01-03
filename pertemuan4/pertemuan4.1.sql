USE KampusDB;

SELECT * FROM Dosen;
SELECT * FROM KRS;
SELECT * FROM Mahasiswa;
SELECT * FROM MataKuliah;

-- Menampilkan mahasiswa yang punya KRS
SELECT * FROM Mahasiswa;
SELECT * FROM KRS;

SELECT m.MahasiswaID, m.NamaMahasiswa,
k.MataKuliahID, k.Semester
FROM 
Mahasiswa AS m
JOIN KRS AS k ON m.MahasiswaID = k.MahasiswaID

-- menampilkan mahasiswa dan matakuliah yang diambil
SELECT * FROM Mahasiswa;
SELECT * FROM KRS;
SELECT * FROM MataKuliah;

SELECT m.NamaMahasiswa, mk.NamaMK, mk.SKS
FROM KRS AS k
JOIN Mahasiswa AS m ON k.MahasiswaID = m.MahasiswaID
JOIN MataKuliah AS mk ON k.MataKuliahID = mk.MataKuliahID;

-- menampilkan matakuliah  beserta dosen pengajar 
SELECT * FROM Dosen;
SELECT * FROM MataKuliah;

SELECT d.NamaDosen, mk.NamaMK
FROM MataKuliah AS mk
JOIN Dosen AS d ON mk.DosenID = d.DosenID;

-- menampilkan mahasiswa meskipun belum ada KRS
SELECT m.NamaMahasiswa, k.MataKuliahID
FROM Mahasiswa AS m
LEFT JOIN KRS AS k ON m.MahasiswaID = k.MahasiswaID;

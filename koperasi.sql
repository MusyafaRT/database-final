DROP DATABASE IF EXISTS koperasi;

CREATE DATABASE koperasi;
USE koperasi;
CREATE TABLE IF NOT EXISTS anggota(
    id_anggota VARCHAR(10) PRIMARY KEY NOT NULL,
    nama VARCHAR(50) NOT NULL,
    alamat TEXT NOT NULL,
    telpon VARCHAR(15) NOT NULL,
    saldo INT NOT NULL
);
CREATE TABLE IF NOT EXISTS transaksi(
    id_transaksi INT PRIMARY KEY AUTO_INCREMENT,
    id_anggota VARCHAR(10) NOT NULL,
    tanggal_transaksi DATETIME NOT NULL,
    setoran BIT NOT NULL,
    nilai_transaksi INT NOT NULL,
    bunga INT DEFAULT NULL,
    FOREIGN KEY (id_anggota) REFERENCES anggota(id_anggota)
);
INSERT INTO anggota(id_anggota, nama, alamat, telpon, saldo)
VALUES 
    ('AK001', 'Cecep', 'Jl. Tubagus 01 Bandung', '022-2536789', 100000),
    ('AK002', 'Faiz', 'Jl. Bintang 31 Bandung', '022-2536749', 100000),
    ('AK003', 'Ahmad', 'Jl. Bulan 28 Bandung', '022-2536799', 100000),
    ('AK004', 'Anggit', 'Jl. Lintang 48 Bandung', '022-2525789', 100000),
    ('AK005', 'Bagus', 'Jl. Sukasari 97 Bandung', '022-2598789', 100000),
    ('AK006', 'Tono', 'Jl. Mekarsari 57 Bandung', '022-2678954', 100000),
    ('AK007', 'Toni', 'Jl. Pelita 39 Bandung', '022-2098768', 100000),
    ('AK008', 'Putri', 'Jl. Singaraja 89 Bandung', '022-2976888', 100000),
    ('AK009', 'Aisyah', 'Jl. Anggrek 75 Bandung', '022-2111098', 100000),
    ('AK010', 'Azizah', 'Jl. Cendrawasih 86 Bandung', '022-2876666', 100000),
    ('AK011', 'Luna', 'Jl. Permatasari 74 Bandung', '022-2954653', 100000),
    ('AK012', 'Laras', 'Jl. Angkasa 876 Bandung', '022-2000889', 100000),
    ('AK013', 'Laila', 'Jl. Kaktus 64 Bandung', '022-2112345', 100000),
    ('AK014', 'Agus', 'Jl. Arwana 74 Bandung', '022-2987776', 100000),
    ('AK015', 'Arif', 'Jl. Cempaka 89 Bandung', '022-2542876', 100000),
    ('AK016', 'Raihan', 'Jl. Pelita 99 Bandung', '022-2344568', 100000),
    ('AK017', 'Rizky', 'Jl. Brawijaya 86 Bandung', '022-2098567', 100000),
    ('AK018', 'Damayanti', 'Jl. Singaraja 35 Bandung', '022-2112345', 100000),
    ('AK019', 'Nur', 'Jl. Airlangga 78 Bandung', '022-2988988', 100000),
    ('AK020', 'Hasna', 'Jl. Kertajaya 10 Bandung', '022-2530965', 100000);

SELECT * FROM anggota;
CREATE TABLE IF NOT EXISTS log_anggota(
    id_log INT PRIMARY KEY AUTO_INCREMENT,
    id_transaksi INT,
    id_anggota VARCHAR(10) NOT NULL,
    saldo_lama INT NOT NULL,
    saldo_baru INT,
    action VARCHAR(10) NOT NULL,
    change_date DATETIME NOT NULL
);

DELIMITER $$
CREATE TRIGGER IF NOT EXISTS after_anggota_update
AFTER UPDATE ON anggota
FOR EACH ROW 
    BEGIN
        INSERT INTO log_anggota
        SET id_transaksi = (SELECT id_transaksi FROM transaksi WHERE id_transaksi = (SELECT MAX(id_transaksi) FROM transaksi)),
        id_anggota = OLD.id_anggota,
        saldo_lama = OLD.saldo,
        saldo_baru = NEW.saldo,
        action = 'UPDATE',
        change_date = NOW();
    END $$

CREATE TRIGGER IF NOT EXISTS before_transaksi_insert
BEFORE INSERT ON transaksi
FOR EACH ROW
    BEGIN
        DECLARE saldo_change INT;
        DECLARE bunga INT;
        IF NEW.setoran THEN 
            SET bunga = 0.05 * NEW.nilai_transaksi;
            SET saldo_change = NEW.nilai_transaksi;
        ELSE
            SET bunga = 0;
            SET saldo_change = -1 * NEW.nilai_transaksi;
        END IF;
        SET NEW.bunga = bunga;
        UPDATE anggota
        SET saldo = saldo + saldo_change
        WHERE id_anggota = NEW.id_anggota;
    END $$

CREATE PROCEDURE IF NOT EXISTS history_transaksi(IN nama_anggota VARCHAR(50))
BEGIN
	SELECT t.tanggal_transaksi, t.setoran, t.nilai_transaksi, t.bunga
    FROM anggota as a 
    INNER JOIN transaksi as t
    ON a.id_anggota = t.id_anggota
    WHERE a.nama = nama_anggota;
END $$
DELIMITER ;




INSERT INTO transaksi(id_transaksi, id_anggota, tanggal_transaksi, setoran, nilai_transaksi, bunga)
VALUES 
(001, 'AK001', '2011-02-10',1, 100000, default),
(default, 'AK002','2011-02-10', 1, 200000, default),
(default, 'AK003','2011-02-11',1,300000,default),
(default, 'AK004','2011-02-11',0,50000,default),
(default, 'AK005','2011-02-11',1,100000,default),
(default, 'AK006','2011-02-12',1,200000,default),
(default, 'AK007','2011-02-12',1,300000,default),
(default, 'AK008','2011-02-12',1,100000,default),
(default, 'AK009','2011-02-14',1,100000,default),
(default, 'AK010','2011-02-14',1,300000,default),
(default, 'AK011','2011-02-15',1,200000,default),
(default, 'AK012','2011-02-16',0,50000,default),
(default, 'AK013','2011-02-16',1,300000,default),
(default, 'AK014','2011-02-17',1,200000,default),
(default, 'AK015','2011-02-17',1,100000,default),
(default, 'AK016','2011-02-17',1,100000,default),
(default, 'AK017','2011-02-18',1,300000,default),
(default, 'AK018','2011-02-18',1,100000,default),
(default, 'AK019','2011-02-19',1,200000,default),
(default, 'AK020','2011-02-19',0,50000,default),
(default, 'AK011','2011-02-19',0,100000,default);

SELECT * FROM transaksi;
SELECT * FROM log_anggota;
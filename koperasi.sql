CREATE DATABASE IF NOT EXISTS koperasi;

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
CREATE TRIGGER after_anggota_update
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

CREATE TRIGGER before_transaksi_insert
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
        SET saldo = saldo + saldo_change;
    END $$

DELIMITER //
CREATE PROCEDURE history_transaksi(IN nama_anggota VARCHAR(50))
BEGIN
	SELECT t.tanggal_transaksi, t.setoran, t.nilai_transaksi, t.bunga
    FROM anggota as a 
    INNER JOIN transaksi as t
    ON a.id_anggota = t.id_anggota
    WHERE a.nama = nama_anggota;
END //
DELIMITER ;

INSERT INTO anggota(id_anggota, nama, alamat, telpon, saldo)
VALUES 
    ('AK001', 'Cecep', 'Jl. Tubagus 01 Bandung', '022-2536789', 1000000),
    ('AK002', 'Faiz', 'Jl. Bintang 31 Bandung', '022-2536749', 1000000),
    ('AK003', 'Ahmad', 'Jl. Bulan 28 Bandung', '022-2536799', 1000000),
    ('AK004', 'Anggit', 'Jl. Lintang 48 Bandung', '022-2525789', 1000000),
    ('AK005', 'Bagus', 'Jl. Sukasari 97 Bandung', '022-2598789', 1000000),
    ('AK006', 'Tono', 'Jl. Mekarsari 57 Bandung', '022-2678954', 1000000),
    ('AK007', 'Toni', 'Jl. Pelita 39 Bandung', '022-2098768', 1000000),
    ('AK008', 'Putri', 'Jl. Singaraja 89 Bandung', '022-2976888', 1000000),
    ('AK009', 'Aisyah', 'Jl. Anggrek 75 Bandung', '022-2111098', 1000000),
    ('AK010', 'Azizah', 'Jl. Cendrawasih 86 Bandung', '022-2876666', 1000000),
    ('AK011', 'Luna', 'Jl. Permatasari 74 Bandung', '022-2954653', 1000000),
    ('AK012', 'Laras', 'Jl. Angkasa 876 Bandung', '022-2000889', 1000000),
    ('AK013', 'Laila', 'Jl. Kaktus 64 Bandung', '022-2112345', 1000000),
    ('AK014', 'Agus', 'Jl. Arwana 74 Bandung', '022-2987776', 1000000),
    ('AK015', 'Arif', 'Jl. Cempaka 89 Bandung', '022-2542876', 1000000),
    ('AK016', 'Raihan', 'Jl. Pelita 99 Bandung', '022-2344568', 1000000),
    ('AK017', 'Rizky', 'Jl. Brawijaya 86 Bandung', '022-2098567', 1000000),
    ('AK018', 'Damayanti', 'Jl. Singaraja 35 Bandung', '022-2112345', 1000000),
    ('AK019', 'Nur', 'Jl. Airlangga 78 Bandung', '022-2988988', 1000000),
    ('AK020', 'Hasna', 'Jl. Kertajaya 10 Bandung', '022-2530965', 1000000);


INSERT INTO transaksi(id_transaksi, id_anggota, tanggal_transaksi, setoran, nilai_transaksi, bunga)
VALUES 
(001, 'AK001', '2011-02-10',true, 100000, default),
(default, 'AK002','2011-02-10', true, 200000, default),
(default, 'AK003','2011-02-11',true,300000,default),
(default, 'AK004','2011-02-11',false,50000,default),
(default, 'AK005','2011-02-11',true,100000,default),
(default, 'AK006','2011-02-12',true,200000,default),
(default, 'AK007','2011-02-12',true,300000,default),
(default, 'AK008','2011-02-12',true,100000,default),
(default, 'AK009','2011-02-14',true,100000,default),
(default, 'AK010','2011-02-14',true,300000,default),
(default, 'AK011','2011-02-15',true,200000,default),
(default, 'AK012','2011-02-16',false,50000,default),
(default, 'AK013','2011-02-16',true,300000,default),
(default, 'AK014','2011-02-17',true,200000,default),
(default, 'AK015','2011-02-17',true,100000,default),
(default, 'AK016','2011-02-17',true,100000,default),
(default, 'AK017','2011-02-18',true,300000,default),
(default, 'AK018','2011-02-18',true,100000,default),
(default, 'AK019','2011-02-19',true,200000,default),
(default, 'AK020','2011-02-19',false,50000,default),
(default, 'AK011','2011-02-19',false,100000,default);

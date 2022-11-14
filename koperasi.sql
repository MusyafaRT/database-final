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
    setoran BOOLEAN NOT NULL,
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
)
DELIMITER $$


CREATE TRIGGER after_anggota_update
AFTER UPDATE ON anggota
FOR EACH ROW 
    BEGIN
        INSERT INTO log_anggota
        SET id_transaksi = SELECT id_transaksi FROM transaksi WHERE id_transaksi = (SELECT MAX(id_transaksi) FROM transaksi),
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
        IF setoran THEN 
            SET bunga = 0.05 * NEW.nilai_transaksi;
            SET saldo_change = NEW.nilai_transaksi;
        ELSE THEN
            SET bunga = 0;
            SET saldo_change = -1 * NEW.nilai_transaksi;

        SET NEW.bunga = bunga;
        UPDATE anggota
        SET saldo = saldo + saldo_change;
    END $$


INSERT INTO anggota(id_anggota, nama, alamat, telpon, saldo)
VALUES 
    ('AK001', 'Cecep', 'Jl. Tubagus 01 Bandung', '022-2536789', 1000000),
    ('AK002', 'Faiz', 'Jl. Tubagus 01 Bandung', '022-2536789', 1000000),
    ('AK003', 'Ahmad', 'Jl. Tubagus 01 Bandung', '022-2536789', 1000000),
    ('AK004', 'Anggit', 'Jl. Tubagus 01 Bandung', '022-2536789', 1000000),
    ('AK005', 'Bagus', 'Jl. Tubagus 01 Bandung', '022-2536789', 1000000),
    ('AK006', 'Tono', 'Jl. Tubagus 01 Bandung', '022-2536789', 1000000),
    ('AK007', 'Toni', 'Jl. Tubagus 01 Bandung', '022-2536789', 1000000),
    ('AK008', 'Putri', 'Jl. Tubagus 01 Bandung', '022-2536789', 1000000),
    ('AK009', 'Aisyah', 'Jl. Tubagus 01 Bandung', '022-2536789', 1000000),
    ('AK010', 'Azizah', 'Jl. Tubagus 01 Bandung', '022-2536789', 1000000),
    ('AK011', 'Luna', 'Jl. Tubagus 01 Bandung', '022-2536789', 1000000),
    ('AK012', 'Laras', 'Jl. Tubagus 01 Bandung', '022-2536789', 1000000),
    ('AK013', 'Laila', 'Jl. Tubagus 01 Bandung', '022-2536789', 1000000),
    ('AK014', 'Agus', 'Jl. Tubagus 01 Bandung', '022-2536789', 1000000),
    ('AK015', 'Arif', 'Jl. Tubagus 01 Bandung', '022-2536789', 1000000),
    ('AK016', 'Raihan', 'Jl. Tubagus 01 Bandung', '022-2536789', 1000000),
    ('AK017', 'Rizky', 'Jl. Tubagus 01 Bandung', '022-2536789', 1000000),
    ('AK018', 'Damayanti', 'Jl. Tubagus 01 Bandung', '022-2536789', 1000000),
    ('AK019', 'Nur', 'Jl. Tubagus 01 Bandung', '022-2536789', 1000000),
    ('AK020', 'Hasna', 'Jl. Tubagus 01 Bandung', '022-2536789', 1000000),



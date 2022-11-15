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
CREATE TABLE IF NOT EXISTS log_anggota(
    id_log INT PRIMARY KEY AUTO_INCREMENT,
    id_transaksi INT,
    id_anggota VARCHAR(10) NOT NULL,
    saldo_lama INT NOT NULL,
    saldo_baru INT,
    action VARCHAR(10) NOT NULL,
    change_date DATETIME NOT NULL
);

SELECT * FROM transaksi;
SELECT * FROM log_anggota;
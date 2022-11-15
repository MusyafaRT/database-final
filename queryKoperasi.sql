USE koperasi;

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

-- INSERT INTO transaksi(id_transaksi, id_anggota, tanggal_transaksi, setoran, nilai_transaksi, bunga)
-- VALUES(default, 'AK001', NOW(), true, 200000, default);

-- INSERT INTO transaksi(id_transaksi, id_anggota, tanggal_transaksi, setoran, nilai_transaksi, bunga)
-- VALUES(default, 'AK001', NOW(), false, 200000, default);


SELECT * FROM log_anggota;
SELECT * FROM anggota;
SELECT * FROM transaksi;
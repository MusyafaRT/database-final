USE koperasi;

DELIMITER $$
CREATE TRIGGER  after_anggota_update
AFTER UPDATE ON anggota
FOR EACH ROW 
    BEGIN
        INSERT INTO log_anggota
        SET
        id_transaksi = (SELECT case when ((max(id_transaksi))) is null then '1' else id_transaksi+1 end from transaksi WHERE id_transaksi= (SELECT Max(id_transaksi) from transaksi)),
        id_anggota = OLD.id_anggota,
        saldo_lama = OLD.saldo,
        saldo_baru = NEW.saldo,
        action = 'UPDATE',
        change_date = NOW();
    END $$
    
 CREATE TRIGGER  after_anggota_insert
AFTER INSERT ON anggota
FOR EACH ROW 
    BEGIN
        INSERT INTO log_anggota
        SET
        id_transaksi = null,
        id_anggota = NEW.id_anggota,
        saldo_lama = 0,
        saldo_baru = NEW.saldo,
        action = 'INSERT',
        change_date = NOW();
  END $$
    

CREATE TRIGGER before_transaksi_insert
BEFORE INSERT ON transaksi
FOR EACH ROW
    BEGIN
        
        DECLARE saldo_change INT;
        DECLARE bunga INT;
        IF NEW.setoran THEN 
            SET bunga = bunga_update(new.nilai_transaksi)*New.nilai_transaksi;
            SET saldo_change = NEW.nilai_transaksi;
        ELSE
            SET bunga = 0;
            SET saldo_change = -1 * NEW.nilai_transaksi;
        END IF;
        SET NEW.bunga = bunga;
        UPDATE anggota
        SET saldo = saldo + saldo_change + bunga
        WHERE id_anggota = NEW.id_anggota;
    END $$
    
    delimiter $$
    create function bunga_update(p_nilai_transaksi int(10)) returns float(10,2) 
    DETERMINISTIC
	BEGIN 
    declare new_bunga float(10,2);
    if p_nilai_transaksi <= 100000 then
    set new_bunga=0.05;
    elseif p_nilai_transaksi>=100000 and p_nilai_transaksi <=200000 then
    set new_bunga=0.1;
    elseif p_nilai_transaksi >200000 then
    set new_bunga=0.12;
    end if;
    return(new_bunga);
    end $$
    

CREATE PROCEDURE history_transaksi(IN nama_anggota VARCHAR(50))
BEGIN
	SELECT t.tanggal_transaksi, t.setoran, t.nilai_transaksi, t.bunga
    FROM anggota as a 
    INNER JOIN transaksi as t
    ON a.id_anggota = t.id_anggota
    WHERE a.nama = nama_anggota;
END $$

CREATE PROCEDURE show_saldo(IN nama_anggota VARCHAR(50))
BEGIN
	SELECT id_anggota, nama, saldo
    FROM anggota
    WHERE nama = nama_anggota;
END $$	

CREATE FUNCTION jumlah_transaksi(nama_anggota VARCHAR(50)) RETURNS INT
DETERMINISTIC
BEGIN 
	DECLARE jml INT;
    SET jml = (SELECT COUNT(id_transaksi) 
			FROM transaksi as t
            INNER JOIN anggota as a
            ON t.id_anggota = a.id_anggota
            WHERE a.nama = nama_anggota);
	RETURN (jml);
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE max_saldo()
BEGIN
    SELECT id_anggota, nama, saldo AS saldo_maksimum FROM anggota
	WHERE saldo = (SELECT max(saldo) FROM anggota);
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE min_saldo()
BEGIN
    SELECT id_anggota, nama, saldo AS saldo_minimum FROM anggota
	WHERE saldo = (SELECT min(saldo) FROM anggota);
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE minmax_saldo()
BEGIN
	SELECT min(saldo) AS saldo_minimum, max(saldo) AS saldo_maksimum
    FROM Anggota;
END $$

Create Procedure minimum_maximum(IN jenis BIT )
BEGIN 
if jenis THEN 
   SELECT id_anggota, nama, saldo AS saldo_maksimum FROM anggota
	WHERE saldo = (SELECT max(saldo) FROM anggota);
Else 
    SELECT id_anggota, nama, saldo AS saldo_minimum FROM anggota
	WHERE saldo = (SELECT min(saldo) FROM anggota);
    END IF;
    END $$
    Delimiter ;

call minimum_maximum (1);
call minimum_maximum (0);

call min_saldo();
call max_saldo();
call minmax_saldo();

SELECT * FROM anggota;
INSERT INTO transaksi(id_anggota, tanggal_transaksi, setoran, nilai_transaksi, bunga)
VALUES 
('AK001', '2011-02-10',1, 100000,default),
('AK002','2011-02-10', 1, 200000,default),
('AK003','2011-02-11',1,300000,default),
('AK004','2011-02-11',0,50000,default),
('AK005','2011-02-11',1,100000,default),
('AK006','2011-02-12',1,200000,default),
('AK007','2011-02-12',1,300000,default),
('AK008','2011-02-12',1,100000,default),
('AK009','2011-02-14',1,100000,default),
('AK010','2011-02-14',1,300000,default),
('AK011','2011-02-15',1,200000,default),
('AK012','2011-02-16',0,50000,default),
('AK013','2011-02-16',1,300000,default),
('AK014','2011-02-17',1,200000,default),
('AK015','2011-02-17',1,100000,default),
('AK016','2011-02-17',1,100000,default),
('AK017','2011-02-18',1,300000,default),
('AK018','2011-02-18',1,100000,default),
('AK019','2011-02-19',1,200000,default),
('AK020','2011-02-19',0,50000,default),
('AK011','2011-02-19',0,100000,default);

SELECT * FROM anggota;
SELECT * FROM log_anggota;
SELECT * FROM transaksi;
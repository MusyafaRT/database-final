use koperasi;

Select anggota.nama,anggota.alamat from anggota inner join transaksi
 where anggota.id_anggota=transaksi.id_anggota and (transaksi.bunga>=5000 and
 transaksi.bunga<=10000);
 
DELIMITER $$
CREATE FUNCTION Transaksi(p_bunga int) RETURNS int(10)
DETERMINISTIC
BEGIN 
declare new_bunga int(100);
if p_bunga <=5000 then
set new_bunga=0.05*5000+5000;
elseif p_bunga>=5000 and p_bunga<=10000 then
set new_bunga = 0.1*10000+10000;
elseif p_bunga >10000 then
set new_bunga = 0.12*15000+15000;
END IF;
return (new_bunga);
END $$;
delimiter ;


Select a.nama,Transaksi(t.bunga) as bunga_baru from
anggota a inner join transaksi t where a.id_anggota=t.id_anggota;

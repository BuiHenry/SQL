CREATE TABLE NHANVIEN
(
MANV	CHAR(4) PRIMARY KEY,
HOTEN	VARCHAR(40)  NOT NULL,
SODT	VARCHAR(20)  NOT NULL,
NGVL	SMALLDATETIME  NOT NULL
)
 CREATE TABLE SANPHAM
(
MASP	CHAR(4) PRIMARY KEY ,
TENSP	VARCHAR(40) NOT NULL,
DVT		VARCHAR(20) NOT NULL,
NUOCSX	VARCHAR(40)NOT NULL,
GIA		MONEY NOT NULL
)

CREATE TABLE KHACHHANG
(
MAKH	CHAR(4)PRIMARY KEY,
HOTEN	VARCHAR(40) NOT NULL,
DCHI	VARCHAR(50) NOT NULL,
SODT	VARCHAR(20) NOT NULL,
NGSINH	SMALLDATETIME NOT NULL,
NGAYDK	SMALLDATETIME NOT NULL,
DOANHSO	MONEY NOT NULL
)

CREATE TABLE HOADON
(
SOHD	INT PRIMARY KEY ,
NGAYHD	SMALLDATETIME NOT NULL,
MAKH	CHAR(4) NOT NULL,
MANV	CHAR(4) NOT NULL,
TRIGIA	MONEY NOT NULL,
CONSTRAINT FK_HOADON_MAKH FOREIGN KEY (MAKH) REFERENCES KHACHHANG(MAKH) ON DELETE CASCADE,
CONSTRAINT FK_HOADON_MANV FOREIGN KEY (MANV) REFERENCES NHANVIEN(MANV) ON DELETE CASCADE
)


CREATE TABLE CTHD
(
SOHD	INT NOT NULL,
MASP	CHAR(4) NOT NULL, 
SLUONG	INT NOT NULL,
PRIMARY KEY (SOHD,MASP),
constraint fk_CTHD_SoHd foreign key(SoHd) references Hoadon(SoHd) on delete cascade,
constraint fk_CTHD_MaSP foreign key(MaSP) references SanPham(MaSP) on delete cascade
)
ALTER TABLE HOADON ADD FOREIGN KEY ( MAKH ) REFERENCES KHACHHANG ( MAKH)

ALTER TABLE HOADON ADD FOREIGN KEY ( MANV ) REFERENCES NHANVIEN ( MANV)

ALTER TABLE CTHD ADD FOREIGN KEY ( MASP ) REFERENCES SANPHAM ( MASP)

ALTER TABLE CTHD ADD FOREIGN KEY ( SOHD ) REFERENCES HOADON ( SOHD)

alter table SANPHAM
add GICHU varchar(100)

alter table KHACHHANG
add LoaiKH tinyint

alter table SANPHAM 
alter column GHICHU varchar(200)

alter table SanPham
drop column GHICHU

alter table KHACHHANG
alter column LOAIKHACH varchar(20)

alter table SANPHAM
add constraint SANPHAM_DVT check (DVT ='Cay' or DVT = 'hop' or DVT = 'cai' or DVT ='quyen' or dvt = 'chuc')

alter table SANPHAM 
add constraint SANPHAM_GIA check(gia>500)

alter table CTHD
add constraint CTHD_SL1 check(SL > 0)

alter table KHACHHANG
add constraint KHACHHANG_NGDK_NGAYSINH check (NGAYDK > NGAYSINH)


select *
from SANPHAM,KHACHHANG

update SANPHAM set GIA = GIA +GIA/(100/5)
where NUOCSX = 'Thai Lan'

.
Update SANPHAM set GIA = GIA /(100/5) + GIA
where NUOCSX  = 'Trung Quoc' and GIA >10000


update KHACHANG set LOAIKHACH = 'Vip'
where (NGDK <'2011/1/1' and DOANHSO >= 10000000) or (NGDK > '2011/1/1' and DOANHSO >= 2000000)


select MASP , TENSP
from SANPHAM 
where NUOCSX = 'Trung Quoc'

select MASP , tensp 
from SANPHAM
where DVT in ('Cay','quyen')


select MASP , TENSP
from SANPHAM
where MaSP like 'B%01'

select MASP , TENSP ,NUOCSX
from SANPHAM
where NUOCSX = 'Trung Quoc'
and Gia between 30000 and 40000 


select MASP , TENSP ,NUOCSX
from SANPHAM
where (NuocSX = 'Trung Quoc' or NuocSX = 'Thai Lan')
and Gia between 30000 and 40000 


select SOHD , TRIGIA 
from HOADON
where NGAYHD = '2007/1/1' or NgHD = '2007/1/2'



select SOHD , TRIGIA 
from HOADON
where year(NGAYHD) = 2007 and MONTH(NGAYHD) = 1
order by NGHD , TRIGIA desc 


select KHACHANG.MaKH , HOTEN
from KHACHANG, HOADON
where KHACHANG.MAKH = HOADON.MAKH and HOADON.NGHD = '2007/1/1'


select SOHD , TRIGIA 
from HOADON,NHANVIEN
where NHANVIEN.MaNV = HOADON.MaNV and NHANVIEN.HOTEN = 'Nguyen Van B' and HOADON.NGAYHD= '2006/10/28'


select SP.MASP ,SP.TENSP 
from SanPham SP , Hoadon HD , CTHD CT , KhachHang KH 
where SP.MASP = CT.MASP and CT.SOHD = HD.SOHD and HD.MAKH = KH.MAKH and KH.HOTEN='Nguyen Van A' and year(NGAYHD)='2006' and MONTH(NGAYHD) = '10'
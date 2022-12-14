USE QLSV
GO

CREATE TABLE LOP
(
	MaLop nchar(10) NOT NULL,
	TenLop nchar(50) NOT NULL,
	SiSo INT NOT NULL
)
GO

CREATE TABLE SinhVien
(
	MaSV nchar(10) NOT NULL,
	HoTen nvarchar NOT NULL,
	NgaySinh Date,
	MaLop nchar(10) NOT NULL
)
GO

CREATE TABLE MonHoc
(
	MaMonHoc nchar(10) NOT NULL,
	TenMH nvarchar NOT NULL
)
GO

CREATE TABLE KetQua
(
	MaSV nchar(10) NOT NULL,
	MaMonHoc nchar(10) NOT NULL,
	DiemThi FLOAT
)
GO

ALTER TABLE LOP
ADD CONSTRAINT pk_LOP PRIMARY KEY (MaLop)
GO

ALTER TABLE SinhVien
ADD CONSTRAINT pk_SinhVien PRIMARY KEY (MaSV)
GO

ALTER TABLE SinhVien
ADD CONSTRAINT fk_SinhVien FOREIGN KEY (MaLop) REFERENCES LOP (MaLop)
GO

ALTER TABLE MonHoc
ADD CONSTRAINT pk_MonHoc PRIMARY KEY (MaMonHoc)
GO

ALTER TABLE KetQua
ADD CONSTRAINT pk_KetQua PRIMARY KEY (MaSV,MaMonHoc)
GO

ALTER TABLE KetQua
ADD CONSTRAINT fk_KetQua_SinhVien FOREIGN KEY (MaSV) REFERENCES SinhVien (MaSV)
GO

ALTER TABLE KetQua
ADD CONSTRAINT fk_KetQua_MonHoc FOREIGN KEY (MaMonHoc) REFERENCES MonHoc (MaMonHoc)
GO

insert LOP values
('T','Lop Toan',0),
('V','Lop Van',0),
('A','Lop Anh',0)
insert sinhvien values
('091','Bui Henry','2002-4-14','T'),
('092','Vo Xuan Anh Tuan','2002-11-1','T'),
('093','Au Duong Duc Trung','2002-12-12','V')
insert MonHoc values
('PPLT','Phuong phap LT'),
('CSDL','Co so du lieu'),
('SQL','He quan tri CSDL'),
('PTW','Phat trien Web')
insert KetQua values
('091','PPLT',8),
('091','SQL',7),
('092','PPLT',8),
('093','CSDL',5),
('093','PTW',5)go
create function diemtb (@msv char(5))
returns float
as
begin
 declare @tb float
 set @tb = (select avg(Diemthi)
 from KetQua
where MaSV=@msv) 
 return @tb
end
go
select dbo.diemtb ('01')create function trbinhlop(@malop char(5))
returns table
as
return
 select s.masv, Hoten, trungbinh=dbo.diemtb(s.MaSV)
 from Sinhvien s join KetQua k on s.MaSV=k.MaSV
 where MaLop=@malop
 group by s.masv, Hoten create proc ktra @msv char(5)
as
begin 
 declare @n int
 set @n=(select count(*) from ketqua where Masv=@msv)
 if @n=0 
 print 'sinh vien '+@msv + 'khong thi mon nao'
 else
 print 'sinh vien '+ @msv+ 'thi '+cast(@n as char(2))+ 'mon'
end 
gocreate trigger updatesslop
on sinhvien
for insert
as
begin
 declare @ss int
 set @ss=(select count(*) from sinhvien s 
 where malop in(select malop from inserted))
 if @ss>10
 begin
 print 'Lop day'
 rollback tran
 end
 else
 begin
 update lop
 set SiSo=@ss
 where malop in (select malop from inserted)
 end
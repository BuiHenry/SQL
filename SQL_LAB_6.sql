-----lab6
------Câu 1 a
create trigger Themnv ON NHANVIEN for insert as 
if (select LUONG from inserted )<15000
begin 
print 'L??ng ph?i >15000'
rollback transaction 
end
go
insert into NHANVIEN values (N'Nguy?n',N'V?n',N'Toàn','020',cast('1967-10-20' as date),N'230 Lê V?n S?,TP HCM','Nam',30000,'010',4)
--------Câu 1 b
go
create trigger check_themnv ON NHANVIEN for insert as 
declare @tuoi int
set @tuoi=year(getdate()) - (select year(NGSINH) from inserted)
if (@tuoi < 18 or @tuoi > 65 )
begin
print'Yêu c?u nh?p tu?i t? 18 ??n 65'
rollback transaction 
end
go
insert into NHANVIEN values (N'Lê',N'An',N'S?n','011',cast('1970-10-20' as date),N'200 Lê V?n S?,TP HCM','Nam',300000,'011',4)
go
----Câu 1 c
create trigger update_NV on NHANVIEN for update as
IF (SELECT DCHI FROM inserted ) like '%TP HCM%'
begin
print'Không th? c?p nh?t'
rollback transaction
end
update NHANVIEN SET TENNV='Nh?' where MANV ='001'
go
----Câu 2 a
create trigger trg_TongNV
   on NHANVIEN
   AFTER INSERT
AS
   Declare @male int, @female int;
   select @female = count(Manv) from NHANVIEN where PHAI = N'N?';
   select @male = count(Manv) from NHANVIEN where PHAI = N'Nam';
   print N'T?ng s? nhân viên là n?: ' + cast(@female as varchar);
   print N'T?ng s? nhân viên là nam: ' + cast(@male as varchar);

INSERT INTO NHANVIEN VALUES ('Lê','Xuân','Hi?p','033','7-12-1999','TP HCM','Nam',60000,'003',1)
GO
 ------Câu 2 b
 create trigger trg_TongNVSauUpdate
   on NHANVIEN
   AFTER update
AS
   if (select top 1 PHAI FROM deleted) != (select top 1 PHAI FROM inserted)
   begin
      Declare @male int, @female int;
      select @female = count(Manv) from NHANVIEN where PHAI = N'N?';
      select @male = count(Manv) from NHANVIEN where PHAI = N'Nam';
      print N'T?ng s? nhân viên là n?: ' + cast(@female as varchar);
      print N'T?ng s? nhân viên là nam: ' + cast(@male as varchar);
   end;
UPDATE NHANVIEN
   SET HONV = 'Lê',PHAI = N'N?'
 WHERE  MaNV = '010'
GO
------Câu 2 c
CREATE TRIGGER trg_TongNVSauXoa on DEAN
AFTER DELETE
AS
begin
   SELECT MA_NVIEN, COUNT(MADA) as 'S? ?? án ?ã tham gia' from PHANCONG
      GROUP BY MA_NVIEN
	  end
	  select * from DEAN
insert into dean values ('SQL', 50, 'HH', 4)
delete from dean where MADA=50

-----Câu 3 a
go
create trigger delete_thannhan on NHANVIEN
instead of delete
as
begin
delete from THANNHAN where MA_NVIEN in(select manv from deleted)
delete from NHANVIEN where manv in(select manv from deleted)
end
insert into THANNHAN values ('031', 'Khang', 'Nam', '03-10-2017', 'con')
delete NHANVIEN where manv='031'
go
---Câu 3 b
create trigger nhanvien3 on NHANVIEN
after insert 
as
begin
insert into PHANCONG values ((select manv from inserted), 1,2,20)
end
INSERT INTO NHANVIEN VALUES ('Lê','Xuân','Hi?p','031','7-12-1999','Hà n?i','Nam',60000,'003',1)
-----lab6
------C�u 1 a
create trigger Themnv ON NHANVIEN for insert as 
if (select LUONG from inserted )<15000
begin 
print 'L??ng ph?i >15000'
rollback transaction 
end
go
insert into NHANVIEN values (N'Nguy?n',N'V?n',N'To�n','020',cast('1967-10-20' as date),N'230 L� V?n S?,TP HCM','Nam',30000,'010',4)
--------C�u 1 b
go
create trigger check_themnv ON NHANVIEN for insert as 
declare @tuoi int
set @tuoi=year(getdate()) - (select year(NGSINH) from inserted)
if (@tuoi < 18 or @tuoi > 65 )
begin
print'Y�u c?u nh?p tu?i t? 18 ??n 65'
rollback transaction 
end
go
insert into NHANVIEN values (N'L�',N'An',N'S?n','011',cast('1970-10-20' as date),N'200 L� V?n S?,TP HCM','Nam',300000,'011',4)
go
----C�u 1 c
create trigger update_NV on NHANVIEN for update as
IF (SELECT DCHI FROM inserted ) like '%TP HCM%'
begin
print'Kh�ng th? c?p nh?t'
rollback transaction
end
update NHANVIEN SET TENNV='Nh?' where MANV ='001'
go
----C�u 2 a
create trigger trg_TongNV
   on NHANVIEN
   AFTER INSERT
AS
   Declare @male int, @female int;
   select @female = count(Manv) from NHANVIEN where PHAI = N'N?';
   select @male = count(Manv) from NHANVIEN where PHAI = N'Nam';
   print N'T?ng s? nh�n vi�n l� n?: ' + cast(@female as varchar);
   print N'T?ng s? nh�n vi�n l� nam: ' + cast(@male as varchar);

INSERT INTO NHANVIEN VALUES ('L�','Xu�n','Hi?p','033','7-12-1999','TP HCM','Nam',60000,'003',1)
GO
 ------C�u 2 b
 create trigger trg_TongNVSauUpdate
   on NHANVIEN
   AFTER update
AS
   if (select top 1 PHAI FROM deleted) != (select top 1 PHAI FROM inserted)
   begin
      Declare @male int, @female int;
      select @female = count(Manv) from NHANVIEN where PHAI = N'N?';
      select @male = count(Manv) from NHANVIEN where PHAI = N'Nam';
      print N'T?ng s? nh�n vi�n l� n?: ' + cast(@female as varchar);
      print N'T?ng s? nh�n vi�n l� nam: ' + cast(@male as varchar);
   end;
UPDATE NHANVIEN
   SET HONV = 'L�',PHAI = N'N?'
 WHERE  MaNV = '010'
GO
------C�u 2 c
CREATE TRIGGER trg_TongNVSauXoa on DEAN
AFTER DELETE
AS
begin
   SELECT MA_NVIEN, COUNT(MADA) as 'S? ?? �n ?� tham gia' from PHANCONG
      GROUP BY MA_NVIEN
	  end
	  select * from DEAN
insert into dean values ('SQL', 50, 'HH', 4)
delete from dean where MADA=50

-----C�u 3 a
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
---C�u 3 b
create trigger nhanvien3 on NHANVIEN
after insert 
as
begin
insert into PHANCONG values ((select manv from inserted), 1,2,20)
end
INSERT INTO NHANVIEN VALUES ('L�','Xu�n','Hi?p','031','7-12-1999','H� n?i','Nam',60000,'003',1)
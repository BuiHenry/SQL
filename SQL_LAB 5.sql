--In ra dòng ‘Xin chào’ + @ten với @ten là tham số đầu vào là tên Tiếng Việt có dấu của bạn.
CREATE PROCEDURE sp_hello
	@Ten nvarchar(50)
AS
BEGIN
	PRINT ' Hello ' + @ten
END;

EXEC sp_hello N'Bui Henry';

--Nhập vào 2 số @s1,@s2. In ra câu ‘Tổng là : @tg’ với @tg=@s1+@s2.
CREATE PROCEDURE sp_tong @so1 int , @so2 int 
AS
BEGIN 
	DECLARE @tong int;
	SET @tong = @so1 + @so2 ;
	PRINT 'Tong la ' +cast (@tong as varchar);
END;
EXEC sp_tong 5, 2;

--Nhập vào số nguyên @n. In ra tổng các số chẵn từ 1 đến @n.
CREATE PROC sp_chan @n int
AS
BEGIN
	DECLARE	@tong1 int , @i int ;
	SET @tong1 = 0 ;
	SET @i = 1 ;
	WHILE @i <= @n
		BEGIN 
		IF @i % 2 = 0
		BEGIN 
			SET @tong1 = @tong1 +@i;
		END;
		SET @i = @i + 1;
	END;
	PRINT 'Tong cac so chan ' + cast (@tong1 as varchar);
END;

EXEC sp_chan 114

--Nhập vào 2 số. In ra ước chung lớn nhất của chúng
CREATE PROC sp_uoc @uoc1 int , @uoc2 int 
AS
BEGIN
DECLARE @ucl int ;
IF @uoc1 > @uoc2
BEGIN
SELECT @ucl = @uoc1 ,@uoc1 = @uoc2 , @uoc2=@ucl;
END
WHILE @uoc2 % @uoc1 != 0
BEGIN
SELECT @ucl = @uoc1 ,@uoc1=@uoc1 % @uoc2 , @uoc2 = @ucl;
END;
PRINT 'Uoc chung lon nhat la : ' + cast (@uoc1 as varchar)
END ;
EXEC sp_uoc 20 ,4;

--Nhập vào @Manv, xuất thông tin các nhân viên theo @Manv.
CREATE PROC sp_timnv @MaNV nvarchar (4)
AS
BEGIN
SELECT *FROM NHANVIEN WHERE MANV = @MaNV
END ;
EXEC dbo.sp_timnv 003

--Nhập vào @MaDa (mã đề án), cho biết số lượng nhân viên tham gia đề án đó
CREATE PROC sp_dean
@MaDA nvarchar (4)
AS
BEGIN 
SELECT count(ma_nvien) AS 'So Luong NV tham giam de an' FROM PHANCONG WHERE MADA = @MaDA;
END ;
EXEC dbo.sp_dean 1;

--Nhập vào @MaDa và @Ddiem_DA (địa điểm đề án), cho biết số lượng nhân viên tham gia đề án có mã đề án là @MaDa và địa điểm đề án là @Ddiem_DA

CREATE PROC sp_diadiem 
@MaDA int , @Ddiem nvarchar(15)
AS
BEGIN
SELECT count(b.ma_nvien) AS 'So Luong' FROM DEAN a inner join PHANCONG b ON a.MADA  = b.MADA
WHERE a.MADA = @MaDA and a.DDIEM_DA = @Ddiem;
END;
EXEC dbo.sp_diadiem 1,'Vũng Tàu';
SELECT *FROM DEAN;

--Nhập vào @Trphg (mã trưởng phòng), xuất thông tin các nhân viên có trưởng phòng là @Trphg và các nhân viên này không có thân nhân.
CREATE PROC sp_trphong @Trphg nvarchar (10)
AS
BEGIN
SELECT b.* FROM PHONGBAN a inner join NHANVIEN b ON a.MAPHG = b.PHG
WHERE a.TRPHG = @Trphg 
END;
exec dbo.sp_trphong '005'


--Nhập vào @Manv và @Mapb, kiểm tra nhân viên có mã @Manv có thuộc phòng ban có mã @Mapb hay không
create proc sp_NVophg 
@MaNV nvarchar (4) , @MaPB int 
as
begin
declare @Dem int ;
select @Dem = count(manv) from NHANVIEN where MANV = @MaNV and PHG = @MaPB ;
return @Dem;
end;
declare @result int ;
exec @result = dbo.sp_NVophg '002' ,1 ;
select @result;


--Đếm Nhân viên ở tỉnh thành
create procedure DemNva
@cityvar nvarchar (30)
as
declare @num int
select @num = count (*) from nhanvien
where DCHI like '%' + @cityvar
return @num
go
declare @tongso int
exec @tongso = DemNv 'TP HCM'
select @tongso 
go


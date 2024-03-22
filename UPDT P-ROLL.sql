

DECLARE @EMPID NVARCHAR(50), @PERIODFROM DATE , @AMOUNT MONEY --, @DESC NVARCHAR(200)

SET @EMPID='06-22-4154'
SET @PERIODFROM='2024-03-11'
SET @AMOUNT = (select DAllowance from tbl_EmployeeInformation where EmpID = @EMPID)
-- SET @DESC = 'Allowance=' + CAST(@AMOUNT as nvarchar(100))

UPDATE tbl_Payroll SET SOthers=NOD*@AMOUNT WHERE PeriodFrom=@PERIODFROM AND EmpID=@EMPID

-- UPDATE tbl_OtherDetails SET OSDet= 'Overpayment = 0.50' WHERE DFrom=@PERIODFROM AND EmpID=@EMPID
SET @AMOUNT = (select sothers from tbl_Payroll WHERE PeriodFrom=@PERIODFROM AND EmpID=@EMPID)

UPDATE tbl_OtherDetails SET OSDet= iif(@AMOUNT>0 ,CONCAT('Allowance=',@AMOUNT),'') WHERE DFrom=@PERIODFROM AND EmpID=@EMPID

EXEC REGEN_PAYROLL_SELECTED @EMPID,@PERIODFROM

select DAllowance ,* from tbl_EmployeeInformation 
where EmpID in ('06-22-4154')

-- select RatePD ,* from tbl_Payroll 
-- where PeriodFrom ='2024-03-04' 
-- and EmpID in ('42-24-5104')
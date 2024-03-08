
DECLARE @EMPID NVARCHAR(50), @PERIODFROM DATE , @AMOUNT MONEY --, @DESC NVARCHAR(200)

SET @EMPID='22-23-4839'
SET @PERIODFROM='2024-02-26'
SET @AMOUNT = (select DAllowance from tbl_EmployeeInformation where EmpID = @EMPID)
-- SET @DESC = 'Allowance=' + CAST(@AMOUNT as nvarchar(100))

UPDATE tbl_Payroll SET SOthers=5*@AMOUNT WHERE PeriodFrom=@PERIODFROM AND EmpID=@EMPID

-- UPDATE tbl_OtherDetails SET OSDet= REPLACE(OSDet,'423.115',@AMOUNT) WHERE DFrom=@PERIODFROM AND EmpID=@EMPID
SET @AMOUNT = (select sothers from tbl_Payroll WHERE PeriodFrom=@PERIODFROM AND EmpID=@EMPID)

UPDATE tbl_OtherDetails SET OSDet= CONCAT('Allowance=',@AMOUNT) WHERE DFrom=@PERIODFROM AND EmpID=@EMPID

EXEC REGEN_PAYROLL_SELECTED @EMPID,@PERIODFROM

-- select NOD,Holiday,TSalary,Net, RatePD from tbl_Payroll 
-- where PeriodFrom ='2024-02-26' 
-- and EmpID in ('06-22-3994','01-23-4312','01-10-0281')
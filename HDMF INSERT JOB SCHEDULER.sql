

DECLARE @curentDate as DATE,@FRSTDate as DATE,@LSTtDate as DATE,@RMTDate as DATE

SET @curentDate = (SELECT CONVERT(DATE, GETDATE()))
SET @FRSTDate = (SELECT DATEFROMPARTS(YEAR(DATEADD(MONTH, -1, @curentDate)), MONTH(DATEADD(MONTH, -1, @curentDate)), 1) )
SET @LSTtDate = (SELECT EOMONTH(DATEADD(MONTH, -1, @curentDate)))
SET @RMTDate = (SELECT DATEFROMPARTS(YEAR(@curentDate), MONTH(@curentDate), 1) )

IF((SELECT COUNT([Date]) FROM tbl_HDMFContribution WHERE [Date]= @RMTDate )>1)
BEGIN

    INSERT INTO [dbo].[tbl_HDMFContribution](
        [EmpID],[Fname],[Mname],[Lname],[BirthDate],[Company],[TINNumber],[PagibigNumber],
        [Employee],[Employer],[MonthlyContribution],[Date],[MPLoan],[Remarks],[Status],[Included],
        [CalamityLoan])

    SELECT 
        T0.EmpID, Upper(Fname) Fname,Upper(Mname) Mname,Upper(Lname) , Bdate, T0.Company,T2.TINNUmber,T2.PagibigNumber, 
        SUM(t1.Pagibig) Employee,'200.00' Employer, SUM(t1.Pagibig) MonthlyContribution, @LSTtDate Date, SUM(PLoan) MPLoan,'' Remarks, 1 as STATUS, 1 as Included,
        0.00 as CalamityLoan  

    FROM tbl_EmployeeInformation T0 
    INNER JOIN tbl_Payroll T1 ON T1.EmpID=T0.EmpID
    INNER JOIN tbl_EmployeeRequirements T2 ON T2.EmpID=T0.EmpID
    WHERE 
    T1.PeriodTo BETWEEN @FRSTDate AND @LSTtDate
    AND T0.Company LIKE '%Starbright%' 
    AND T0.EmpID NOT IN (SELECT EmpID FROM tbl_HDMFContribution WHERE Company LIKE '%Starbright%' AND [Date]=@LSTtDate)
    GROUP BY T0.EmpID, Fname,Mname,Lname, Bdate, T0.Company,T2.TINNUmber,T2.PagibigNumber
    HAVING SUM(t1.Pagibig) >= 100

END

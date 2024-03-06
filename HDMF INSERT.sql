
SELECT * FROM tbl_HDMFContribution WHERE Company LIKE '%DGCDI-GLASS%' AND [Date]='2023-11-01 00:00:00.000' AND EmpID NOT IN (SELECT EmpID FROM tbl_HDMFContribution WHERE Company LIKE '%DGCDI-GLASS%' AND [Date]='2023-11-01 00:00:00.000')

SELECT * FROM tbl_HDMFContribution WHERE Company LIKE '%Starbright cAGAYAN%' order BY [Date] DESC
SELECT DISTINCT EmpID, DBO.GET_FULLNAME(EmpID) FROM tbl_Payroll WHERE PeriodFrom >='08-07-2023' AND PeriodTo<='09-02-2023' AND Company LIKE 'Starbright Cagayan' AND EmpID NOT IN (SELECT EmpID FROM tbl_HDMFContribution WHERE Company LIKE '%Starbright cAGAYAN%' AND [Date]='2023-08-01 00:00:00.000')
GROUP BY EmpID
HAVING SUM(Pagibig) >= 100

INSERT INTO [dbo].[tbl_HDMFContribution]([EmpID],[Fname],[Mname],[Lname],[BirthDate],[Company],[TINNumber],[PagibigNumber],[Employee],[Employer],[MonthlyContribution],[Date],[MPLoan],[Remarks],[Status],[Included],[CalamityLoan])
SELECT T0.EmpID, Upper(Fname) Fname,Upper(Mname) Mname,Upper(Lname) , Bdate, T0.Company,T2.TINNUmber,T2.PagibigNumber, SUM(t1.Pagibig) Employee,'100.00' Employer, SUM(t1.Pagibig) + 100 MonthlyContribution, '2023-12-01' Date, SUM(PLoan) MPLoan,'' Remarks, 1 as STATUS, 1 as Included, 0.00 as CalamityLoan  from tbl_EmployeeInformation T0 
INNER JOIN tbl_Payroll T1 ON T1.EmpID=T0.EmpID
INNER JOIN tbl_EmployeeRequirements T2 ON T2.EmpID=T0.EmpID
WHERE T1.PeriodFrom >='11-06-2023' AND T1.PeriodTo<='12-02-2023' AND T0.Company LIKE '%Starbright%' AND T0.EmpID NOT IN (SELECT EmpID FROM tbl_HDMFContribution WHERE Company LIKE '%Starbright%' AND [Date]='2023-12-01 00:00:00.000')
GROUP BY T0.EmpID, Fname,Mname,Lname, Bdate, T0.Company,T2.TINNUmber,T2.PagibigNumber
HAVING SUM(t1.Pagibig) >= 100

SELECT * FROM tbl_HDMFContribution WHERE  [Date]='2023-12-01 00:00:00.000' ORDER by [Date] DESC
SELECT * FROM tbl_HDMFContribution WHERE [Date]='02-01-2024' AND Company LIKE '%Starbright%' AND MonthlyContribution=0

-- UPDATE 
--     tbl_HDMFContribution
-- SET 
--     Employee = 300,
--     Employer = 100,
--     MonthlyContribution = 400
-- FROM 
--     tbl_HDMFContribution T0
--     WHERE T0.[Date]='2023-11-01 00:00:00.000' AND EmpID='29-18-2498'
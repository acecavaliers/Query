





--SELECT 
--T1.EmpID,
--CONCAT(T1.FNAME, ' ' , T1.MNAME, ' ' , T1.LNAME) AS FullName,
--t1.Department,
--t1.Company,
--t1.status,
--t0.valeid, 
--t0.Amount,
--t0.WeeklyDeduction,
--t0.AmountPaid,
--t0.balance,
--t0.DateApplied,
--t0.DateDoc
--FROM TBL_VALE T0
--INNER JOIN tbl_EmployeeInformation T1 ON T0.EmpID = T1.EmpID
--WHERE T1.COMPANY LIKE 'Safety%'



--SELECT * FROM tbl_OtherAccount
--SELECT * FROM tbl_Details

--OTHER ACCOUNTS
SELECT 
T0.EMPID,
CONCAT(T0.FNAME, ' ' , T0.MNAME, ' ' , T0.LNAME) AS FullName,
t0.Department,
T0.Company,
t0.status,
t1.AccID,
t1.DateApplied,
t1.DateDoc,
T1.Description,
t1.Amount,
t1.WeeklyDeduction,
t1.Amount,
t1.balance
FROM tbl_EmployeeInformation T0
INNER JOIN tbl_OtherAccount T1 ON T0.EMPID = T1.EMPID
WHERE T0.COMPANY LIKE '%safety%'
order by CONCAT(T0.FNAME, ' ' , T0.MNAME, ' ' , T0.LNAME) asc

--VALE
SELECT 
T0.EMPID,
CONCAT(T0.FNAME, ' ' , T0.MNAME, ' ' , T0.LNAME) AS FullName,
t0.Department,
T0.Company,
t0.status,
t1.id as valeid,
T3.AMOUNT,
T3.WeeklyDeduction,
T3.AmountPaid,
T3.Balance,
T3.DateApplied,
T3.DateDoc,
T1.Description,
T1.Charge,
T1.Credit,
T3.BALANCE,
T1.Number
FROM tbl_EmployeeInformation T0
INNER JOIN tbl_Details T1 ON T0.EMPID = T1.EMPID
INNER JOIN tbl_Vale T3 ON T1.ID = T3.ValeID
WHERE T0.COMPANY LIKE '%Safety%'
order by CONCAT(T0.FNAME, ' ' , T0.MNAME, ' ' , T0.LNAME) , T1.NUMBER asc
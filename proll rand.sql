SELECT * from tbl_Payroll WHERE Name LIKE '%cabel%' and PeriodFrom BETWEEN '2023-10-01' and '2023-10-31'


SELECT * from tbl_Details WHERE EmpID='28-11-0584'  and [Date] BETWEEN '2023-09-01' and '2023-10-31' and ID LIKE '%other%'


SELECT * from tbl_Details WHERE EmpID='28-11-0584'  and ID='Other-090623-279741'

SELECT * from tbl_OtherAccount WHERE EmpID='28-11-0584'  and [AccID]='Other-092123-280029'

select PLoan,DOthers,PeriodFrom, * from tbl_Payroll
WHERE PeriodFrom='2024-01-15'
AND EmpID = '17-17-2017'

UNION ALL select PLoan,DOthers,PeriodFrom, * from tbl_Payroll
WHERE PeriodFrom='2024-01-22'
AND EmpID = '17-17-2017'

UNION ALL select PLoan,DOthers,PeriodFrom, * from tbl_Payroll
WHERE PeriodFrom='2024-01-29'
AND EmpID = '17-17-2017'

UNION ALL select PLoan,DOthers,PeriodFrom, * from tbl_Payroll
WHERE PeriodFrom='2022-03-14'
AND EmpID = '17-21-3428'


select PLoan,DOthers,PeriodFrom, * from tbl_Payroll
WHERE PeriodFrom>='2022-01-01' and PeriodTo<='2022-01-31' and Company LIKE '%buildmore%'

SELECT * FROM tbl_EmployeeInformation WHERE [EmpID]='28-17-1931'



SELECT * from tbl_Details WHERE  EmpID = '17-19-2874'  and ID='Other-102521-194547'


SELECT * from tbl_Details WHERE  EmpID = '17-20-3280'  and ID='Other-122021-197147'


SELECT * from tbl_Details WHERE  Charge LIKE '%568.84%' --EmpID = '17-19-2874'  and ID='Other-102521-194547'



SELECT * from tbl_WeeklyReport WHERE  userid = '02-21-3330'  




SELECT pp.Lname,Fname,Company,qq.* from tbl_Details qq
inner join tbl_EmployeeInformation pp on pp.EmpID=qq.EmpID
where Credit LIKE '%123.75%'



SELECT EmpID,CONCAT(Lname, ', ',Fname), [Position] FROM tbl_EmployeeInformation WHERE [Position] LIKE '%hr%'


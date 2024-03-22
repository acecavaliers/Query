
select distinct Department FROM tbl_EmployeeInformation



select distinct pp.Department,pp.EmpID, tt.empid as ApproverID ,tt.NAME Head,tt.[Position] from tbl_Payroll pp
INNER JOIN (
    SELECT CONCAT(Lname, ', ',Fname)NAME, REPLACE(EmpID,'/','-')empid,Department,Company,[Position]
    from tbl_EmployeeInformation 
    WHERE
    EmpID IN
    (
    '29-17-1894','29-18-2328','30-19-2675','30-23-4600','17-08-0190','28-11-0584','02-09-0250','04-98-0027',
    '05-11-0537','31-19-2799','31-20-3146','10-03-0056','2','2','38-23-4867','10012','02-19-2701','02-15-1235',
    '02-16-1650','02-17-1986','02-21-3615','02-16-1676','03-20-3035','03-13-0806','09-16-1601','09-15-1228','35-22-3728',
    '35-23-4596','15-22-4107','15-22-4379','21-18-2203','21-18-2558','11-17-1901','25-13-0900','27-18-2218','36-18-2383',
    '01-99-0031','01-99-0033','01-90-0008','01-10-0281','01-02-0050','01-21-3324','01-14-1185','01-16-1808','01-18-2516','01-04-0074','01-12-0644'
    )
) TT ON TT.Department=PP.Department
order by pp.Department,tt.empid




SELECT DISTINCT PP.Department,pp.name,net, ISNULL(TT.empid,'') as ApproverID,ISNULL(tt.NAME,'')Name,ISNULL(tt.Company,'')Company,ISNULL(tt.[Position],'')POSITION
-- FROM tbl_EmployeeInformation PP
FROM   tbl_Payroll PP
LEFT JOIN (
    SELECT CONCAT(Lname, ', ',Fname)NAME, REPLACE(EmpID,'/','-')empid,Department,Company,[Position]
    from tbl_EmployeeInformation 
    WHERE
    EmpID IN
    (    '29-17-1894','29-18-2328','30-19-2675','30-23-4600','17-08-0190','28-11-0584','02-09-0250','04-98-0027', '05-11-0537','31-19-2799','31-20-3146',
    '10-03-0056','2','2','38-23-4867','10012','02-19-2701','02-15-1235', '02-16-1650','02-17-1986','02-21-3615','02-16-1676','03-20-3035',
    '03-13-0806','09-16-1601','09-15-1228','35-22-3728','35-23-4596','15-22-4107','15-22-4379','21-18-2203','21-18-2558','11-17-1901','25-13-0900',
    '27-18-2218','36-18-2383',    '01-99-0031','01-99-0033','01-90-0008','01-10-0281','01-02-0050','01-21-3324','01-14-1185','01-16-1808',
    '01-18-2516','01-04-0074','01-12-0644'
    )
) TT ON TT.Department=PP.Department
-- and [Status]='active'
WHERE PeriodFrom ='2024-03-04'
ORDER by pp.Department


select EmpID,CONCAT(Lname, ', ',Fname) from tbl_EmployeeInformation where lname like '%ompas%'

select * from tbl_WeeklyReport where UserID='02-21-3330' and DateFrom ='2024-03-11'


select * from tbl_Payroll where Department='SOD-Davao' and PeriodFrom ='2024-03-04'

-- SELECT CONCAT(Lname, ', ',Fname)NAME, REPLACE(EmpID,'/','-')empid,Department 
-- from tbl_EmployeeInformation 
-- WHERE
-- EmpID IN
-- (
-- '29-17-1894','29-18-2328','30-19-2675','30-23-4600','17-08-0190','28-11-0584','02-09-0250','04-98-0027',
-- '05-11-0537','31-19-2799','31-20-3146','10-03-0056','2','2','38-23-4867','10012','02-19-2701','02-15-1235',
-- '02-16-1650','02-17-1986','02-21-3615','02-16-1676','03-20-3035','03-13-0806','09-16-1601','09-15-1228','35-22-3728',
-- '35-23-4596','15-22-4107','15-22-4379','21-18-2203','21-18-2558','11-17-1901','25-13-0900','27-18-2218','36-18-2383',
-- '01-99-0031','01-99-0033','01-90-0008','01-10-0281','01-02-0050','01-21-3324','01-14-1185','01-16-1808','01-18-2516','01-04-0074','01-12-0644'
-- )

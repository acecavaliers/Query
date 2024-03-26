-- DECLARE @EmpID varchar(10)


-- -- Dermely	Parreño
-- select * from tbl_EmployeeInformation where lname = 'lao' --22-22-3820
-- SET @EmpID = '22-22-3820'
-- select ATotal,Dtotal,* from tbl_Clearance where EmpID = @EmpID
-- ALTER TABLE tbl_Clearance DISABLE TRIGGER RESTRICT_UPDATE_CLEARANCE
-- update tbl_Clearance set Salary=10320, aTotal=1664.5 where EmpID = @EmpID
-- ALTER TABLE tbl_Clearance ENABLE TRIGGER RESTRICT_UPDATE_CLEARANCE
-- select ATotal,Dtotal,ATotal-Dtotal as 'Total',Lname,Fname, t1.EmpID from tbl_Clearance t0 inner join tbl_EmployeeInformation t1 on t0.EmpID=t1.EmpID where t0.EmpID = @EmpID



-- select * from tbl_CalamityLoans where EmpID='18-18-2400' and CalamityID='Calamity-111220-000118'

-- UPDATE tbl_CalamityLoans set Balance='0', AmountPaid='5760.24', Adjustment='1200.055' where EmpID='18-18-2400' and CalamityID ='Calamity-111220-000118'

-- select * from tbl_CalamityLoans where EmpID='18-18-2400' and CalamityID='Calamity-111220-000118'

-- select * from tbl_PagibigLoans where EmpID='18-19-2953' and PagibigID='Pagibig-071421-001381'
-- UPDATE tbl_PagibigLoans set Balance='0', AmountPaid='27163.44', Adjustment='15845.34' where EmpID='18-19-2953' and PagibigID='Pagibig-071421-001381'
-- select * from tbl_PagibigLoans where EmpID='18-19-2953' and PagibigID='Pagibig-071421-001381'

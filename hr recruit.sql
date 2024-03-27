select EmpID,Name,* 
 from tbl_Payroll where [Position] LIKE '%recruit%'
 AND [PeriodFrom]='2024-03-18'


--- IF LAST RECORD IS 1000 THAT WONT BE DELETED,  THEN CHECKIDENT 1000
-- EXAMPLE:
--	PRFID: 1, 2, 3, 4, 5, 1000
-- THEN DELETE ALL RECORDS ABOVE 5, THEN RUN THE SCRIPT "DBCC CHECKIDENT('table', RESEED, 5)" for Correction of AutoIncrement Skipping


SELECT * FROM tbl_PRFHeader ORDER BY PRFID DESC 

--DELETE FROM tbl_PRFHeader WHERE PRFID >4239
--DBCC CHECKIDENT('tbl_PRFHeader', RESEED, 4239)


SELECT * FROM tbl_PRFDetails ORDER BY PRFID DESC 
--DELETE FROM tbl_PRFDetails WHERE PRFID >4239
--DBCC CHECKIDENT('tbl_PRFDetails', RESEED, 51757)

SELECT * FROM tbl_PRFPayrollPettyCashDetails ORDER BY PRFID DESC 
--DELETE FROM tbl_PRFPayrollPettyCashDetails WHERE PRFID > 1374
--DBCC CHECKIDENT('tbl_PRFPayrollPettyCashDetails', RESEED, 3863)

SELECT * FROM tbl_PRFPayrollPettyCashDetails2 ORDER BY PRFID DESC 
--DELETE FROM tbl_PRFPayrollPettyCashDetails2 WHERE PRFID > 1374
--DBCC CHECKIDENT('tbl_PRFPayrollPettyCashDetails2', RESEED,54140 )

SELECT * FROM tbl_JE ORDER BY JEID DESC 
--DELETE FROM tbl_JE WHERE PRFID > 4239
--DBCC CHECKIDENT('tbl_JE', RESEED, 104285)

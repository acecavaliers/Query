
SELECT 

T0.DatePrep AS 'DatePrepared'
,T0.DocDate AS Docdate
,T0.PRFID
,T1.SuppName
,T2.CompName
,T0.PaymentFor
,t0.PaymentTerms
,T0.Total
,T0.AddLess
,T0.Net
,T0.TotalPaid
,T0.Balance
,T0.ChkBank
,t0.ChkNum
,t0.CVNum
,t0.ChkDate
,t0.ChkStatus
,t0.PrepBy
,t0.chkApproveDate

FROM TBL_PRFHEADER T0
INNER JOIN TBL_SUPPLIER T1 ON T0.SUPPID = T1.SUPPID
INNER JOIN tbl_Company T2 ON T0.CompID = T2.CompID
WHERE YEAR(T0.DatePrep) = 2020 OR YEAR(T0.ChkDate) = 2020 OR  YEAR(T0.DocDate) = 2020
	

	select * from tbl_PRFHeader
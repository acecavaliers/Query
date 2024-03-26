


SELECT 
CASE WHEN T1.CheckNum = 0 THEN
	T1.U_ChkNumExt
ELSE 
	T1.CheckNum 
END AS CheckNumber,
T0.BankNum as Bank,
T0.AcctNum as Account,
t0.CheckDate as CheckDate,
T1.DocNum as OPDocNo,
T0.PmntDate as OPDocDate,
T0.VendorName as Payee,
T0.CheckSum as CheckAmount,
T0.Canceled as Canceled,
T0.Printed as Printed
FROM OCHO T0
INNER JOIN VPM1 T1 ON T0.CheckKey = T1.CheckAbs
ORDER BY CheckNumber ASC 
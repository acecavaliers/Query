			
DECLARE @PeriodFrom as Date
DECLARE @PeriodTo as Date

SELECT 
T0.U_CheckNum, 
T0.U_Bank,
T0.U_AcctNum,
T0.U_IssueDate,
T2.TransRef AS OPDocNo,
T2.PmntDate AS PaymentDate,
T2.VendorName as Payee,
T2.CheckSum as CheckAmount,
CASE 
	WHEN T2.Printed = 'N' AND T2.Canceled = 'N' THEN 'UNCONFIRMED'
	WHEN T2.Printed = 'Y'  AND T2.Canceled = 'N' THEN 'CONFIRMED'
	WHEN T2.Canceled = 'Y' THEN 'CANCELED'
	ELSE 'UNCONFIRMED'
END AS STATUS,

T2.Printed,
T2.Canceled,
T2.CancelDate,
t2.CheckKey as ChkForPayment,
T2.Details as Comments
FROM [dbo].[@BLANKCHECKISSUANCE] T0
LEFT JOIN VPM1 T1 ON T0.U_CheckNum = T1.U_ChkNumExt
LEFT JOIN OCHO T2 ON T2.TransRef = T1.DocNum AND T2.CheckKey = T1.CheckAbs
LEFT JOIN OVPM T3 ON T1.DOCNUM = T3.DocEntry

--WHERE T2.PmntDate BETWEEN @PeriodFrom AND @PeriodTo

ORDER BY T0.U_Bank, T0.U_AcctNum, T0.U_CheckNum ASC 


--SELECT TA.U_CheckNum, TA.U_Bank, TA.U_Store, TA.U_AcctNum 
--FROM [dbo].[@BLANKCHECKISSUANCE] TA
--WHERE NOT EXISTS(SELECT U_ChkNumExt FROM VPM1 TB WHERE TA.U_CheckNum = TB.U_ChkNumExt )

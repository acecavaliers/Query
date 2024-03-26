SELECT TT.* FROM
(SELECT DISTINCT T.CardName,T.BPLName, T.DocDate, CASE WHEN T.U_PayLoc= '' THEN 'Store Cash Sales' ELSE T.U_PayLoc END AS 'Payment Location', T.U_CollRcptNo, T.U_CollRcptDate, T.U_Collector,T.Canceled, T.DocNum, T1.DocEntry, T.DocTotal, (CASE WHEN T.TenderType = 'Credit Card' THEN T.TenderType + ' - ' +  T.CreditType ELSE T.TenderType END) AS TenderType, T.AmntTendered, T.CreditType, T.CheckDate, T.Bank, T.CheckNo, REPLACE(REPLACE(T2.[Address],char(13),' '),char(10),' ') AS 'ADDRESS', T3.WhsCode, T.CashSum, T.[CheckSum], T.BankTransfr, T.CreditCard, T.CheckSumPDC, T1.WtAppld FROM(
SELECT T0.CardName,T0.BPLName,  T0.DocDate, T0.U_PayLoc, T0.U_CollRcptNo,T0.U_CollRcptDate,T0.U_Collector,T0.Canceled, T0.DocNum, 'Cash' as TenderType, T0.CashSum AS AmntTendered,T0.CashSum, NULL As [CheckSum], NULL AS BankTransfr,NULL AS CreditCard, NULL AS CheckSumPDC, T0.DocTotal, T0.BPLId, NULL AS CreditType, NULL AS CheckDate, NULL AS Bank, NULL AS CheckNo FROM ORCT T0 WHERE T0.CashSum <> 0 
UNION
SELECT T0.CardName,T0.BPLName, T0.DocDate, T0.U_PayLoc, T0.U_CollRcptNo, T0.U_CollRcptDate, T0.U_Collector,T0.Canceled, T0.DocNum, CASE WHEN (SELECT '1' FROM OPDF T2 WHERE T2.CardCode = T0.CardCode AND T2.DocDate = T0.DocDate AND T2.DocTime = T0.DocTime) IS NULL THEN 'Dated Check' ELSE 'Dated Check for PDC' END, T0.[CheckSum],NULL, CASE WHEN (SELECT '1' FROM OPDF T2 WHERE T2.CardCode = T0.CardCode AND T2.DocDate = T0.DocDate AND T2.DocTime = T0.DocTime) IS NULL THEN  T0.[CheckSum] ELSE 0.00 END, NULL,NULL,CASE WHEN (SELECT '1' FROM OPDF T2 WHERE T2.CardCode = T0.CardCode AND T2.DocDate = T0.DocDate AND T2.DocTime = T0.DocTime) IS NULL THEN 0.00 ELSE T0.[CheckSum]  END, T0.DocTotal, T0.BPLId, NULL, T1.DueDate, T1.BankCode, T1.CheckNum FROM ORCT T0 INNER JOIN RCT1 T1 ON T0.DocNum = T1.DocNum
UNION 
SELECT T0.CardName,T0.BPLName, T0.DocDate, T0.U_PayLoc, T0.U_CollRcptNo, T0.U_CollRcptDate, T0.U_Collector,T0.Canceled, T0.DocNum,'Bank Transfer', T0.TrsfrSum,NULL, NULL, T0.[TrsfrSum],NULL,NULL, T0.DocTotal, T0.BPLId, NULL, NULL, NULL, NULL FROM ORCT T0 WHERE T0.[TrsfrSum] <> 0 
UNION
SELECT T0.CardName,T0.BPLName, T0.DocDate, T0.U_PayLoc, T0.U_CollRcptNo, T0.U_CollRcptDate, T0.U_Collector,T0.Canceled, T0.DocNum, 'Credit Card', T1.CreditSum,NULL, NULL, NULL,T0.[CreditSum],NULL, T0.DocTotal, T0.BPLId, T2.CardName, NULL, NULL, NULL FROM ORCT T0 INNER JOIN RCT3 T1 ON T0.DocNum = T1.DocNum INNER JOIN OCRC T2 ON T2.CreditCard = T1.CreditCard
) T INNER JOIN [dbo].[INV1] T3 ON T.DocNum = T3.[DocEntry] INNER JOIN RCT2 T1 ON T.DocNum = T1.DocNum INNER JOIN [dbo].[OBPL] T2 ON T.[BPLId] = T2.[BPLId]
WHERE T.Canceled = 'N' AND T.DocDate >= '04-01-2019' AND T.DocDate <= '07-024-2019' AND T.CardName LIKE '%WALK%' AND T.BPLName LIKE '%kor%'  AND T.TenderType LIKE '%%' AND T.U_PayLoc IN ((CASE WHEN 0 = 1 THEN 'Customer Site' ELSE NULL END), (CASE WHEN 0 = 1 THEN 'Store Collections' ELSE NULL END), (CASE WHEN 0 = 1 THEN 'Head Office' ELSE NULL END), (CASE WHEN 'True' = 1 THEN '' ELSE NULL END))


UNION
SELECT T0.CardName,T0.BPLName, T0.DocDate, NULL, T0.U_CollRcptNo, T0.U_CollRcptDate, T0.U_Collector,T0.Canceled, T0.DocNum,NULL,NULL, 'Wtax', SUM(T1.WtAppld) ,NULL, NULL, NULL,NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL FROM ORCT T0 INNER JOIN RCT2 T1 ON T0.DocNum = T1.DocNum 
WHERE T1.WtAppld <> 0 AND T0.DocNum IN (SELECT DISTINCT TS.DocNum FROM(
SELECT T0.CardName,T0.BPLName, T0.DocDate, T0.U_PayLoc, T0.U_CollRcptNo,T0.U_CollRcptDate,T0.U_Collector, T0.Canceled, T0.DocNum, 'Cash' as TenderType, T0.CashSum AS AmntTendered,T0.CashSum, NULL As [CheckSum], NULL AS BankTransfr,NULL AS CreditCard, NULL AS CheckSumPDC, T0.DocTotal, T0.BPLId, NULL AS CreditType, NULL AS CheckDate, NULL AS Bank, NULL AS CheckNo FROM ORCT T0 WHERE T0.CashSum <> 0 
UNION
SELECT T0.CardName,T0.BPLName, T0.DocDate, T0.U_PayLoc, T0.U_CollRcptNo, T0.U_CollRcptDate, T0.U_Collector, T0.Canceled, T0.DocNum, CASE WHEN (SELECT '1' FROM OPDF T2 WHERE T2.CardCode = T0.CardCode AND T2.DocDate = T0.DocDate AND T2.DocTime = T0.DocTime) IS NULL THEN 'Dated Check' ELSE 'Dated Check for PDC' END, T0.[CheckSum],NULL, CASE WHEN (SELECT '1' FROM OPDF T2 WHERE T2.CardCode = T0.CardCode AND T2.DocDate = T0.DocDate AND T2.DocTime = T0.DocTime) IS NULL THEN  T0.[CheckSum] ELSE 0.00 END, NULL,NULL,CASE WHEN (SELECT '1' FROM OPDF T2 WHERE T2.CardCode = T0.CardCode AND T2.DocDate = T0.DocDate AND T2.DocTime = T0.DocTime) IS NULL THEN 0.00 ELSE T0.[CheckSum]  END, T0.DocTotal, T0.BPLId, NULL, T1.DueDate, T1.BankCode, T1.CheckNum FROM ORCT T0 INNER JOIN RCT1 T1 ON T0.DocNum = T1.DocNum
UNION 
SELECT T0.CardName,T0.BPLName, T0.DocDate, T0.U_PayLoc, T0.U_CollRcptNo, T0.U_CollRcptDate, T0.U_Collector, T0.Canceled, T0.DocNum,'Bank Transfer', T0.TrsfrSum,NULL, NULL, T0.[TrsfrSum],NULL,NULL, T0.DocTotal, T0.BPLId, NULL, NULL, NULL, NULL FROM ORCT T0 WHERE T0.[TrsfrSum] <> 0 
UNION 
SELECT T0.CardName,T0.BPLName, T0.DocDate, T0.U_PayLoc, T0.U_CollRcptNo, T0.U_CollRcptDate, T0.U_Collector, T0.Canceled, T0.DocNum, 'Credit Card', T1.CreditSum,NULL, NULL, NULL,T0.[CreditSum],NULL, T0.DocTotal, T0.BPLId, T2.CardName, NULL, NULL, NULL FROM ORCT T0 INNER JOIN RCT3 T1 ON T0.DocNum = T1.DocNum INNER JOIN OCRC T2 ON T2.CreditCard = T1.CreditCard
) TS INNER JOIN [dbo].[INV1] T3 ON TS.DocNum = T3.[DocEntry] INNER JOIN RCT2 T1 ON TS.DocNum = T1.DocNum INNER JOIN [dbo].[OBPL] T2 ON TS.[BPLId] = T2.[BPLId]


WHERE TS.Canceled = 'N' AND TS.DocDate>= '04-01-2019' AND TS.DocDate <= '07-024-2019'  AND TS.CardName LIKE '%WALK%' AND TS.BPLName LIKE '%KOR%' AND TS.TenderType LIKE '%%'  AND TS.U_PayLoc IN ((CASE WHEN 0 = 1 THEN 'Customer Site' ELSE NULL END), (CASE WHEN 0 = 1 THEN 'Store Collections' ELSE NULL END), (CASE WHEN 0= 1 THEN 'Head Office' ELSE NULL END), (CASE WHEN 'True'= 1 THEN '' ELSE NULL END))


)
GROUP BY T0.CardName,T0.BPLName, T0.DocDate, T0.U_CollRcptNo, T0.U_CollRcptDate, T0.U_Collector,T0.Canceled, T0.DocNum 
) TT ORDER BY TT.TenderType

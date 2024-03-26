SELECT * FROM
(SELECT 
LicTradNum,
CardCode,
CardName,
Address,
Address2,
DocNum,
DocDate,
U_ATC,
T3.Rate,
TaxbleAmnt,
WTAmnt,
AcctName AS ControlAcct 
FROM PCH5 T0 INNER JOIN OPCH T1
ON T0.AbsEntry=T1.DocNum INNER JOIN OWHT T2
ON T0.WTCode=T2.WTCode INNER JOIN WHT1 T3
ON T2.WTCode=T3.WTCode INNER JOIN OACT T4
ON T1.CtlAccount=T4.AcctCode
WHERE T1.CANCELED='N'
AND CARDNAME LIKE '%{?paramName}%'
AND DOCDATE >= {?paramFrom}
AND DOCDATE <= {?paramTo}
ORDER BY DocDate

UNION ALL

SELECT 
LicTradNum,
CardCode,
CardName,
Address,
Address2,
DocNum,
DocDate,
U_ATC,
T3.Rate,
TaxbleAmnt,
WTAmnt,
AcctName AS ControlAcct 
FROM DPO5 T0 INNER JOIN ODPO T1
ON T0.AbsEntry=T1.DocNum INNER JOIN OWHT T2
ON T0.WTCode=T2.WTCode INNER JOIN WHT1 T3
ON T2.WTCode=T3.WTCode INNER JOIN OACT T4
ON T1.CtlAccount=T4.AcctCode
WHERE T1.CANCELED='N'
AND CARDNAME LIKE '%{?paramName}%'
AND DOCDATE >= {?paramFrom}
AND DOCDATE <= {?paramTo}
ORDER BY DocDate) 2307Monitoring
ORDER BY Docdate
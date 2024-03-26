



SELECT T0.DocEntry,
CASE WHEN T2.CANCELED = 'N' THEN ''
WHEN T2.CANCELED = 'Y' THEN 'Cancelled'
ELSE
'Cancellation' END AS Status,

T2.DOCDATE AS PostingDate,
T2.TaxDate as DocumentDate,
T0.AcctCode, T1.AcctName, T0.DSCRIPTION, 
T0.OcrCode AS 'Store Performance', T0.OCRCODE2 AS 'Expenses By Function', T0.VatGroup AS TaxCode, t0.LineTotal as Amount
FROM PCH1 T0 
LEFT JOIN OACT T1 ON T0.ACCTCODE = T1.AcctCode
LEFT JOIN OPCH T2 ON T0.DOCENTRY = T2.DOCNUM
WHERE T0.ACCTCODE = 'OC031800'
OR T0.ACCTCODE = 'OC032000' 
OR T0.ACCTCODE = 'OC040000' 


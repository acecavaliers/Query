SELECT 
T0.DOCNUM AS 'Document Number',
CASE WHEN T0.CANCELED = 'N' THEN '-' ELSE 'Cancelled' END AS 'Status',
T0.Printed,
T0.DocDate AS 'Posting Date',
T0.DocDueDate AS 'Delivery Date',
T0.TaxDate AS 'Document Date',
T1.Dscription AS 'Description',
T1.AcctCode as 'G/L Account',
T2.AcctName AS 'G/L Account Name',
T1.OcrCode AS 'Store Performance',
T1.OCRCODE2 AS 'Expenses by Function',
T1.LineTotal as 'Unit Price',
T1.VatGroup as 'Tax Code',
t1.PriceAfVAT as 'Unit Cost'
FROM OPOR T0 
LEFT JOIN POR1 T1 ON T0.DOCNUM = T1.DOCENTRY
LEFT JOIN OACT T2 ON T1.ACCTCODE = T2.AcctCode
WHERE T0.CARDCODE = 'V000043'

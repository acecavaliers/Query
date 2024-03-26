
DECLARE @AllWhse as varchar = '{?AllWhse}'

select
ROW_NUMBER() OVER(ORDER BY ItemName ASC) AS Row#,
T0.Transseq,
T0.TRANSTYPE AS TransactionCode,

CASE WHEN T0.TRANSTYPE = 69 THEN 'Landed Costs'
WHEN T0.TransType = 15 THEN 'Delivery'
WHEN T0.TransType = 310000001 then 'Inventory Opening Balance'
WHEN T0.TransType = 67 then 'Inventory Transfer'
WHEN T0.TransType = 21 then 'Goods Return'
WHEN T0.TransType = 18 then 'A/P Invoice'
WHEN T0.TransType = 19 then 'A/P Credit Memo'
WHEN T0.TransType = 13 then 'A/R Invoice'
WHEN T0.TransType = 162 then 'Inventory Reevaluation'
WHEN T0.TransType = 59 then 'Goods Receipt'
WHEN T0.TransType = 60 then 'Goods Issue'
WHEN T0.TransType = 20 then 'GRPO'
WHEN T0.TransType = 14 then 'A/R Credit Memo'
END AS TransactionType,
T0.BASE_REF AS BaseDocument,
T0.DocLineNum,
'---------------------------',

T0.DOCDATE AS Date,
T0.Itemcode as 'Product Code',
T1.ItemName as 'Product Name',
T2.Comments as Description,
CONCAT(
CASE WHEN T0.TRANSTYPE = 69 THEN 'IF-'
WHEN T0.TransType = 15 THEN 'DN-'
WHEN T0.TransType = 310000001 then 'OB-'
WHEN T0.TransType = 67 then 'IM-'
WHEN T0.TransType = 21 then 'PR-'
WHEN T0.TransType = 18 then 'PU-'
WHEN T0.TransType = 19 then 'PC-'
WHEN T0.TransType = 13 then 'IN-'
WHEN T0.TransType = 162 then 'MR-'
WHEN T0.TransType = 59 then 'SI-'
WHEN T0.TransType = 60 then 'SO-'
WHEN T0.TransType = 20 then 'PD-'
WHEN T0.TransType = 14 then 'CN-' end
,
REPLICATE('0', 7 - LEN(T0.BASE_REF)) + CAST(T0.BASE_REF AS varchar) ) AS Reference,


T0.LocCode AS Warehouse,
CASE WHEN T0.InQty > 0 THEN
T0.InQty
ELSE
T0.OutQty * -1
END AS Quantity,

T3.UomCode,
CAST(T2.Price AS MONEY) as 'PHP Unit Price',
CAST(t0.sumstock AS MONEY) as 'PHP Amount'


--CASE WHEN @AllWhse = 'n' THEN
--SUM(isnull(t0.InQty,0) - isnull(t0.outQty,0)) OVER (PARTITION BY T1.ITEMCODE, T0.LocCode ORDER BY T1.ITEMNAME,  T0.LocCode, t0.TransSeq,  T0.DocDate ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ) 
--WHEN @AllWhse = 'Y' THEN
--SUM(isnull(t0.InQty,0) - isnull(t0.outQty,0)) OVER (PARTITION BY T1.ITEMCODE ORDER BY T1.ITEMNAME, t0.TransSeq, T0.LocCode, T0.DocDate ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW )
--END as 'Balance Quantity',

--CASE WHEN @AllWhse = 'n' THEN
--SUM(isnull(T0.sumStock,0)) OVER (PARTITION BY T1.ITEMCODE, T0.LocCode ORDER BY T1.ITEMNAME, T0.LocCode, t0.TransSeq,  T0.DocDate ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW )
--WHEN @AllWhse = 'Y' THEN
--SUM(isnull(T0.sumStock,0)) OVER (PARTITION BY T1.ITEMCODE ORDER BY T1.ITEMNAME, t0.TransSeq, T0.LocCode, T0.DocDate ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ) 
--END as 'PHP Balance Amount'

FROM OIVL T0
INNER JOIN OITM T1 ON T0.ItemCode = T1.ItemCode
INNER JOIN OINM T2 ON T0.Transtype = T2.Transtype AND T0.BASE_REF = T2.BASE_REF AND T0.TransSeq = T2.TransSeq
INNER JOIN OUOM T3 ON T1.InvntryUom = T3.UomName
--WHERE (T0.Transtype = 13)
--AND T0.docdate >= @DateFrom AND T0.DocDate <= @DateTo
--AND T0.LocCode = 'KORST2GS'
--AND T0.ItemCode = '0006226SHMTS'
ORDER BY CAST(T0.BASE_REF AS integer) ASC



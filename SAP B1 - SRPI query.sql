SELECT * FROM
(select 
'Sales' as 'Transaction Type',
T0.DocEntry AS 'Transaction#',
T3.CANCELED,
T0.DocDate AS 'Posting Date',
t3.numatcard AS 'Reference#',
T4.CardFName AS 'Foreign Name',
T0.ocrcode AS 'Whse',
T0.ItemCode AS 'Item Code',

CASE WHEN T3.CANCELED = 'C' THEN T0.Quantity * -1
ELSE
T0.Quantity
END AS 'Quantity Sold',

T0.U_GPBD AS 'Price Before Discount',

CASE WHEN T3.CANCELED = 'C' THEN
T0.PriceAfVAT * -1
ELSE
T0.PRICEAFVAT
END AS 'Price After Discount',

CASE WHEN T3.CANCELED = 'C' THEN
T0.Price *-1
ELSE
T0.PRICE
END AS 'Price After Discount(VAT-Ex)',

CASE WHEN T3.CANCELED = 'C' THEN
T0.StockValue / T0.Quantity * -1
ELSE
T0.STOCKVALUE / T0.QUANTITY 
END AS 'Cost',

CASE WHEN T3.CANCELED = 'C' THEN
T0.Price * T0.Quantity * -1
ELSE
T0.PRICE * T0.QUANTITY
END AS 'Total Sales',

CASE WHEN T3.CANCELED = 'C' THEN
CAST(T0.StockValue / T0.Quantity AS float) * T0.Quantity * -1
ELSE
CAST(T0.StockValue / T0.Quantity AS float) * T0.Quantity
END AS 'Total Cost',


CASE WHEN T3.CANCELED = 'C' THEN
T0.Price * T0.Quantity - T0.StockValue / T0.Quantity * T0.Quantity * -1
ELSE
T0.Price * T0.Quantity - T0.StockValue / T0.Quantity * T0.Quantity
END AS 'Gross Profit',

CASE WHEN T0.StockValue / T0.Quantity = 0 THEN '100'
ELSE
 (T0.Price * T0.Quantity - T0.StockValue / T0.Quantity * T0.Quantity) / nullif(T0.price * 100 , 0)
END as 'Profit Margin'

from INV1 T0

INNER JOIN OITM T1 ON T0.ItemCode = T1.ItemCode
INNER JOIN OITB T2 ON T1.ItmsGrpCod = T2.ItmsGrpCod
INNER JOIN OINV T3 ON T0.DocEntry = T3.DocNum
INNER JOIN OCRD T4 ON T3.CardCode = T4.CardCode

WHERE T3.U_DocSeries NOT LIKE '%OB%'
AND year(T3.TAXDATE) = 2019

UNION ALL 

select
'Credit Memo' as 'Transaction Type',
T0.DocEntry AS 'Transaction#',
T3.CANCELED,
T0.DocDate AS 'Posting Date',
T3.NumAtCard AS 'Reference#',
T4.CardFName AS 'Foreign Name',
T0.ocrcode AS 'Whse',
T0.ItemCode AS 'Item Code',
T0.Quantity * -1 AS 'Quantity Sold',
T0.U_GPBD AS 'Price Before Discount',
T0.PriceAfVAT * -1 AS 'Price After Discount',
T0.Price * -1 AS 'Price After Discount(VAT-Ex)',
T0.StockValue / T0.Quantity * -1 AS 'Cost',

CASE WHEN T3.CANCELED = 'C' THEN (T0.Price * T0.Quantity)
ELSE
(T0.Price * T0.Quantity) * -1
END AS 'Total Sales',

CAST(T0.StockValue / T0.Quantity AS float) * T0.Quantity * -1 AS 'Total Cost',
(T0.Price * T0.Quantity - T0.StockValue / T0.Quantity * T0.Quantity) * -1 AS 'Gross Profit',

CASE WHEN T0.StockValue / T0.Quantity = 0 THEN '100'
ELSE
 ((T0.Price * T0.Quantity - T0.StockValue / T0.Quantity * T0.Quantity) / nullif(T0.price * 100 , 0)) * -1
END as 'Profit Margin'

from RIN1 T0

INNER JOIN OITM T1 ON T0.ItemCode = T1.ItemCode
INNER JOIN OITB T2 ON T1.ItmsGrpCod = T2.ItmsGrpCod
INNER JOIN ORIN T3 ON T0.DocEntry = T3.DocNum 
INNER JOIN OCRD T4 ON T3.CardCode = T4.CardCode

WHERE T3.U_DocSeries NOT LIKE '%OB%'
AND year(T3.TAXDATE) = 2019

) DetailedSalesReport
ORDER BY 'Transaction#' ASC



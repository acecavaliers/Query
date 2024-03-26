SELECT * FROM
(
--AR INVOICE / AR RESERVE INVOICE
SELECT
	T2.ItmsGrpNam AS 'Department',
	T1.U_Category AS 'Category',
	CASE WHEN t3.[isIns] = 'Y' THEN
		'AR Reserve'
	ELSE
		'AR Invoice'
	END AS 'Transaction Type',
	CASE WHEN T3.CANCELED = 'Y' THEN
		'Cancelled'
	WHEN T3.CANCELED = 'C' THEN
		'Cancellation'
	WHEN T3.CANCELED = 'N' THEN 
		' - '
	END AS 'Status',
	T0.DocEntry AS 'Transaction#',
	T3.TAXDATE AS 'Docdate',
	T3.numatcard AS 'Reference#',
	T3.CardName AS 'Customer',
	T3.Comments AS 'Comments',
	T0.ocrcode AS 'Whse',
	T0.ItemCode AS 'Item Code',
	T0.UOMCODE AS 'unit',
	T0.Dscription AS 'Description',
	T0.whscode as Warehouse,
	CASE WHEN T3.CANCELED = 'Y' THEN
		T0.StockValue / T0.Quantity
	WHEN T3.CANCELED = 'C' THEN
		(T0.StockValue / T0.Quantity) * -1
	WHEN T3.CANCELED = 'N' THEN 
		T0.StockValue / T0.Quantity
	END AS 'Cost',
	CASE WHEN T3.CANCELED = 'Y' THEN
		try_convert(numeric(38, 12), T0.U_GPBD)
	WHEN T3.CANCELED = 'C' THEN
		try_convert(numeric(38, 12), T0.U_GPBD) * -1
	WHEN T3.CANCELED = 'N' THEN 
		try_convert(numeric(38, 12), T0.U_GPBD)
	END AS 'Price Before Discount',
	CASE WHEN T3.CANCELED = 'Y' THEN
		T0.PriceAfVAT
	WHEN T3.CANCELED = 'C' THEN
		T0.PriceAfVAT * -1
	WHEN T3.CANCELED = 'N' THEN 
		T0.PriceAfVAT
	END AS 'Price After Discount(VAT-Inc)',
	CASE WHEN T3.CANCELED = 'Y' THEN
		(T0.PriceAfVAT / 1.12)
	WHEN T3.CANCELED = 'C' THEN
		(T0.PriceAfVAT / 1.12) * -1
	WHEN T3.CANCELED = 'N' THEN 
		(T0.PriceAfVAT / 1.12)
	END AS 'Price After Discount(VAT-Ex)',
	CASE WHEN T3.CANCELED = 'Y' THEN
		T0.Quantity
	WHEN T3.CANCELED = 'C' THEN
		T0.Quantity * -1
	WHEN T3.CANCELED = 'N' THEN 
		T0.Quantity
	END AS 'Quantity Sold',
	CASE WHEN T3.CANCELED = 'Y' THEN
		ROUND((T0.PriceAfVAT * T0.Quantity) / 1.12 , 2 )
	WHEN T3.CANCELED = 'C' THEN
		ROUND(((T0.PriceAfVAT * T0.Quantity)  / 1.12) * -1 , 2 )
	WHEN T3.CANCELED = 'N' THEN 
		ROUND(((T0.PriceAfVAT * T0.Quantity)  / 1.12) , 2 )
	END AS 'Total Sales (VAT-Ex)',
	CASE WHEN T3.CANCELED = 'Y' THEN
		T0.PriceAfVAT * T0.Quantity 
	WHEN T3.CANCELED = 'C' THEN
		T0.PriceAfVAT * T0.Quantity  * -1
	WHEN T3.CANCELED = 'N' THEN 
		T0.PriceAfVAT * T0.Quantity 
	END AS 'Total Sales (VAT-Inc)',
	CASE WHEN T3.CANCELED = 'Y' THEN
		CAST(T0.StockValue / T0.Quantity AS float) * T0.Quantity
	WHEN T3.CANCELED = 'C' THEN
		(CAST(T0.StockValue / T0.Quantity AS float) * T0.Quantity)  * -1
	WHEN T3.CANCELED = 'N' THEN 
		CAST(T0.StockValue / T0.Quantity AS float) * T0.Quantity
	END AS 'Total Cost',
	CASE WHEN T3.CANCELED = 'Y' THEN
		T0.Price * T0.Quantity - T0.StockValue / T0.Quantity * T0.Quantity 
	WHEN T3.CANCELED = 'C' THEN
		(T0.Price * T0.Quantity - T0.StockValue / T0.Quantity * T0.Quantity)  * -1
	WHEN T3.CANCELED = 'N' THEN 
		T0.Price * T0.Quantity - T0.StockValue / T0.Quantity * T0.Quantity 
	END AS 'Gross Profit',
	CASE WHEN T0.StockValue / T0.Quantity = 0 THEN 
		'100'
	ELSE
		(T0.Price * T0.Quantity - T0.StockValue / T0.Quantity * T0.Quantity) / nullif(T0.price * 100 , 0)
	END as 'Profit Margin'

FROM INV1 T0
INNER JOIN OITM T1 ON T0.ItemCode = T1.ItemCode
INNER JOIN OITB T2 ON T1.ItmsGrpCod = T2.ItmsGrpCod
INNER JOIN OINV T3 ON T0.DocEntry = T3.DocNum
INNER JOIN OCRD T4 ON T3.CardCode = T4.CardCode
--------
UNION ALL 
--------

--AR CM

SELECT 
	T2.ItmsGrpNam AS 'Department',
	T1.U_Category AS 'Category',
	'Credit Memo' AS 'Transaction Type',
	CASE WHEN T3.CANCELED = 'Y' THEN
		'Cancelled'
	WHEN T3.CANCELED = 'C' THEN
		'Cancellation'
	WHEN T3.CANCELED = 'N' THEN 
		' - '
	END AS 'Status',
	T0.DocEntry AS 'Transaction#',
	T3.TAXDATE AS 'Docdate',
	T3.numatcard AS 'Reference#',
	T3.CardName AS 'Customer',
	T3.Comments AS 'Comments',
	T0.ocrcode AS 'Whse',
	T0.ItemCode AS 'Item Code',
	T0.UOMCODE AS 'unit',
	T0.Dscription AS 'Description',
	T0.whscode as Warehouse, 
	CASE WHEN T3.CANCELED = 'Y' THEN
		T0.StockValue / T0.Quantity
	WHEN T3.CANCELED = 'C' THEN
		(T0.StockValue / T0.Quantity) * -1
	WHEN T3.CANCELED = 'N' THEN 
		T0.StockValue / T0.Quantity * -1
	END AS 'Cost',
	CASE WHEN T3.CANCELED = 'Y' THEN
		try_convert(numeric(38, 12), T0.U_GPBD)
	WHEN T3.CANCELED = 'C' THEN
		try_convert(numeric(38, 12), T0.U_GPBD) * -1
	WHEN T3.CANCELED = 'N' THEN 
		try_convert(numeric(38, 12), T0.U_GPBD) * -1
	END AS 'Price Before Discount',
	CASE WHEN T3.CANCELED = 'Y' THEN
		T0.PriceAfVAT
	WHEN T3.CANCELED = 'C' THEN
		T0.PriceAfVAT * -1
	WHEN T3.CANCELED = 'N' THEN 
		T0.PriceAfVAT * -1
	END AS 'Price After Discount(VAT-Inc)',
	CASE WHEN T3.CANCELED = 'Y' THEN
		(T0.PriceAfVAT / 1.12)
	WHEN T3.CANCELED = 'C' THEN
		(T0.PriceAfVAT / 1.12) * -1
	WHEN T3.CANCELED = 'N' THEN 
		(T0.PriceAfVAT / 1.12) * -1
	END AS 'Price After Discount(VAT-Ex)',
	CASE WHEN T3.CANCELED = 'Y' THEN
		T0.Quantity
	WHEN T3.CANCELED = 'C' THEN
		T0.Quantity * -1
	WHEN T3.CANCELED = 'N' THEN 
		T0.Quantity * -1
	END AS 'Quantity Sold',
	CASE WHEN T3.CANCELED = 'Y' THEN
		ROUND((T0.PriceAfVAT * T0.Quantity) / 1.12, 2)
	WHEN T3.CANCELED = 'C' THEN
		ROUND(((T0.PriceAfVAT * T0.Quantity)  / 1.12) * -1 , 2 )
	WHEN T3.CANCELED = 'N' THEN 
		ROUND(((T0.PriceAfVAT * T0.Quantity)  / 1.12) * -1 , 2 )
	END AS 'Total Sales (VAT-Ex)',
	CASE WHEN T3.CANCELED = 'Y' THEN
		T0.PriceAfVAT * T0.Quantity 
	WHEN T3.CANCELED = 'C' THEN
		(T0.PriceAfVAT * T0.Quantity)  * -1
	WHEN T3.CANCELED = 'N' THEN 
		(T0.PriceAfVAT * T0.Quantity)  * -1
	END AS 'Total Sales (VAT-Inc)',
	CASE WHEN T3.CANCELED = 'Y' THEN
		CAST(T0.StockValue / T0.Quantity AS float) * T0.Quantity
	WHEN T3.CANCELED = 'C' THEN
		(CAST(T0.StockValue / T0.Quantity AS float) * T0.Quantity)  * -1
	WHEN T3.CANCELED = 'N' THEN 
		(CAST(T0.StockValue / T0.Quantity AS float) * T0.Quantity)  * -1
	END AS 'Total Cost',
	CASE WHEN T3.CANCELED = 'Y' THEN
		T0.Price * T0.Quantity - T0.StockValue / T0.Quantity * T0.Quantity 
	WHEN T3.CANCELED = 'C' THEN
		(T0.Price * T0.Quantity - T0.StockValue / T0.Quantity * T0.Quantity)  * -1
	WHEN T3.CANCELED = 'N' THEN 
		(T0.Price * T0.Quantity - T0.StockValue / T0.Quantity * T0.Quantity) * -1
	END AS 'Gross Profit',
	CASE WHEN T0.StockValue / T0.Quantity = 0 THEN 
		'100'
	ELSE
		(T0.Price * T0.Quantity - T0.StockValue / T0.Quantity * T0.Quantity) / nullif(T0.price * 100 , 0)
	END as 'Profit Margin'

from RIN1 T0

INNER JOIN OITM T1 ON T0.ItemCode = T1.ItemCode
INNER JOIN OITB T2 ON T1.ItmsGrpCod = T2.ItmsGrpCod
INNER JOIN ORIN T3 ON T0.DocEntry = T3.DocNum
INNER JOIN OCRD T4 ON T3.CardCode = T4.CardCode
WHERE T0.BASETYPE <> 203
) DetailedSalesReport
Where YEAR(Docdate) = 2020 AND MONTH(DOCDATE) <= 11
ORDER BY 'Transaction#' ASC

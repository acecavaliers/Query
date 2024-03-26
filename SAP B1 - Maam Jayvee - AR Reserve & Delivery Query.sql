
---------- AR RESERVE
SELECT
t0.DocNum,
t0.CANCELED,
CASE WHEN T0.InvntSttus = 'O' THEN 'Not Delivered'
ELSE 'Delivered' END AS DeliveryStatus,
T0.DocDate AS ARPostingDate,
T0.TaxDate as ARTaxDate,
T0.NumAtCard AS RefNo,
T1.ItemCode AS ItemCode,
t1.Dscription as ItemDescription,
T1.QUantity,
T1.WHSCODE,
T1.OCRCODE,
T1.LineTotal
FROM OINV T0
LEFT JOIN INV1 T1 ON T0.DOCNUM = T1.DOCENTRY 
WHERE T0.ISINS = 'Y' AND
YEAR(TaxDate) BETWEEN 2021 AND 2021
AND MONTH(TaxDate) BETWEEN 1 AND 7
ORDER BY t0.DOCNUM, TaxDate ASC 
---------DELIVERY
SELECT 
T0.DOCNUM AS DeliveryNumber,
t0.CANCELED,
T0.DocDate as DeliveryPostingDate,
T0.TaxDate as DeliveryDocumentDate,
T1.BaseDocNum as ARReserveNumber,
T1.ItemCode AS ItemCode,
T1.Dscription AS ItemDescription,
ROUND(T1.StockValue,2 ) as Cost,
T1.Quantity,
T1.WHSCODE,
T1.OCRCODE,
T1.LINETOTAL
FROM ODLN T0 
INNER JOIN DLN1 T1 ON T0.DOCNUM = T1.DOCENTRY
WHERE 
YEAR(TaxDate) BETWEEN 2021 AND 2021
AND MONTH(TaxDate) BETWEEN 1 AND 7
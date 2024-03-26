

---------------GOODS ISSUE
SELECT 
	T0.DOCNUM AS DocNum
	,T0.DocDate AS PostingDate
	,T0.TaxDate AS DocumentDate
	,T1.ItemCode
	,T1.DSCRIPTION as ItemDescription
	,T1.UomCode as UOM
	,T1.WhsCode as Whse
	,t1.quantity
	,ISNULL(T0.Comments,'') as Remarks
FROM OIGE T0
LEFT JOIN IGE1 T1 ON T0.DOCNUM = T1.DOCENTRY
--------------------------
---------------GOODS RECEIPT
SELECT 
	T0.DOCNUM AS DocNum
	,T0.DocDate AS PostingDate
	,T0.TaxDate AS DocumentDate
	,T1.ItemCode
	,T1.DSCRIPTION as ItemDescription
	,T1.UomCode as UOM
	,T1.WhsCode as Whse
	,t1.quantity
	,ISNULL(T0.Comments,'') as Remarks
FROM OIGN T0
LEFT JOIN IGN1 T1 ON T0.DOCNUM = T1.DOCENTRY
--------------------------
--------------------------INVENTORY TRANSFER
SELECT
	T0.DOCNUM AS DocNum
	,T0.DocDate AS PostingDate
	,T0.TaxDate AS DocumentDate
	,T0.FILLER AS FromWarehosue
	,T0.ToWhsCode as ToWarehouse
	,T1.ItemCode
	,T1.DSCRIPTION as ItemDescription
	,T1.UomCode as UOM
	,T1.WhsCode as Whse
	,t1.quantity
	,ISNULL(T0.Comments,'') as Remarks
FROM OWTR T0
LEFT JOIN WTR1 T1 ON T0.DOCNUM = T1.DOCENTRY
--------------------------
--------------------------INVENTORY AUDIT REPORT

 SELECT
	T0.ITEMCODE AS ItemCode
	,T0.ITEMNAME AS ItemName
	,T1.WHSCODE AS Whse
	,T2.WhsName
	,T1.OnHand AS InStock
	,T1.IsCommited as Commited
	,T1.OnOrder as Ordered
	,T1.AvgPrice AS Cost
	,T0.InvntryUom
FROM OITM T0 
LEFT JOIN OITW T1 ON T0.ITEMCODE = T1.ITEMCODE
LEFT JOIN OWHS T2 ON T1.WhsCode = T2.WhsCode
WHERE T0.SELLITEM = 'Y' and t1.whscode = 'DISCTRGS'
ORDER BY T0.ItemCode ASC
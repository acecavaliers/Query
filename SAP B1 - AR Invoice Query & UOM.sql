SELECT
	T0.DocNum AS 'AR No.'
	,CASE 
		WHEN T0.CANCELED = 'Y' THEN 'Canceled' 
		WHEN T0.CANCELED = 'N' THEN '-'
		WHEN T0.CANCELED = 'C' THEN 'Cancellation' 
	END as 'Status'
	,CAST(T0.DocDate as Date) as 'Posting Date'
	,CAST(T0.DocDueDate as Date) as 'Due Date'
	,CAST(T0.TaxDate as Date) as 'Document Date'
	,T0.CardCode as 'Customer'	,T0.CardName as 'Name'
	,T0.NumAtCard as 'Customer Ref. No.'	,T0.U_DocSeries as 'Document Series'
	,T1.ItemCode	,T1.Dscription as 'Item Description'
	,T1.Quantity	,T1.UomCode	,T1.NumPerMsr	,T1.WhsCode as Whse
	,T1.OcrCode as 'Store Performance'
	--,t2.UgpEntry
	--,T1.UomEntry
	--,(SELECT 
	--	CASE WHEN TA.LineNum = 1 THEN 'Parent UOM'
	--	ELSE 'Child UOM' END
	-- FROM UGP1 TA
	--  WHERE T2.UGPENTRY = TA.UGPENTRY AND TA.UomEntry = T1.UomEntry) AS 'UOM Level'
	--,(SELECT 
	--	TA.LineNum
	-- FROM UGP1 TA WHERE T2.UGPENTRY = TA.UGPENTRY AND TA.UomEntry = T1.UomEntry) AS 'UOM Level #'
	--,(SELECT 
	--	TA.UomEntry
	-- FROM UGP1 TA WHERE T2.UGPENTRY = TA.UGPENTRY AND TA.UomEntry = T1.UomEntry) AS 'UOM Level #'
	-- ,
	 ,(SELECT TA.LINENUM FROM UGP1 TA
	 LEFT JOIN OUOM TB ON TA.UomEntry = TB.UomEntry
	 WHERE TA.UGPENTRY = T2.UGPENTRY AND TB.UOMCODE = T3.UomCode) AS 'UOM Level'
FROM OINV T0
LEFT JOIN INV1 T1 ON T0.Docnum = T1.Docentry	
LEFT JOIN OITM T2 ON T1.ItemCode = T2.itemcode
LEFT JOIN OUOM T3 ON T1.UomCode = T3.UomCode
WHERE T0.U_DOCSERIES NOT LIKE '%OB%'
ORDER BY T0.DocNum ASC


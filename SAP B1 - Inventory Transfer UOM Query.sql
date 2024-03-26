SELECT
	T0.DocNum AS 'AR No.'
	,CAST(T0.DocDate as Date) as 'Posting Date'
	,CAST(T0.DocDueDate as Date) as 'Due Date'
	,CAST(T0.TaxDate as Date) as 'Document Date'
	,T1.ItemCode
	,T1.Dscription as 'Item Description'
	,T1.WhsCode as Whse
	,T1.Quantity
	,T1.UomCode	
	,T1.NumPerMsr	
	,(SELECT TA.LINENUM FROM UGP1 TA
	LEFT JOIN OUOM TB ON TA.UomEntry = TB.UomEntry
	WHERE TA.UGPENTRY = T2.UGPENTRY AND TB.UOMCODE = T3.UomCode) AS 'UOM Level'
	,(SELECT TB.UomCode FROM UGP1 TA
	LEFT JOIN OUOM TB ON TA.UomEntry = TB.UomEntry
	WHERE TA.UGPENTRY = T2.UGPENTRY AND TA.LineNum = 2) AS 'UOM Code'
	,(SELECT TA.LINENUM FROM UGP1 TA
	LEFT JOIN OUOM TB ON TA.UomEntry = TB.UomEntry
	WHERE TA.UGPENTRY = T2.UGPENTRY AND TA.LineNum = 2) AS 'Parent UOM'
	,(SELECT TA.BaseQty FROM UGP1 TA
	LEFT JOIN OUOM TB ON TA.UomEntry = TB.UomEntry
	WHERE TA.UGPENTRY = T2.UGPENTRY AND TA.LineNum = 2) AS 'Parent UOM Conversion'
	,isnull((SELECT T1.Quantity/ TA.BaseQty FROM UGP1 TA
	LEFT JOIN OUOM TB ON TA.UomEntry = TB.UomEntry
	WHERE TA.UGPENTRY = T2.UGPENTRY AND TA.LineNum = 2),0)  as TransQuantityConversion
FROM OWTR T0
LEFT JOIN WTR1 T1 ON T0.Docnum = T1.Docentry	
LEFT JOIN OITM T2 ON T1.ItemCode = T2.itemcode
LEFT JOIN OUOM T3 ON T1.UomCode = T3.UomCode
ORDER BY T0.DocNum ASC


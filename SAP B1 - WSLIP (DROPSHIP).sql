--SELECT * FROM ORDR WHERE U_BO_DRS = 'Y'
---- DOCNUM = 10043

--SELECT * FROM OPOR WHERE DOCNUM = 755

-- OPOR - PURCHASE ORDER HEADER
-- POR1 - PURCHASE ORDER ROWS
-- ORDR - SALES ORDER HEADER
-- RDR1 - SALES ORDER ROWS 


SELECT 
	T3.CardCode AS [Sales order CardCode],
	T3.CARDNAME AS [Sales order Customer],
	T3.DocNum AS [Sales order DocNum],
	T2.ItemCode AS [ItemCode sales order],
	T2.Dscription AS [Item sales order],
	T2.UNITMSR,
	T2.Quantity AS [Qty sales order],
	T1.CardCode AS [Purchase order CardCode],
	T1.CARDNAME AS [Purchase order Cardname],
	T1.DocNum AS [Purchase order DocNum],
	T0.ItemCode AS [ItemCode purchase order],
	T0.Dscription AS [Item purchase order],
	T0.UNITMSR,
	T0.Quantity AS [Qty purchase order],
	CONCAT(
	   CASE WHEN T4.[StreetNo] = '' OR T4.[StreetNo] = NULL THEN '' ELSE T4.[StreetNo]+' 'END,
	   CASE WHEN T4.[Block] = '' OR T4.[Block] = NULL THEN '' ELSE T4.[Block]+' 'END,
	   CASE WHEN T4.[City] = '' OR T4.[City] = NULL THEN '' ELSE T4.[City]+', 'END,
	   CASE WHEN T4.[ZipCode] = '' OR T4.[ZipCode] = NULL THEN '' ELSE T4.[ZipCode]END
	   ) AS InvoiceAddress,
T4.FEDTAXID
FROM 
	POR1 T0
	INNER JOIN OPOR T1 ON T0.DocEntry = T1.DocEntry
	INNER JOIN RDR1 T2 ON T2.DocEntry = T0.BaseEntry AND T0.BaseType = 17
	INNER JOIN ORDR T3 ON T3.DocEntry = T2.DocEntry
	INNER JOIN OWHS T4 ON T4.WhsCode = T0.WhsCode
WHERE T3.U_BO_DRS = 'Y'
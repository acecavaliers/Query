


		SELECT 
		T0.DocNum 
		,T0.DocDate as PostingDate
		,T0.DocDueDate as DueDate
		,T0.TaxDate as DocumentDate
		,T0.CARDCODE as Customer
		,T0.CardName as Name
		,T0.U_Customer as CusName
		,T0.NumAtCard as RefNo
		,T0.VatSum AS TotalVat
		,T0.DocTotal as DocumentTotal
		,T0.Comments as Remarks
		FROM OINV T0 
		WHERE (YEAR(T0.TaxDate) = 2019 OR YEAR(T0.DocDate) = 2019 ) AND T0.CardCode = 'C000107'
		ORDER BY DOCNUM ASC
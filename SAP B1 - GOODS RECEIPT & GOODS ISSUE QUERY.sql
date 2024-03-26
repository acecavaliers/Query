




			--SELECT
			--	'Goods Receipt' as DocumentType
			--	,T0.DOCNUM AS DocumentNumber
			--	,T0.Docdate as PostingDate
			--	,T0.TaxDate as DocumentDate
			--	,T0.Comments AS Comments
			--	,T1.Itemcode
			--	,T1.Dscription
			--	,T1.Quantity
			--	,T1.WhsCode
			--	,T1.UomCode
			--	,T1.AcctCode
			--	,T2.AcctName
			--	,t1.Price as Cost
			--	,T1.LineTotal
			--FROM OIGN T0
			--LEFT JOIN IGN1 T1 ON T0.DOCNUM = T1.DOCENTRY
			--LEFT JOIN OACT T2 ON T1.AcctCode = T2.AcctCode
			--WHERE T1.WhsCode = 'KORST2GS' AND
			--YEAR(T0.Docdate) >=2019

			SELECT
				'Goods Issue' as DocumentType
				,T0.DOCNUM AS DocumentNumber
				,T0.Docdate as PostingDate
				,T0.TaxDate as DocumentDate
				,T0.Comments AS Comments
				,T1.Itemcode
				,T1.Dscription
				,T1.Quantity
				,T1.WhsCode
				,T1.UomCode
				,T1.AcctCode
				,T2.AcctName
				,t1.Price as Cost
				,T1.LineTotal
			FROM OIGE T0
			LEFT JOIN IGE1 T1 ON T0.DOCNUM = T1.DOCENTRY
			LEFT JOIN OACT T2 ON T1.AcctCode = T2.AcctCode
			WHERE T1.WhsCode = 'KORST2GS' AND
			YEAR(T0.Docdate) >=2019



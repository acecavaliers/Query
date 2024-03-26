
						DECLARE @PeriodFrom as Date = '07-01-2021'
						DECLARE @PeriodTo as Date = '07-31-2021'
						select
							'AR',
							T0.DOCNUM AS Entry#
							,t0.DocDate
							,T0.TaxDate as InvDate
							,T1.Quantity as Quantity
							,t0.NumAtCard as RefNum
							,t0.U_DocSeries
							,T3.ItemName as ItemDescription
							,t1.WhsCode
							,t1.VatGroup
							,t1.ocrcode as 'Store Performance'
							--,T1.Price as SellingPrice
							,T1.PriceAfVAT as SellingPrice
							,T2.SLPNAME as Salesman
							,T0.CardName as Customername

							, CASE WHEN T0.U_SO_Cash = 'Y' THEN 'CASH'
							WHEN T0.U_SO_OT = 'Y' THEN 'Online Transfer'
							WHEN T0.U_SO_ODC = 'Y' THEN 'On Date Check'
							WHEN T0.U_SO_CC = 'Y' THEN 'Credit Card'
							WHEN T0.U_SO_COD = 'Y' THEN 'Cash On Delivery'
							WHEN T0.U_SO_DTC = 'Y' THEN 'Due to Customer'
							WHEN T0.U_SO_PDC = 'Y' THEN 'PDC'
							WHEN T0.U_SO_PO = 'Y' THEN 'PO'
							WHEN T0.U_SO_CM = 'Y' THEN 'CM'
							WHEN T0.U_SO_DC = 'Y' THEN 'Debit Card'
							ELSE 'BO'
							END as Type
							
							--,(T1.PriceAfVAT / (1 + (SELECT rate/100 FROM VTG1 Ta where T1.VATGROUP = Ta.CODE))) * T1.Quantity as TotalSales
							,T1.PriceAfVAT * T1.Quantity as TotalSales
													
						-- AR INVOICE HEADER
						FROM OINV T0 
						-- AR INVOICE ROWS
						INNER JOIN INV1 T1 ON T0.DOCNUM = T1.DocEntry
						INNER JOIN OSLP T2 ON T2.SLPCODE = T0.SLPCODE
						LEFT JOIN OITM T3 ON T1.ITEMCODE = T3.ITEMCODE
						WHERE T0.TaxDate BETWEEN @PeriodFrom AND @PeriodTo
						AND T1.Dscription LIKE '%PLYWOOD%'
						AND T0.CANCELED = 'N'

						UNION ALL

						SELECT 
							
							'CM',
							T0.DOCNUM AS Entry#
							,t0.DocDate
							,T0.TaxDate as InvDate
							,T1.Quantity * -1 as Quantity
							,t0.NumAtCard as RefNum
							,t0.U_DocSeries
							,T3.ItemName as ItemDescription
							,t1.WhsCode
							,t1.VatGroup
							,t1.ocrcode as 'Store Performance'
							--,T1.Price as SellingPrice
							,T1.PriceAfVAT * -1 as SellingPrice
							,T2.SLPNAME as Salesman
							,T0.CardName as Customername

							, CASE WHEN T0.U_SO_Cash = 'Y' THEN 'CASH'
							WHEN T0.U_SO_OT = 'Y' THEN 'Online Transfer'
							WHEN T0.U_SO_ODC = 'Y' THEN 'On Date Check'
							WHEN T0.U_SO_CC = 'Y' THEN 'Credit Card'
							WHEN T0.U_SO_COD = 'Y' THEN 'Cash On Delivery'
							WHEN T0.U_SO_DTC = 'Y' THEN 'Due to Customer'
							WHEN T0.U_SO_PDC = 'Y' THEN 'PDC'
							WHEN T0.U_SO_PO = 'Y' THEN 'PO'
							WHEN T0.U_SO_CM = 'Y' THEN 'CM'
							WHEN T0.U_SO_DC = 'Y' THEN 'Debit Card'
							ELSE 'BO'
							END as Type
							
							--,(T1.PriceAfVAT / (1 + (SELECT rate/100 FROM VTG1 Ta where T1.VATGROUP = Ta.CODE))) * T1.Quantity as TotalSales
							,(T1.PriceAfVAT * T1.Quantity) * -1 as TotalSales
													
						-- AR INVOICE HEADER
						FROM ORIN T0 
						-- AR INVOICE ROWS
						INNER JOIN RIN1 T1 ON T0.DOCNUM = T1.DocEntry
						INNER JOIN OSLP T2 ON T2.SLPCODE = T0.SLPCODE
						LEFT JOIN OITM T3 ON T1.ITEMCODE = T3.ITEMCODE
						WHERE T0.TaxDate BETWEEN @PeriodFrom AND @PeriodTo
						AND T1.Dscription LIKE '%PLYWOOD%'
						AND T0.CANCELED = 'N'

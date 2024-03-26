															
															
															
															
															
															
															
															
															
															
															
															
															
															
															
															
															
															
															
															
															
															
															--GENERATE BUSINESS PARTNERS / SHOW TAX CODE OF CUSTOMER 

															SELECT 
																T0.CARDCODE AS CustomerCode,
																T0.CardName AS CustomerName,

																CASE 
																	WHEN T0.VatStatus = 'Y' THEN
																		'Liable'
																	ELSE
																		'Exempt'
																END AS TaxStatus,

																T0.ECVatGroup AS TaxGroup,
																T1.Name as TaxGroupName,
																T0.WTLiable as SubjectToWTax,
																t0.WTCode as DefaultWTaxCode,
																T2.WTCode as AllowedWTCodes
															FROM OCRD T0
															LEFT JOIN OVTG T1 ON T0.ECVatGroup = T1.Code
															INNER JOIN CRD4 T2 ON T0.CARDCODE = T2.CardCode
															WHERE T0.CARDTYPE = 'C'

															ORDER BY T0.CARDCODE ASC 

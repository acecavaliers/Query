SELECT 
	T1.PeriodCat,
	T0.CapDate,
	T0.ItemCode,
	T0.ItemName,
	T1.DprType,
	T0.AssetGroup,
	T1.DprArea,
	T1.DprStart,
	T1.DprEnd,
	T1.UsefulLife,
	T1.RemainLife
FROM OITM T0 
LEFT JOIN ITM7 T1 ON T0.ItemCode = T1.ItemCode
WHERE T0.ITEMCODE LIKE 'FA%'
AND T0.VirtAstItm <> 'Y'


SELECT 
--'Cash Invoice' as InvType,CONVERT(VARCHAR(20),MIN(CONVERT(int,STUFF( STUFF( T0.NumAtCard, 1, CHARINDEX('-', T0.NumAtCard), ''), 1, CHARINDEX('-',STUFF( T0.NumAtCard, 1, CHARINDEX('-', T0.NumAtCard), '')), ''))))  + ' - ' +
 --CONVERT(VARCHAR(20),MAX(CONVERT(int,STUFF( STUFF( T0.NumAtCard, 1, CHARINDEX('-', T0.NumAtCard), ''), 1, CHARINDEX('-',STUFF( T0.NumAtCard, 1, CHARINDEX('-', T0.NumAtCard), '')), '')))) AS SeriesNum,
T0.DOCNUM,
T0.NUMATCARD,
T0.DOCDATE,
T0.CARDCODE,
T0.CARDNAME,
T0.U_DOCSERIES,
CASE WHEN T1.U_VATType = 'Vatable' THEN T0.Max1099  - (T0.VatSum + T0.DpmVat)  ELSE 0 END AS Vatable,
CASE WHEN T1.U_VATType = 'Zero Rated' THEN T0.Max1099  ELSE 0 END AS ZeroRated,
CASE WHEN T1.U_VATType = 'VAT Exempt' THEN T0.Max1099  ELSE 0 END AS VATExempt,
T0.VatSum +  T0.DpmVat AS VAT
FROM OINV T0 INNER JOIN OCRD T1
ON T0.CardCode=T1.CardCode
WHERE YEAR(T0.DocDate)=2020 AND MONTH(T0.DocDate)=6
AND DAY(T0.DocDate)=29 AND T0.OwnerCode=3  AND U_DocSeries LIKE '%CASH%' AND  T0.Canceled='N' AND T0.DocType='I'  AND  T0.NumAtCard LIKE '%[0-9]%'
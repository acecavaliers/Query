

SELECT  
T0.DocNum as 'Document Number',
T0.[DocDate] as 'Posting Date',
T0.TAXDATE AS 'Document Date',
T0.CARDNAME AS Name,
T0.[NumAtCard] AS 'Customer Ref. No.',
T0.DOCTOTAL AS 'Amount',
	(SELECT 'No. ' + T1.value FROM (
		SELECT value,ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS number  
		FROM STRING_SPLIT(T0.[U_DocSeries], '-') AS T1
		WHERE RTRIM(value) <> ''
	) T1 where T1.number = 3) AS Series,
	T0.U_DOCSERIES,
	CASE WHEN T0.CANCELED = 'C' THEN 'CANCELLED' ELSE
	'SALES '+(
	SELECT T1.value FROM (
		SELECT value,ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS number  
		FROM STRING_SPLIT(T0.[U_DocSeries], '-') AS T1
		WHERE RTRIM(value) <> ''
	) T1 where T1.number = 2)+' INVOICE' END AS TenderType
	FROM OINV T0  
	INNER JOIN OCRD T1 ON T0.[CardCode] = T1.[CardCode] 
	INNER JOIN OHEM T4 ON T0.[OwnerCode] = T4.[empID]
WHERE T0.DOCDATE = '01/21/2020'


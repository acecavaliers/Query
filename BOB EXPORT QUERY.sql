
DECLARE @CheckNumber as integer = 1623

SELECT * FROM(
SELECT CONCAT(	'H',	'|',	1,	'|', 
(SELECT 
	CAST(TA.CHECKSUM AS MONEY) 
FROM	OCHO TA 
WHERE	TA.CheckKey = @CheckNumber)) AS Header,

CONCAT(	'D', '|',
(SELECT TA.TransRef FROM OCHO TA WHERE TA.CheckKey = @CheckNumber),'|',
(SELECT CAST(TA.CHECKSUM AS MONEY) FROM OCHO TA WHERE TA.CheckKey = @CheckNumber),'|',
(SELECT ta.AcctNum FROM OCHO TA WHERE TA.CheckKey = @CheckNumber),'|',
(SELECT Convert(varchar, TA.CheckDate, 101) FROM OCHO TA WHERE TA.CheckKey = @CheckNumber),'|',
(SELECT ta.VendorName FROM OCHO TA WHERE TA.CheckKey = @CheckNumber),'||0|',
(SELECT TB.COMMENTS FROM OVPM TB WHERE TB.DOCNUM = (SELECT TA.TransRef FROM OCHO TA WHERE TA.CheckKey = @CheckNumber)), '|||||||||||||',
(SELECT Convert(varchar, TA.PmntDate, 101) FROM OCHO TA WHERE TA.CheckKey = @CheckNumber),'|',
CASE WHEN
	(SELECT COUNT(T1.AcctName) FROM JDT1 T0 
	LEFT JOIN OACT T1 ON T0.Account = T1.AcctCode
	WHERE T0.TransType = 46 
	AND T0.Debit > 0  
	AND T0.BaseRef = (SELECT TA.TransRef FROM OCHO TA WHERE TA.CheckKey = @CheckNumber)) > 1 THEN 
		(SELECT DISTINCT
		left(T1.AcctName, charindex('-', T1.AcctName, charindex('-', T1.AcctName)+1)-1)
		FROM JDT1 T0 
		LEFT JOIN OACT T1 ON T0.Account = T1.AcctCode
		WHERE T0.TransType = 46 
		AND T0.Debit > 0  
		AND T0.BaseRef = (SELECT TA.TransRef FROM OCHO TA WHERE TA.CheckKey = @CheckNumber)) 
ELSE 
		(SELECT 
		T1.AcctName
		FROM JDT1 T0 
		LEFT JOIN OACT T1 ON T0.Account = T1.AcctCode
		WHERE T0.TransType = 46 
		AND T0.Debit > 0 
		AND T0.BaseRef = (SELECT TA.TransRef FROM OCHO TA WHERE TA.CheckKey = @CheckNumber)) END
 ,'|',
 (SELECT CAST(TA.CHECKSUM AS MONEY) FROM OCHO TA WHERE TA.CheckKey = @CheckNumber),'|',
 (SELECT T1.AcctName
 FROM JDT1 T0 
 LEFT JOIN OACT T1 ON T0.Account = T1.AcctCode
 WHERE T0.TransType = 46 AND T0.Credit > 0  AND T0.BaseRef = (SELECT TA.TransRef FROM OCHO TA WHERE TA.CheckKey = @CheckNumber)),'|',
 (SELECT CAST(TA.CHECKSUM AS MONEY) FROM OCHO TA WHERE TA.CheckKey = @CheckNumber)) AS Details,

CONCAT('I','|',(SELECT TA.TransRef FROM OCHO TA WHERE TA.CheckKey = @CheckNumber), '|','Jerold S. King' , '|:|' , 
(SELECT CAST(isnull(sum(WTAmnt),0) as money) FROM pch5 taa
inner join VPM2 tbb on taa.AbsEntry = tbb.DocEntry where tbb.docnum = (SELECT TA.TransRef FROM OCHO TA WHERE TA.CheckKey = @CheckNumber)
) +
(SELECT CAST(isnull(sum(WTAmnt),0) as money) FROM dpo5 taa
inner join VPM2 tbb on taa.AbsEntry = tbb.DocEntry where tbb.docnum = (SELECT TA.TransRef FROM OCHO TA WHERE TA.CheckKey = @CheckNumber))
, '|:|:'
 ) AS Footer

)AS BOB



--SELECT T0.Line_ID, T0.Account, T1.ACCTNAME, T0.Debit, T0.Credit FROM JDT1 T0
--LEFT JOIN OACT T1 ON T0.Account = T1.AcctCode
--WHERE T0.TRANSID = 114652

--OUTGOING PAYMENT = 1933 ---
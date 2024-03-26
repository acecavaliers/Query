
SELECT 
	T0.Levels AS 'Level'
	,T0.AcctCode as 'G/L Account'
	,T0.AcctName as 'Account Name'
FROM OACT T0
ORDER BY T0.[GroupMask], T0.[GrpLine]







	SELECT 
		T0.CARDCODE AS 'BP CODE',
		T0.CARDNAME AS 'BP NAME',
		T0.CREDITLINE AS 'CREDIT LIMIT',
		(SELECT 
			ISNULL(SUM(T1.DOCTOTAL - T1.PAIDTODATE) , 0 ) 
		FROM OINV T1 
		WHERE T1.CARDCODE = T0.CARDCODE
		AND T1.DOCDUEDATE + 15 > getdate()
		AND T1.DOCTOTAL - T1.PAIDTODATE > 0
		AND T1.CANCELED = 'N') 
		AS 'Current Balance',
		(SELECT 
			ISNULL(SUM(T1.DOCTOTAL - T1.PAIDTODATE) , 0 ) 
		FROM OINV T1 
		WHERE T1.CARDCODE = T0.CARDCODE
		AND T1.DOCDUEDATE + 15 < getdate()
		AND T1.DOCTOTAL - T1.PAIDTODATE > 0
		AND T1.CANCELED = 'N') 
		AS 'Overdue Balance',

(SELECT ISNULL(SUM(T1.DOCTOTAL - T1.PAIDTODATE) , 0 ) 
FROM OINV T1 
WHERE T1.CARDCODE = T0.CARDCODE
AND T1.DOCDUEDATE + 15 < getdate()
AND T1.DOCTOTAL - T1.PAIDTODATE > 0
AND T1.CANCELED = 'N'
--AND DATEDIFF(DAY, t1.DocDueDate, GETDATE()) < 30) 
AND 
		datediff(DW, t1.DocDueDate, GETDATE()) - (datediff(WK, t1.DocDueDate, GETDATE())) -
       case when datepart(dw, t1.DocDueDate) = 1 then 1 else 0 end +
      case when datepart(dw, t1.DocDueDate) = 1 then 1 else 0 end <= 30 ) 
AS 'Overdue Balance - Less than/Equal to 30 days',

(SELECT ISNULL(SUM(T1.DOCTOTAL - T1.PAIDTODATE) , 0 ) 
FROM OINV T1 
WHERE T1.CARDCODE = T0.CARDCODE
AND T1.DOCDUEDATE + 15 < getdate()
AND T1.DOCTOTAL - T1.PAIDTODATE > 0
AND T1.CANCELED = 'N'
--AND DATEDIFF(DAY, t1.DocDueDate, GETDATE()) > 30)
AND 
		datediff(DW, t1.DocDueDate, GETDATE()) - (datediff(WK, t1.DocDueDate, GETDATE())) -
       case when datepart(dw, t1.DocDueDate) = 1 then 1 else 0 end +
      case when datepart(dw, t1.DocDueDate) = 1 then 1 else 0 end > 30 ) 
AS 'Overdue Balance - Greater than 30 days',

(SELECT ISNULL(SUM(T1.CheckSum) , 0 )
FROM OCHH T1
WHERE T1.CARDCODE = T0.CARDCODE AND T1.DEPOSITED = 'N' AND T1.CANCELED = 'N') 
AS 'Undeposited Checks',

T0.U_ALLOWPDC,
T0.U_ALLOWPO
FROM OCRD T0

WHERE 

T0.CardType = 'C'

--select t0.DocNum, t0.DocDate, t0.DocDueDate, t0.DocTotal, t0.PaidToDate, DATEDIFF(dw, t0.DocDueDate, GETDATE()), DATEDIFF(wk, t0.DocDueDate, GETDATE()),
--		datediff(DW, t0.DocDueDate, GETDATE()) - (datediff(WK, t0.DocDueDate, GETDATE())) -
--       case when datepart(dw, t0.DocDueDate) = 1 then 1 else 0 end +
--      case when datepart(dw, t0.DocDueDate) = 1 then 1 else 0 end
--from oinv t0
--where t0.CardCode = 'C000125'
--DATEDIFF(ww,DocDueDate, GetDate()),

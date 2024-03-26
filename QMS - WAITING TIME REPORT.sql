
--Average Waiting Time before Ordertaking----------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT 
AVG(DATEDIFF(SECOND,T0.TicketDate, T2.TimeStarted)) 
,CONCAT(	
		CASE WHEN CONVERT(VARCHAR(12),  AVG(DATEDIFF(SECOND,T0.TicketDate, T2.TimeStarted)) /60/60 % 24) > 0 THEN 
		CONVERT(VARCHAR(12),  AVG(DATEDIFF(SECOND,T0.TicketDate, T2.TimeStarted)) /60/60 % 24) + ' Hour(s), ' ELSE '' END , 
		CASE WHEN CONVERT(VARCHAR(2),   AVG(DATEDIFF(SECOND,T0.TicketDate, T2.TimeStarted)) /60 % 60) > 0 THEN
		CONVERT(VARCHAR(2),   AVG(DATEDIFF(SECOND,T0.TicketDate, T2.TimeStarted)) /60 % 60)    + ' Minute(s), ' ELSE '' END,
		CASE WHEN CONVERT(VARCHAR(2),   AVG(DATEDIFF(SECOND,T0.TicketDate, T2.TimeStarted)) % 60) > 0 THEN
		CONVERT(VARCHAR(2),  AVG(DATEDIFF(SECOND,T0.TicketDate, T2.TimeStarted)) % 60)        + ' Second(s).' ELSE '' END		
) AS 'AverageWaitingTimeForOrdertaking',
(SELECT TOP 1 
CONCAT(	
		CASE WHEN CONVERT(VARCHAR(12),  DATEDIFF(SECOND,TA.TicketDate, TB.TimeStarted) /60/60 % 24) > 0 THEN 
		CONVERT(VARCHAR(12),  DATEDIFF(SECOND,TA.TicketDate, TB.TimeStarted) /60/60 % 24) + ' Hour(s), ' ELSE '' END , 
		CASE WHEN CONVERT(VARCHAR(2),   DATEDIFF(SECOND,TA.TicketDate, TB.TimeStarted) /60 % 60) > 0 THEN
		CONVERT(VARCHAR(2),   DATEDIFF(SECOND,TA.TicketDate, TB.TimeStarted) /60 % 60)    + ' Minute(s), ' ELSE '' END,
		CASE WHEN CONVERT(VARCHAR(2),   DATEDIFF(SECOND,TA.TicketDate, TB.TimeStarted) % 60) > 0 THEN
		CONVERT(VARCHAR(2),  DATEDIFF(SECOND,TA.TicketDate, TB.TimeStarted) % 60)        + ' Second(s).' ELSE '' END) 
FROM tbl_Ticket TA 
LEFT JOIN tbl_OrderingTime TB ON TA.ID = TB.TicketID
ORDER BY DATEDIFF(SECOND,TA.TicketDate, TB.TimeStarted) DESC ) AS LongestWaitingTime,

(SELECT TOP 1 
CONCAT(	
		CASE WHEN CONVERT(VARCHAR(12),  DATEDIFF(SECOND,TA.TicketDate, TB.TimeStarted) /60/60 % 24) > 0 THEN 
		CONVERT(VARCHAR(12),  DATEDIFF(SECOND,TA.TicketDate, TB.TimeStarted) /60/60 % 24) + ' Hour(s), ' ELSE '' END , 
		CASE WHEN CONVERT(VARCHAR(2),   DATEDIFF(SECOND,TA.TicketDate, TB.TimeStarted) /60 % 60) > 0 THEN
		CONVERT(VARCHAR(2),   DATEDIFF(SECOND,TA.TicketDate, TB.TimeStarted) /60 % 60)    + ' Minute(s), ' ELSE '' END,
		CASE WHEN CONVERT(VARCHAR(2),   DATEDIFF(SECOND,TA.TicketDate, TB.TimeStarted) % 60) > 0 THEN
		CONVERT(VARCHAR(2),  DATEDIFF(SECOND,TA.TicketDate, TB.TimeStarted) % 60)        + ' Second(s).' ELSE '' END) 
FROM tbl_Ticket TA 
LEFT JOIN tbl_OrderingTime TB ON TA.ID = TB.TicketID
where 
CONCAT(	
		CASE WHEN CONVERT(VARCHAR(12),  DATEDIFF(SECOND,TA.TicketDate, TB.TimeStarted) /60/60 % 24) > 0 THEN 
		CONVERT(VARCHAR(12),  DATEDIFF(SECOND,TA.TicketDate, TB.TimeStarted) /60/60 % 24) + ' Hour(s), ' ELSE '' END , 
		CASE WHEN CONVERT(VARCHAR(2),   DATEDIFF(SECOND,TA.TicketDate, TB.TimeStarted) /60 % 60) > 0 THEN
		CONVERT(VARCHAR(2),   DATEDIFF(SECOND,TA.TicketDate, TB.TimeStarted) /60 % 60)    + ' Minute(s), ' ELSE '' END,
		CASE WHEN CONVERT(VARCHAR(2),   DATEDIFF(SECOND,TA.TicketDate, TB.TimeStarted) % 60) > 0 THEN
		CONVERT(VARCHAR(2),  DATEDIFF(SECOND,TA.TicketDate, TB.TimeStarted) % 60)        + ' Second(s).' ELSE '' END)  <> ''
ORDER BY DATEDIFF(SECOND,TA.TicketDate, TB.TimeStarted) ASC ) AS ShortestWaitingTime


FROM tbl_Ticket T0
LEFT JOIN tbl_StatusType T1 ON T0.Status = T1.id
left JOIN tbl_OrderingTime t2 on t0.ID = t2.TicketID
WHERE T0.TransType <> 3
AND T2.TimeStarted IS NOT NULL 
--Average Waiting Time before Ordertaking (PerMonth)---------------------------------------------------------------------------------------------------------------------------------------------------
SELECT 
CONCAT(DATENAME(MONTH, convert(date,T0.TicketDate)), ', ',  DATENAME(YEAR, convert(date,T0.TicketDate))) AS 'Month&Year'
,AVG(DATEDIFF(SECOND,T0.TicketDate, T2.TimeStarted))
,CONCAT(	
		CASE WHEN CONVERT(VARCHAR(12),  AVG(DATEDIFF(SECOND,T0.TicketDate, T2.TimeStarted)) /60/60 % 24) > 0 THEN 
		CONVERT(VARCHAR(12),  AVG(DATEDIFF(SECOND,T0.TicketDate, T2.TimeStarted)) /60/60 % 24) + ' Hour(s), ' ELSE '' END , 
		CASE WHEN CONVERT(VARCHAR(2),   AVG(DATEDIFF(SECOND,T0.TicketDate, T2.TimeStarted)) /60 % 60) > 0 THEN
		CONVERT(VARCHAR(2),   AVG(DATEDIFF(SECOND,T0.TicketDate, T2.TimeStarted)) /60 % 60)    + ' Minute(s), ' ELSE '' END,
		CASE WHEN CONVERT(VARCHAR(2),   AVG(DATEDIFF(SECOND,T0.TicketDate, T2.TimeStarted)) % 60) > 0 THEN
		CONVERT(VARCHAR(2),  AVG(DATEDIFF(SECOND,T0.TicketDate, T2.TimeStarted)) % 60)        + ' Second(s).' ELSE '' END		
) AS 'AverageWaitingTimeForOrdertaking',
(SELECT TOP 1 
CONCAT(	
		CASE WHEN CONVERT(VARCHAR(12),  DATEDIFF(SECOND,TA.TicketDate, TB.TimeStarted) /60/60 % 24) > 0 THEN 
		CONVERT(VARCHAR(12),  DATEDIFF(SECOND,TA.TicketDate, TB.TimeStarted) /60/60 % 24) + ' Hour(s), ' ELSE '' END , 
		CASE WHEN CONVERT(VARCHAR(2),   DATEDIFF(SECOND,TA.TicketDate, TB.TimeStarted) /60 % 60) > 0 THEN
		CONVERT(VARCHAR(2),   DATEDIFF(SECOND,TA.TicketDate, TB.TimeStarted) /60 % 60)    + ' Minute(s), ' ELSE '' END,
		CASE WHEN CONVERT(VARCHAR(2),   DATEDIFF(SECOND,TA.TicketDate, TB.TimeStarted) % 60) > 0 THEN
		CONVERT(VARCHAR(2),  DATEDIFF(SECOND,TA.TicketDate, TB.TimeStarted) % 60)        + ' Second(s).' ELSE '' END) 
FROM tbl_Ticket TA 
LEFT JOIN tbl_OrderingTime TB ON TA.ID = TB.TicketID
WHERE CONCAT(DATENAME(MONTH, convert(date,T0.TicketDate)), ', ',  DATENAME(YEAR, convert(date,T0.TicketDate))) =
CONCAT(DATENAME(MONTH, convert(date,TA.TicketDate)), ', ',  DATENAME(YEAR, convert(date,TA.TicketDate)))
ORDER BY DATEDIFF(SECOND,TA.TicketDate, TB.TimeStarted) DESC
 ) AS LongestWaitingTime

FROM tbl_Ticket T0
LEFT JOIN tbl_StatusType T1 ON T0.Status = T1.id
left JOIN tbl_OrderingTime t2 on t0.ID = t2.TicketID
WHERE T0.TransType <> 3 AND T2.TimeStarted IS NOT NULL
GROUP BY CONCAT(DATENAME(MONTH, convert(date,T0.TicketDate)), ', ',  DATENAME(YEAR, convert(date,T0.TicketDate)))


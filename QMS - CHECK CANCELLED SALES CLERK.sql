



select
t2.id,
T2.CancelCode,
T0.Remarks,
T4.number,
T5.Name, 
t1.TicketNum
FROM tbl_Cancelation T0
LEFT JOIN TBL_TICKET T1 ON T0.TicketID = T1.ID
LEFT JOIN tbl_CancelCode T2 ON T0.Reason = T2.id
LEFT JOIN tbl_OrderingTime T3 ON T0.TicketID = T3.TicketID
LEFT JOIN tbl_Counters T4 ON T4.ID = T3.CounterNumber
LEFT JOIN tbl_User T5 ON T3.OrderTaker = T5.ID
WHERE CONVERT(DATE, GETDATE()) = CONVERT(DATE, T1.TicketDate)
order by t0.ID


SELECT 
 CONVERT(DATE, T0.TicketDate),
 T0.ID AS TicketInternalID,
 T0.TicketNum,
 T0.Status,
 T4.StatType,
 T2.ModeofReleasing,
 T1.WiontaEntry,
 T3.ReleaseType

 FROM tbl_Ticket T0
LEFT JOIN tbl_Releasing T1 ON T0.ID = T1.TicketInternalID
LEFT JOIN tbl_ModeofReleasing T2 ON T1.ModeofReleasing = T2.id
LEFT JOIN tbl_ReleasingType T3 ON T1.ReleaseType = T3.id
LEFT JOIN tbl_StatusType T4 ON T0.Status = T4.ID	
WHERE MONTH(T0.TicketDate) = 9
AND T0.Status <> 9 AND T0.Status <> 10 AND T0.Status <> 12
and t3.id = 1


SELECT 
CONVERT(DATE,T0.BookingTime),
T0.BookingID,
T3.StatType,
T1.WiontaEntry,
T2.ReleaseType
FROM tbl_Booking T0
LEFT JOIN tbl_BookingReleasing T1 ON T0.ID = T1.BookingID
LEFT JOIN tbl_ReleasingType T2 ON T1.releasetype = T2.id
LEFT JOIN tbl_StatusType T3 ON T0.Status = T3.id
WHERE T2.id = 1 and MONTH(T0.BookingTime) = 9
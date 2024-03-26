


SELECT 

T1.TicketDate,
T1.TicketNum,
T2.CancelCode,
T0.Remarks
FROM tbl_Cancelation T0
LEFT JOIN TBL_TICKET T1 ON T0.TicketID = T1.ID
LEFT JOIN tbl_CancelCode T2 ON T0.Reason = T2.id
WHERE CONVERT(DATE, GETDATE()) = CONVERT(DATE, T1.TicketDate)
AND REMARKS <> ''
ORDER BY T0.ID ASC

SELECT COUNT(*) as CancelCount, T2.CancelCode
FROM tbl_Cancelation T0
LEFT JOIN TBL_TICKET T1 ON T0.TicketID = T1.ID
LEFT JOIN tbl_CancelCode T2 ON T0.Reason = T2.id
WHERE CONVERT(DATE, GETDATE()) = CONVERT(DATE, T1.TicketDate)
GROUP BY T2.CancelCode
--AND REMARKS <> ''


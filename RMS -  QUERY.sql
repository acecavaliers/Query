SELECT T0.BATCHNUMBER, T0.TransactionNumber, T1.Total, T2.Company, t1.ReferenceNumber, T1.Comment
FROM TenderEntry T0
LEFT JOIN [dbo].[Transaction] T1 ON T0.TransactionNumber = T1.TransactionNumber
LEFT JOIN [dbo].[Customer] T2 ON T1.CUSTOMERID = T2.ID
Where T0.Amount = 112800
AND T0.Description LIKE '%CASH%'

SELECT T0.LogInstanc, T0.DocNum, T0.UpdateDate, T1.U_NAME, T0.CreateDate
FROM ADOC T0
INNER JOIN OUSR T1 ON T0.userSign2 = T1.USERID
WHERE T0.OBJTYPE = 17 AND T0.DocEntry = 1
-------------------------------------------------------------------------------------------------
SELECT T0.[DocNum], T1.[ItemCode], T2.[U_NAME] FROM ORDR T0 INNER JOIN RDR1 T1 ON T0.DocEntry = T1.DocEntry INNER JOIN OUSR T2 ON T0.UserSign = T2.USERID WHERE T0.[DocDate] = CONVERT(VARCHAR(10),GETDATE(),110)

union all

SELECT T0.[DocNum], T1.[ItemCode], T2.[U_NAME] FROM OPOR T0 INNER JOIN POR1 T1 ON T0.DocEntry = T1.DocEntry INNER JOIN OUSR T2 ON T0.UserSign = T2.USERID WHERE T0.[DocDate] = CONVERT(VARCHAR(10),GETDATE(),110)
-------------------------------------------------------------------------------------------------
SELECT 
T0.[UpdateDate],
T0.[ItemCode],
 T2.[ItemName] as Newvalue, 
 T1.[ItemName]as oldvalue, 
 t3.[U_Name] as CreatedUser, 
 t4.[U_Name] 
 FROM AITM T0 
 left join AITM T1 on t1.itemcode = t0.itemcode and t1.loginstanc= t0.loginstanc-1 
 left join OITM T2 on t2.itemcode = t0.itemcode 
 left join OUSR t3 on t3.userid = t2.usersign 
 left join OUSR t4 on t4.userid =t2.usersign2 
 WHERE T2.[ItemName] <> T1.[ItemName] 
 group by T0.[UpdateDate],T0.[ItemCode], T2.[ItemName], T1.[ItemName],t3.[U_Name],t4.[U_Name] order by T0.[UpdateDate]
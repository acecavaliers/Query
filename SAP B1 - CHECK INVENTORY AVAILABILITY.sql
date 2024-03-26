SELECT U_DOCSERIES, DOCNUM FROM ordr
WHERE U_DOCSERIES LIKE '%GSCST1GS%'





DECLARE @ItemCode as varchar(30) = '0006146CLCMT'
SELECT T0.ItemCode, T0.ItemName,
T1.WhsCode, T2.WhsName, T1.OnHand, T1.IsCommited, (T1.OnHand+t1.OnOrder) - T1.IsCommited AS Available , T1.AvgPrice
FROM OITM T0 
LEFT JOIN OITW T1 ON T0.ITEMCODE = T1.ItemCode
LEFT JOIN OWHS T2 ON T1.WhsCode = T2.WhsCode
WHERE T0.ItemCode NOT LIKE 'FA%'

AND T0.ItemCode =  @ItemCode

SELECT DOCNUM, U_DOCSERIES FROM OWTR
WHERE U_DOCSERIES IS NOT NULL


SELECT * FROM OWHS 

select usersign, * from oprr where docnum = 22

select * from ohem 
--QUERY TO GET SERIAL NO.
DECLARE @DocNum as Integer = 74
DECLARE @DocType as Integer = 21

SELECT T0.ItemCode, T0.ItemName, T0.SysSerial, T0.IntrSerial, T1.BaseNum, T1.BaseLinNum
FROM OSRI T0
LEFT JOIN SRI1 T1 ON T0.ItemCode = T1.ItemCode AND T0.SysSerial = T1.SysSerial
WHERE T1.BaseType = @DocType AND T1.BaseNum = @DocNum
	
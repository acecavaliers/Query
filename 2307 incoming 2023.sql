
-- DECLARE @QTR INT= 1,@GRP INT =0, @ATC varchar= '' , @WTCOMCODE varchar(50)='C00009820230203-1'
DECLARE @QTR INT= {?quarter} ,@GRP INT ={?Group}, @ATC varchar(9)= '{?ATC}' , @WTCOMCODE varchar(50)='{?WTCOMCODE}'

SELECT *
from(
--ARINV   
SELECT 
ISNULL(T0.U_wTaxComCode,T3.U_wTaxComCode) AS 'U_wTaxComCode',T3.DOCNUM,'01' as WTaxDayFrom,
T0.U_WTax,T0.TaxDate, T0.DocTotal, 
-- (Select CompnyName from OADM) AS 'Payor',
'SAFETYBULD INC.'+ (select top 1 ' / '+ TaxOffice from OWHS where replace(Address3,'_','')= LEFT(T0.U_DocSeries,6) ) AS 'Payor',
CASE 
    WHEN T0.DOCTYPE = 'I' THEN (SELECT TOP 1 WhsCode FROM INV1 WHERE DOCENTRY=T0.DocNum )
    WHEN T0.DOCTYPE = 'S' THEN (SELECT TOP 1 ocrcode FROM INV1 WHERE DOCENTRY=T0.DocNum )
END AS 'ocrcode',

CASE
    WHEN  month(t0.taxdate) IN (1,2,3) THEN '01'
    WHEN  month(t0.taxdate) IN (4,5,6) THEN '04'
    WHEN  month(t0.taxdate) IN (7,8,9) THEN '07'
    WHEN  month(t0.taxdate) IN (10,11,12) THEN '10'
    ELSE 'N/A' END AS WtaxMonthFrom,
CONVERT(varchar(10), year(T0.taxdate))  as 'WtaxYearFrom',
CASE
    WHEN  month(t0.taxdate) IN (1,2,3) THEN '03'
    WHEN  month(t0.taxdate) IN (4,5,6) THEN '06'
    WHEN   month(t0.taxdate) IN (7,8,9) THEN '09'
    WHEN  month(t0.taxdate) IN (10,11,12) THEN '12'
    ELSE 'N/A'  END AS WtaxMonthTo,
CONVERT(varchar(10), DAY(EOMONTH(
CASE
    WHEN  month(t0.taxdate) IN (1,2,3) THEN '2020-03-20 00:00:00.000'
    WHEN  month(t0.taxdate) IN (4,5,6) THEN '2020-06-20 00:00:00.000'
    WHEN  month(t0.taxdate) IN (7,8,9) THEN '2020-09-20 00:00:00.000'
    WHEN  month(t0.taxdate) IN (10,11,12) THEN '2020-12-20 00:00:00.000'
    ELSE 'N/A' END))) as WTaxDayTo,

CONVERT(varchar(10), year(t0.taxdate))  as 'WtaxYearTo',

CASE     
    WHEN T0.U_ALIAS_VENDOR IS NULL 
    THEN (SELECT IIF(A.CntctPrsn IS NULL,A.CardName,CONCAT(B.FirstName, ' ',B.LastName))AS 'CNAME' FROM OCRD A LEFT JOIN OCPR B ON A.CardCode=B.CardCode AND B.Name=A.CntctPrsn
          WHERE A.CardCode= T0.CardCode)
    ELSE T0.U_ALIAS_VENDOR
END AS 'Payee',
CASE 
    WHEN T0.U_TIN IS NOT NULL THEN LEFT(T0.U_TIN,3)
    ELSE (SELECT LEFT(LicTradNum, 3) FROM OCRD TT WHERE TT.CardCode = T0.CardCode) 
END As 'P1stTIN',
CASE 
    WHEN T0.U_TIN IS NOT NULL THEN SUBSTRING(T0.U_TIN,5,3)
    ELSE (SELECT SUBSTRING(LicTradNum,5,3) FROM OCRD TT WHERE TT.CardCode = T0.CardCode)     
END As 'P2ndTIN',
CASE 
    WHEN T0.U_TIN IS NOT NULL THEN SUBSTRING(T0.U_TIN,9,3)
    ELSE (SELECT SUBSTRING(LicTradNum,9,3) FROM OCRD TT WHERE TT.CardCode = T0.CardCode) 
END As 'P3rdTIN',
CASE 
    WHEN T0.U_TIN IS NOT NULL THEN SUBSTRING(T0.U_TIN,13,3)
    ELSE (SELECT SUBSTRING(LicTradNum,13,3) FROM OCRD TT WHERE TT.CardCode = T0.CardCode) 
END As 'P4thTIN',  
CASE 
    WHEN T0.U_ADDRESS IS NOT NULL THEN T0.U_ADDRESS
    ELSE
    UPPER((SELECT DISTINCT CONCAT(CAST(Building AS varchar(max)),
    (CASE WHEN Building IS NULL THEN '' ELSE ' ' END),Street,(CASE WHEN Street IS NULL THEN '' ELSE ', ' END), StreetNo,(CASE WHEN StreetNo IS NULL THEN '' ELSE ', ' END),[Block],
    (CASE WHEN [Block] IS NULL THEN '' ELSE ', ' END),City,(CASE WHEN City IS NULL THEN '' ELSE ' ' END)) 
    FROM CRD1 WHERE CardCode = t0.CardCode AND AdresType = 'B')) 
END AS 'Payee Address',
CASE 
    WHEN T0.U_ZIPCODE IS NOT NULL THEN T0.U_ZIPCODE
    ELSE
    (SELECT DISTINCT ZipCode FROM CRD1 WHERE CardCode = T0.CardCode AND AdresType = 'B') 
END AS 'PayeeZipCode',

CASE 
    WHEN (SELECT COUNT(RATE) FROM INV5 WHERE AbsEntry=T3.DocEntry)>1 
    THEN (SELECT MAX(TaxbleAmnt) FROM INV5 WHERE AbsEntry=T3.DocEntry)
    ELSE ISNULL(TaxbleAmnt,T0.DocTotal-T0.VatSum)
END AS 'TaxbleAmnt',

CASE 
    WHEN (SELECT COUNT(RATE) FROM INV5 WHERE AbsEntry=T3.DocEntry)>1 
    THEN ((T3.SUMAPPLIED/T0.DOCTOTAL)*(SELECT MAX(TaxbleAmnt) FROM INV5 WHERE AbsEntry=T3.DocEntry)) *(T1.RATE/100)
    ELSE T3.U_WtaxPay
END  AS 'WTAmnt',


(Select top 1 SUBSTRING(FedTaxID,1,3) FROM OWHS where replace(Address3,'_','')= LEFT(T0.U_DocSeries,6))
  AS 'PY1stTIN',
  
(Select top 1 SUBSTRING(FedTaxID,5,3) FROM OWHS where replace(Address3,'_','')= LEFT(T0.U_DocSeries,6))
  AS 'PY2ndTIN',

(Select top 1 SUBSTRING(FedTaxID,9,3) FROM OWHS where replace(Address3,'_','')= LEFT(T0.U_DocSeries,6))
  AS 'PY3ndTIN',

(Select top 1 SUBSTRING(FedTaxID,13,5) FROM OWHS where replace(Address3,'_','')= LEFT(T0.U_DocSeries,6))
  AS 'PY4thTIN',

ISNULL ((select TOP 1 
UPPER( CONCAT(CAST(Building AS varchar(max)),iif(Building IS NULL ,'',', '),
Street,iif(Street IS NULL ,'',', '),StreetNo,iif(StreetNo IS NULL ,'',', '),
[Block],iif([Block] IS NULL ,'',', '), City,iif(City IS NULL ,'',' ')) )
from owhs where replace(Address3,'_','')= LEFT(T0.U_DocSeries,6) ), 
CASE WHEN
    CASE WHEN T0.DOCTYPE = 'I' THEN
    UPPER(
        (SELECT TOP 1 CONCAT(CAST(Building AS varchar(max)),iif(Building IS NULL ,'',', '),
        Street,iif(Street IS NULL ,'',', '),StreetNo,iif(StreetNo IS NULL ,'',', '),
        [Block],iif([Block] IS NULL ,'',', '), City,iif(City IS NULL ,'',' ')) 
        FROM owhs  WHERE WhsCode=(SELECT TOP 1 WhsCode FROM INV1 WHERE DocEntry=T0.DocNum) )) 
    WHEN T0.DOCTYPE = 'S' THEN
    UPPER(
        (SELECT TOP 1 CONCAT(CAST(Building AS varchar(max)),iif(Building IS NULL ,'',', '),
        Street,iif(Street IS NULL ,'',', '),StreetNo,iif(StreetNo IS NULL ,'',', '),
        [Block],iif([Block] IS NULL ,'',', '), City,iif(City IS NULL ,'',' ')) 
        FROM owhs  WHERE WhsCode=(SELECT TOP 1 OOCR.U_Whse FROM INV1 INNER JOIN OOCR ON INV1.OCRCODE = OOCR.OCRCODE WHERE DocEntry=T0.DocNum) )) 
    END IS NULL 
THEN
        (SELECT  CONCAT(iif(Building IS NULL,'' , CONCAT(Building, ', ')),iif(StreetNo IS NULL , '' , StreetNo +', '),iif([Block] IS NULL , '' , [Block] +', '),
        iif(City IS NULL , '' , City +', ' ),iif(County IS NULL , '' , County +' '))
        FROM  OWHS A0 
        inner join oudg  A1 on A0.WhsCode=A1.Warehouse
        inner join OUSR A2 on A1.Code=A2.DfltsGroup
        inner join ohem A3 on A2.USERID=A3.userId
        WHERE A3.code=T0.OwnerCode)
ELSE
    CASE WHEN T0.DOCTYPE = 'I' THEN
        UPPER((SELECT TOP 1 CONCAT(CAST(Building AS varchar(max)),iif(Building IS NULL ,'',', '),
        Street,iif(Street IS NULL ,'',', '),StreetNo,iif(StreetNo IS NULL ,'',', '),
        [Block],iif([Block] IS NULL ,'',', '), City,iif(City IS NULL ,'',' ')) 
        FROM owhs  WHERE WhsCode=(SELECT TOP 1 WhsCode FROM INV1 WHERE DocEntry=T0.DocNum) )) 
    WHEN T0.DOCTYPE = 'S' THEN
        UPPER((SELECT TOP 1 CONCAT(CAST(Building AS varchar(max)),iif(Building IS NULL ,'',', '),
        Street,iif(Street IS NULL ,'',', '),StreetNo,iif(StreetNo IS NULL ,'',', '),
        [Block],iif([Block] IS NULL ,'',', '), City,iif(City IS NULL ,'',' ')) 
        FROM owhs  WHERE WhsCode=(SELECT TOP 1 OOCR.U_Whse FROM INV1 INNER JOIN OOCR ON INV1.OCRCODE = OOCR.OCRCODE WHERE DocEntry=T0.DocNum) )) 
    END 
END)AS 'PayorAddress',

CASE WHEN 
    CASE WHEN T0.DOCTYPE = 'I' THEN  (SELECT TOP 1 ZipCode FROM owhs  WHERE WhsCode=(SELECT TOP 1 WhsCode FROM INV1 WHERE DocEntry=T0.DocNum))
    WHEN T0.DOCTYPE = 'S' THEN (SELECT TOP 1 ZipCode FROM owhs  WHERE WhsCode=(SELECT  TOP 1  OOCR.U_Whse FROM INV1 INNER JOIN OOCR ON INV1.OCRCODE = OOCR.OCRCODE WHERE DocEntry=T0.DocNum)) END IS NULL 
    THEN (SELECT  ZipCode
            FROM  OWHS A0 
            inner join oudg  A1 on A0.WhsCode=A1.Warehouse
            inner join OUSR A2 on A1.Code=A2.DfltsGroup
            inner join ohem A3 on A2.USERID  =A3.userId
            WHERE A3.code=T0.OwnerCode)
    ELSE
    CASE WHEN T0.DOCTYPE = 'I' THEN   (SELECT TOP 1 ZipCode FROM owhs  WHERE WhsCode=(SELECT TOP 1 WhsCode FROM INV1 WHERE DocEntry=T0.DocNum))
    WHEN T0.DOCTYPE = 'S' THEN  (SELECT TOP 1 ZipCode FROM owhs  WHERE WhsCode=(SELECT  TOP 1  OOCR.U_Whse FROM INV1 
                                 INNER JOIN OOCR ON INV1.OCRCODE = OOCR.OCRCODE WHERE DocEntry=T0.DocNum)) 
    END
END AS 'PayorZipCode',

CASE
    WHEN   month(t0.taxdate) IN (1,2,3) THEN '1'
    WHEN   month(t0.taxdate) IN (4,5,6) THEN '2'
    WHEN   month(t0.taxdate) IN (7,8,9) THEN '3'
    WHEN   month(t0.taxdate) IN (10,11,12) THEN '4'
    ELSE 'N/A'
END AS 'QTR',
t0.docentry as doc,
ISNULL((SELECT TI.U_ATC FROM OWHT TI
WHERE T1.AbsEntry=T0.DocNum AND TI.WTCode = T1.WTCode ),
ISNULL((SELECT A0.U_ATCCODE FROM JDT1 A0 INNER JOIN RCT2 A1 ON A0.TransId=A1.DocEntry 
    WHERE A1.DocNum=T3.DocNum  AND A0.U_ATCcode IS NOT NULL  AND A1.InvType=30  AND A1.U_wTaxComCode=ISNULL(T3.U_wTaxComCode,T0.U_wTaxComCode) 
),'')) AS 'ATC',

(SELECT COUNT(A0.DocNum) FROM OINV A0 
INNER JOIN RCT2 A1 ON A0.Docentry = A1.Docentry
WHERE A1.DocNum = T3.DocNum
AND A0.WTSum>0
AND
(CASE
WHEN month(A0.taxdate) IN (1,2,3) THEN '1'
WHEN month(A0.taxdate) IN (4,5,6) THEN '2'
WHEN month(A0.taxdate) IN (7,8,9) THEN '3'
WHEN month(A0.taxdate) IN (10,11,12) THEN '4'
ELSE 'N/A' END)=@QTR) AS 'ROWS'

FROM OINV T0 
LEFT JOIN INV5 T1 ON T1.AbsEntry=T0.DocNum
INNER JOIN RCT2 T3 ON T0.DOCNUM= T3.Docentry AND T3.InvType=13

WHERE 
ISNULL(T0.U_wTaxComCode,T3.U_wTaxComCode) =@WTCOMCODE
AND T0.CANCELED='N'

UNION ALL 
--ARDPI 


SELECT 
ISNULL(T0.U_wTaxComCode,T3.U_wTaxComCode)  AS 'U_wTaxComCode',T3.DOCNUM,'01' as WTaxDayFrom,
T0.U_WTax,T0.TaxDate, T0.DocTotal,
--  (Select CompnyName from OADM) AS 'Payor',
'SAFETYBULD INC.'+ (select top 1 ' / '+ TaxOffice from OWHS where replace(Address3,'_','')= LEFT(T0.U_DocSeries,6) ) AS 'Payor',
CASE 
    WHEN T0.DOCTYPE = 'I' THEN (SELECT TOP 1 WhsCode FROM INV1 WHERE DOCENTRY=T0.DocNum )
    WHEN T0.DOCTYPE = 'S' THEN (SELECT TOP 1 OCRCODE FROM INV1 WHERE DOCENTRY=T0.DocNum )
END AS 'ocrcode',

CASE
    WHEN  month(t0.taxdate) IN (1,2,3) THEN '01'
    WHEN  month(t0.taxdate) IN (4,5,6) THEN '04'
    WHEN  month(t0.taxdate) IN (7,8,9) THEN '07'
    WHEN  month(t0.taxdate) IN (10,11,12) THEN '10'
    ELSE 'N/A' END AS WtaxMonthFrom,
CONVERT(varchar(10), year(T0.taxdate))  as 'WtaxYearFrom',
CASE
    WHEN  month(t0.taxdate) IN (1,2,3) THEN '03'
    WHEN  month(t0.taxdate) IN (4,5,6) THEN '06'
    WHEN   month(t0.taxdate) IN (7,8,9) THEN '09'
    WHEN  month(t0.taxdate) IN (10,11,12) THEN '12'
    ELSE 'N/A'  END AS WtaxMonthTo,
CONVERT(varchar(10), DAY(EOMONTH(
CASE
    WHEN  month(t0.taxdate) IN (1,2,3) THEN '2020-03-20 00:00:00.000'
    WHEN  month(t0.taxdate) IN (4,5,6) THEN '2020-06-20 00:00:00.000'
    WHEN  month(t0.taxdate) IN (7,8,9) THEN '2020-09-20 00:00:00.000'
    WHEN  month(t0.taxdate) IN (10,11,12) THEN '2020-12-20 00:00:00.000'
    ELSE 'N/A' END))) as WTaxDayTo,

CONVERT(varchar(10), year(t0.taxdate))  as 'WtaxYearTo',

CASE 
    WHEN T0.U_ALIAS_VENDOR IS NULL 
    THEN (SELECT IIF(A.CntctPrsn IS NULL,A.CardName,CONCAT(B.FirstName, ' ',B.LastName))AS 'CNAME' FROM OCRD A LEFT JOIN OCPR B ON A.CardCode=B.CardCode AND B.Name=A.CntctPrsn
          WHERE A.CardCode= T0.CardCode)
    ELSE T0.U_ALIAS_VENDOR
END AS 'Payee',
CASE 
    WHEN T0.U_TIN IS NOT NULL THEN LEFT(T0.U_TIN,3)
    ELSE (SELECT LEFT(LicTradNum, 3) FROM OCRD TT WHERE TT.CardCode = T0.CardCode) 
END As 'P1stTIN',
CASE 
    WHEN T0.U_TIN IS NOT NULL THEN SUBSTRING(T0.U_TIN,5,3)
    ELSE (SELECT SUBSTRING(LicTradNum,5,3) FROM OCRD TT WHERE TT.CardCode = T0.CardCode)     
END As 'P2ndTIN',
CASE 
    WHEN T0.U_TIN IS NOT NULL THEN SUBSTRING(T0.U_TIN,9,3)
    ELSE (SELECT SUBSTRING(LicTradNum,9,3) FROM OCRD TT WHERE TT.CardCode = T0.CardCode) 
END As 'P3rdTIN',
CASE 
    WHEN T0.U_TIN IS NOT NULL THEN SUBSTRING(T0.U_TIN,13,3)
    ELSE (SELECT SUBSTRING(LicTradNum,13,3) FROM OCRD TT WHERE TT.CardCode = T0.CardCode) 
END As 'P4thTIN',  
CASE 
    WHEN T0.U_ADDRESS IS NOT NULL THEN T0.U_ADDRESS
    ELSE
    UPPER((SELECT DISTINCT CONCAT(CAST(Building AS varchar(max)),
    (CASE WHEN Building IS NULL THEN '' ELSE ' ' END),Street,(CASE WHEN Street IS NULL THEN '' ELSE ', ' END), StreetNo,(CASE WHEN StreetNo IS NULL THEN '' ELSE ', ' END),[Block],
    (CASE WHEN [Block] IS NULL THEN '' ELSE ', ' END),City,(CASE WHEN City IS NULL THEN '' ELSE ' ' END)) 
    FROM CRD1 WHERE CardCode = t0.CardCode AND AdresType = 'B')) 
END AS 'Payee Address',
CASE 
    WHEN T0.U_ZIPCODE IS NOT NULL THEN T0.U_ZIPCODE
    ELSE
    (SELECT DISTINCT ZipCode FROM CRD1 WHERE CardCode = T0.CardCode AND AdresType = 'B') 
END AS 'PayeeZipCode',


CASE 
    WHEN (SELECT COUNT(RATE) FROM DPI5 WHERE AbsEntry=T3.DocEntry)>1 
    THEN (SELECT MAX(TaxbleAmnt) FROM DPI5 WHERE AbsEntry=T3.DocEntry)
    ELSE ISNULL(TaxbleAmnt,T0.DocTotal-T0.VatSum)
END AS 'TaxbleAmnt',

CASE 
    WHEN (SELECT COUNT(RATE) FROM DPI5 WHERE AbsEntry=T3.DocEntry)>1 
    THEN ((T3.SUMAPPLIED/T0.DOCTOTAL)*(SELECT MAX(TaxbleAmnt) FROM DPI5 WHERE AbsEntry=T3.DocEntry)) *(T1.RATE/100)
    ELSE T3.U_WtaxPay
END  AS 'WTAmnt',


(Select top 1 SUBSTRING(FedTaxID,1,3) FROM OWHS where replace(Address3,'_','')= LEFT(T0.U_DocSeries,6))
  AS 'PY1stTIN',
  
(Select top 1 SUBSTRING(FedTaxID,5,3) FROM OWHS where replace(Address3,'_','')= LEFT(T0.U_DocSeries,6))
  AS 'PY2ndTIN',

(Select top 1 SUBSTRING(FedTaxID,9,3) FROM OWHS where replace(Address3,'_','')= LEFT(T0.U_DocSeries,6))
  AS 'PY3ndTIN',

(Select top 1 SUBSTRING(FedTaxID,13,5) FROM OWHS where replace(Address3,'_','')= LEFT(T0.U_DocSeries,6))
  AS 'PY4thTIN',

ISNULL ((select TOP 1 
UPPER( CONCAT(CAST(Building AS varchar(max)),iif(Building IS NULL ,'',', '),
Street,iif(Street IS NULL ,'',', '),StreetNo,iif(StreetNo IS NULL ,'',', '),
[Block],iif([Block] IS NULL ,'',', '), City,iif(City IS NULL ,'',' ')) )
from owhs INNER JOIN INV1 ON INV1.WhsCode=OWHS.U_WhseExt AND INV1.DocEntry=T0.DocNum ), 
CASE WHEN
    CASE WHEN T0.DOCTYPE = 'I' THEN
    UPPER(
        (SELECT TOP 1 CONCAT(CAST(Building AS varchar(max)),iif(Building IS NULL ,'',', '),
        Street,iif(Street IS NULL ,'',', '),StreetNo,iif(StreetNo IS NULL ,'',', '),
        [Block],iif([Block] IS NULL ,'',', '), City,iif(City IS NULL ,'',' ')) 
        FROM owhs  WHERE WhsCode=(SELECT TOP 1 WhsCode FROM INV1 WHERE DocEntry=T0.DocNum) )) 
    WHEN T0.DOCTYPE = 'S' THEN
    UPPER(
        (SELECT TOP 1 CONCAT(CAST(Building AS varchar(max)),iif(Building IS NULL ,'',', '),
        Street,iif(Street IS NULL ,'',', '),StreetNo,iif(StreetNo IS NULL ,'',', '),
        [Block],iif([Block] IS NULL ,'',', '), City,iif(City IS NULL ,'',' ')) 
        FROM owhs  WHERE WhsCode=(SELECT TOP 1 OOCR.U_Whse FROM INV1 INNER JOIN OOCR ON INV1.OCRCODE = OOCR.OCRCODE WHERE DocEntry=T0.DocNum) )) 
    END IS NULL 
THEN
        (SELECT  CONCAT(iif(Building IS NULL,'' , CONCAT(Building, ', ')),iif(StreetNo IS NULL , '' , StreetNo +', '),iif([Block] IS NULL , '' , [Block] +', '),
        iif(City IS NULL , '' , City +', ' ),iif(County IS NULL , '' , County +' '))
        FROM  OWHS A0 
        inner join oudg  A1 on A0.WhsCode=A1.Warehouse
        inner join OUSR A2 on A1.Code=A2.DfltsGroup
        inner join ohem A3 on A2.USERID=A3.userId
        WHERE A3.code=T0.OwnerCode)
ELSE
    CASE WHEN T0.DOCTYPE = 'I' THEN
        UPPER((SELECT TOP 1 CONCAT(CAST(Building AS varchar(max)),iif(Building IS NULL ,'',', '),
        Street,iif(Street IS NULL ,'',', '),StreetNo,iif(StreetNo IS NULL ,'',', '),
        [Block],iif([Block] IS NULL ,'',', '), City,iif(City IS NULL ,'',' ')) 
        FROM owhs  WHERE WhsCode=(SELECT TOP 1 WhsCode FROM INV1 WHERE DocEntry=T0.DocNum) )) 
    WHEN T0.DOCTYPE = 'S' THEN
        UPPER((SELECT TOP 1 CONCAT(CAST(Building AS varchar(max)),iif(Building IS NULL ,'',', '),
        Street,iif(Street IS NULL ,'',', '),StreetNo,iif(StreetNo IS NULL ,'',', '),
        [Block],iif([Block] IS NULL ,'',', '), City,iif(City IS NULL ,'',' ')) 
        FROM owhs  WHERE WhsCode=(SELECT TOP 1 OOCR.U_Whse FROM INV1 INNER JOIN OOCR ON INV1.OCRCODE = OOCR.OCRCODE WHERE DocEntry=T0.DocNum) )) 
    END 
END)AS 'PayorAddress',

CASE WHEN 
    CASE WHEN T0.DOCTYPE = 'I' THEN  (SELECT TOP 1 ZipCode FROM owhs  WHERE WhsCode=(SELECT TOP 1 WhsCode FROM DPI1 WHERE DocEntry=T0.DocNum))
    WHEN T0.DOCTYPE = 'S' THEN (SELECT TOP 1 ZipCode FROM owhs  WHERE WhsCode=(SELECT  TOP 1  OOCR.U_Whse FROM DPI1 INNER JOIN OOCR ON DPI1.OCRCODE = OOCR.OCRCODE WHERE DocEntry=T0.DocNum)) END IS NULL 
    THEN (SELECT  ZipCode
            FROM  OWHS A0 
            inner join oudg  A1 on A0.WhsCode=A1.Warehouse
            inner join OUSR A2 on A1.Code=A2.DfltsGroup
            inner join ohem A3 on A2.USERID  =A3.userId
            WHERE A3.code=T0.OwnerCode)
    ELSE
    CASE WHEN T0.DOCTYPE = 'I' THEN   (SELECT TOP 1 ZipCode FROM owhs  WHERE WhsCode=(SELECT TOP 1 WhsCode FROM DPI1 WHERE DocEntry=T0.DocNum))
    WHEN T0.DOCTYPE = 'S' THEN  (SELECT TOP 1 ZipCode FROM owhs  WHERE WhsCode=(SELECT  TOP 1  OOCR.U_Whse FROM DPI1 
                                 INNER JOIN OOCR ON DPI1.OCRCODE = OOCR.OCRCODE WHERE DocEntry=T0.DocNum)) 
    END
END AS 'PayorZipCode',

CASE
    WHEN   month(t0.taxdate) IN (1,2,3) THEN '1'
    WHEN   month(t0.taxdate) IN (4,5,6) THEN '2'
    WHEN   month(t0.taxdate) IN (7,8,9) THEN '3'
    WHEN   month(t0.taxdate) IN (10,11,12) THEN '4'
    ELSE 'N/A'
END AS 'QTR',
t0.docentry as doc,
ISNULL((SELECT TI.U_ATC FROM OWHT TI
WHERE T1.AbsEntry=T0.DocNum AND TI.WTCode = T1.WTCode ),
ISNULL((SELECT A0.U_ATCCODE FROM JDT1 A0 INNER JOIN RCT2 A1 ON A0.TransId=A1.DocEntry 
    WHERE A1.DocNum=T3.DocNum  AND A0.U_ATCcode IS NOT NULL  AND A1.InvType=30  AND A1.U_wTaxComCode=ISNULL(T3.U_wTaxComCode,T0.U_wTaxComCode) 
),'')) AS 'ATC',

(SELECT COUNT(A0.DocNum) FROM ODPI A0 
INNER JOIN RCT2 A1 ON A0.Docentry = A1.Docentry
WHERE A1.DocNum =T3.DocNum
AND A0.WTSum>0
AND
(CASE
WHEN month(A0.taxdate) IN (1,2,3) THEN '1'
WHEN month(A0.taxdate) IN (4,5,6) THEN '2'
WHEN month(A0.taxdate) IN (7,8,9) THEN '3'
WHEN month(A0.taxdate) IN (10,11,12) THEN '4'
ELSE 'N/A' END)=@QTR) AS 'ROWS'

FROM ODPI T0 
LEFT JOIN DPI5 T1 ON T1.AbsEntry=T0.DocNum
INNER JOIN RCT2 T3 ON T0.DOCNUM= T3.Docentry AND T3.InvType=203

WHERE 
ISNULL(T0.U_wTaxComCode,T3.U_wTaxComCode)=@WTCOMCODE
AND T0.CANCELED='N'

UNION ALL 
--ARCM


SELECT 
ISNULL(T0.U_wTaxComCode,T3.U_wTaxComCode) AS 'U_wTaxComCode',T3.DOCNUM,'01' as WTaxDayFrom,
T0.U_WTax,T0.TaxDate, T0.DocTotal, 
--(Select CompnyName from OADM) AS 'Payor',
'SAFETYBULD INC.'+ (select top 1 ' / '+ TaxOffice from OWHS where replace(Address3,'_','')= LEFT(T0.U_DocSeries,6) ) AS 'Payor',
CASE 
    WHEN T0.DOCTYPE = 'I' THEN (SELECT TOP 1 WhsCode FROM INV1 WHERE DOCENTRY=T0.DocNum )
    WHEN T0.DOCTYPE = 'S' THEN (SELECT TOP 1 ocrcode FROM INV1 WHERE DOCENTRY=T0.DocNum )
END AS 'ocrcode',

CASE
    WHEN  month(t0.taxdate) IN (1,2,3) THEN '01'
    WHEN  month(t0.taxdate) IN (4,5,6) THEN '04'
    WHEN  month(t0.taxdate) IN (7,8,9) THEN '07'
    WHEN  month(t0.taxdate) IN (10,11,12) THEN '10'
    ELSE 'N/A' END AS WtaxMonthFrom,
CONVERT(varchar(10), year(T0.taxdate))  as 'WtaxYearFrom',
CASE
    WHEN  month(t0.taxdate) IN (1,2,3) THEN '03'
    WHEN  month(t0.taxdate) IN (4,5,6) THEN '06'
    WHEN   month(t0.taxdate) IN (7,8,9) THEN '09'
    WHEN  month(t0.taxdate) IN (10,11,12) THEN '12'
    ELSE 'N/A'  END AS WtaxMonthTo,
CONVERT(varchar(10), DAY(EOMONTH(
CASE
    WHEN  month(t0.taxdate) IN (1,2,3) THEN '2020-03-20 00:00:00.000'
    WHEN  month(t0.taxdate) IN (4,5,6) THEN '2020-06-20 00:00:00.000'
    WHEN  month(t0.taxdate) IN (7,8,9) THEN '2020-09-20 00:00:00.000'
    WHEN  month(t0.taxdate) IN (10,11,12) THEN '2020-12-20 00:00:00.000'
    ELSE 'N/A' END))) as WTaxDayTo,

CONVERT(varchar(10), year(t0.taxdate))  as 'WtaxYearTo',

CASE 
    WHEN T0.U_ALIAS_VENDOR IS NULL 
    THEN (SELECT IIF(A.CntctPrsn IS NULL,A.CardName,CONCAT(B.FirstName, ' ',B.LastName))AS 'CNAME' FROM OCRD A LEFT JOIN OCPR B ON A.CardCode=B.CardCode AND B.Name=A.CntctPrsn
          WHERE A.CardCode= T0.CardCode)
    ELSE T0.U_ALIAS_VENDOR
END AS 'Payee',
CASE 
    WHEN T0.U_TIN IS NOT NULL THEN LEFT(T0.U_TIN,3)
    ELSE (SELECT LEFT(LicTradNum, 3) FROM OCRD TT WHERE TT.CardCode = T0.CardCode) 
END As 'P1stTIN',
CASE 
    WHEN T0.U_TIN IS NOT NULL THEN SUBSTRING(T0.U_TIN,5,3)
    ELSE (SELECT SUBSTRING(LicTradNum,5,3) FROM OCRD TT WHERE TT.CardCode = T0.CardCode)     
END As 'P2ndTIN',
CASE 
    WHEN T0.U_TIN IS NOT NULL THEN SUBSTRING(T0.U_TIN,9,3)
    ELSE (SELECT SUBSTRING(LicTradNum,9,3) FROM OCRD TT WHERE TT.CardCode = T0.CardCode) 
END As 'P3rdTIN',
CASE 
    WHEN T0.U_TIN IS NOT NULL THEN SUBSTRING(T0.U_TIN,13,3)
    ELSE (SELECT SUBSTRING(LicTradNum,13,3) FROM OCRD TT WHERE TT.CardCode = T0.CardCode) 
END As 'P4thTIN',  
CASE 
    WHEN T0.U_ADDRESS IS NOT NULL THEN T0.U_ADDRESS
    ELSE
    UPPER((SELECT DISTINCT CONCAT(CAST(Building AS varchar(max)),
    (CASE WHEN Building IS NULL THEN '' ELSE ' ' END),Street,(CASE WHEN Street IS NULL THEN '' ELSE ', ' END), StreetNo,(CASE WHEN StreetNo IS NULL THEN '' ELSE ', ' END),[Block],
    (CASE WHEN [Block] IS NULL THEN '' ELSE ', ' END),City,(CASE WHEN City IS NULL THEN '' ELSE ' ' END)) 
    FROM CRD1 WHERE CardCode = t0.CardCode AND AdresType = 'B')) 
END AS 'Payee Address',
CASE 
    WHEN T0.U_ZIPCODE IS NOT NULL THEN T0.U_ZIPCODE
    ELSE
    (SELECT DISTINCT ZipCode FROM CRD1 WHERE CardCode = T0.CardCode AND AdresType = 'B') 
END AS 'PayeeZipCode',


CASE 
    WHEN (SELECT COUNT(RATE) FROM RIN5 WHERE AbsEntry=T3.DocEntry)>1 
    THEN (SELECT MAX(TaxbleAmnt) FROM RIN5 WHERE AbsEntry=T3.DocEntry)
    ELSE ISNULL(TaxbleAmnt,T0.DocTotal-T0.VatSum)
END AS 'TaxbleAmnt',

CASE 
    WHEN (SELECT COUNT(RATE) FROM RIN5 WHERE AbsEntry=T3.DocEntry)>1 
    THEN ((T3.SUMAPPLIED/T0.DOCTOTAL)*(SELECT MAX(TaxbleAmnt) FROM RIN5 WHERE AbsEntry=T3.DocEntry)) *(T1.RATE/100)
    ELSE T3.U_WtaxPay
END  AS 'WTAmnt',


(Select top 1 SUBSTRING(FedTaxID,1,3) FROM OWHS where replace(Address3,'_','')= LEFT(T0.U_DocSeries,6))
  AS 'PY1stTIN',
  
(Select top 1 SUBSTRING(FedTaxID,5,3) FROM OWHS where replace(Address3,'_','')= LEFT(T0.U_DocSeries,6))
  AS 'PY2ndTIN',

(Select top 1 SUBSTRING(FedTaxID,9,3) FROM OWHS where replace(Address3,'_','')= LEFT(T0.U_DocSeries,6))
  AS 'PY3ndTIN',

(Select top 1 SUBSTRING(FedTaxID,13,5) FROM OWHS where replace(Address3,'_','')= LEFT(T0.U_DocSeries,6))
  AS 'PY4thTIN',




ISNULL ((select TOP 1 
UPPER( CONCAT(CAST(Building AS varchar(max)),iif(Building IS NULL ,'',', '),
Street,iif(Street IS NULL ,'',', '),StreetNo,iif(StreetNo IS NULL ,'',', '),
[Block],iif([Block] IS NULL ,'',', '), City,iif(City IS NULL ,'',' ')) )
from owhs INNER JOIN INV1 ON INV1.WhsCode=OWHS.U_WhseExt AND INV1.DocEntry=T0.DocNum ), 
CASE WHEN
    CASE WHEN T0.DOCTYPE = 'I' THEN
    UPPER(
        (SELECT TOP 1 CONCAT(CAST(Building AS varchar(max)),iif(Building IS NULL ,'',', '),
        Street,iif(Street IS NULL ,'',', '),StreetNo,iif(StreetNo IS NULL ,'',', '),
        [Block],iif([Block] IS NULL ,'',', '), City,iif(City IS NULL ,'',' ')) 
        FROM owhs  WHERE WhsCode=(SELECT TOP 1 WhsCode FROM INV1 WHERE DocEntry=T0.DocNum) )) 
    WHEN T0.DOCTYPE = 'S' THEN
    UPPER(
        (SELECT TOP 1 CONCAT(CAST(Building AS varchar(max)),iif(Building IS NULL ,'',', '),
        Street,iif(Street IS NULL ,'',', '),StreetNo,iif(StreetNo IS NULL ,'',', '),
        [Block],iif([Block] IS NULL ,'',', '), City,iif(City IS NULL ,'',' ')) 
        FROM owhs  WHERE WhsCode=(SELECT TOP 1 OOCR.U_Whse FROM INV1 INNER JOIN OOCR ON INV1.OCRCODE = OOCR.OCRCODE WHERE DocEntry=T0.DocNum) )) 
    END IS NULL 
THEN
        (SELECT  CONCAT(iif(Building IS NULL,'' , CONCAT(Building, ', ')),iif(StreetNo IS NULL , '' , StreetNo +', '),iif([Block] IS NULL , '' , [Block] +', '),
        iif(City IS NULL , '' , City +', ' ),iif(County IS NULL , '' , County +' '))
        FROM  OWHS A0 
        inner join oudg  A1 on A0.WhsCode=A1.Warehouse
        inner join OUSR A2 on A1.Code=A2.DfltsGroup
        inner join ohem A3 on A2.USERID=A3.userId
        WHERE A3.code=T0.OwnerCode)
ELSE
    CASE WHEN T0.DOCTYPE = 'I' THEN
        UPPER((SELECT TOP 1 CONCAT(CAST(Building AS varchar(max)),iif(Building IS NULL ,'',', '),
        Street,iif(Street IS NULL ,'',', '),StreetNo,iif(StreetNo IS NULL ,'',', '),
        [Block],iif([Block] IS NULL ,'',', '), City,iif(City IS NULL ,'',' ')) 
        FROM owhs  WHERE WhsCode=(SELECT TOP 1 WhsCode FROM INV1 WHERE DocEntry=T0.DocNum) )) 
    WHEN T0.DOCTYPE = 'S' THEN
        UPPER((SELECT TOP 1 CONCAT(CAST(Building AS varchar(max)),iif(Building IS NULL ,'',', '),
        Street,iif(Street IS NULL ,'',', '),StreetNo,iif(StreetNo IS NULL ,'',', '),
        [Block],iif([Block] IS NULL ,'',', '), City,iif(City IS NULL ,'',' ')) 
        FROM owhs  WHERE WhsCode=(SELECT TOP 1 OOCR.U_Whse FROM INV1 INNER JOIN OOCR ON INV1.OCRCODE = OOCR.OCRCODE WHERE DocEntry=T0.DocNum) )) 
    END 
END)AS 'PayorAddress',

CASE WHEN 
    CASE WHEN T0.DOCTYPE = 'I' THEN  (SELECT TOP 1 ZipCode FROM owhs  WHERE WhsCode=(SELECT TOP 1 WhsCode FROM RIN1 WHERE DocEntry=T0.DocNum))
    WHEN T0.DOCTYPE = 'S' THEN (SELECT TOP 1 ZipCode FROM owhs  WHERE WhsCode=(SELECT  TOP 1  OOCR.U_Whse FROM RIN1 INNER JOIN OOCR ON RIN1.OCRCODE = OOCR.OCRCODE WHERE DocEntry=T0.DocNum)) END IS NULL 
    THEN (SELECT  ZipCode
            FROM  OWHS A0 
            inner join oudg  A1 on A0.WhsCode=A1.Warehouse
            inner join OUSR A2 on A1.Code=A2.DfltsGroup
            inner join ohem A3 on A2.USERID  =A3.userId
            WHERE A3.code=T0.OwnerCode)
    ELSE
    CASE WHEN T0.DOCTYPE = 'I' THEN   (SELECT TOP 1 ZipCode FROM owhs  WHERE WhsCode=(SELECT TOP 1 WhsCode FROM RIN1 WHERE DocEntry=T0.DocNum))
    WHEN T0.DOCTYPE = 'S' THEN  (SELECT TOP 1 ZipCode FROM owhs  WHERE WhsCode=(SELECT  TOP 1  OOCR.U_Whse FROM RIN1 
                                 INNER JOIN OOCR ON RIN1.OCRCODE = OOCR.OCRCODE WHERE DocEntry=T0.DocNum)) 
    END
END AS 'PayorZipCode',

CASE
    WHEN   month(t0.taxdate) IN (1,2,3) THEN '1'
    WHEN   month(t0.taxdate) IN (4,5,6) THEN '2'
    WHEN   month(t0.taxdate) IN (7,8,9) THEN '3'
    WHEN   month(t0.taxdate) IN (10,11,12) THEN '4'
    ELSE 'N/A'
END AS 'QTR',
t0.docentry as doc,
ISNULL((SELECT TI.U_ATC FROM OWHT TI
WHERE T1.AbsEntry=T0.DocNum AND TI.WTCode = T1.WTCode ),
ISNULL((SELECT A0.U_ATCCODE FROM JDT1 A0 INNER JOIN RCT2 A1 ON A0.TransId=A1.DocEntry 
    WHERE A1.DocNum=T3.DocNum  AND A0.U_ATCcode IS NOT NULL  AND A1.InvType=30  AND A1.U_wTaxComCode=ISNULL(T3.U_wTaxComCode,T0.U_wTaxComCode) 
),'')) AS 'ATC',

(SELECT COUNT(A0.DocNum) FROM ORIN A0 
INNER JOIN RCT2 A1 ON A0.Docentry = A1.Docentry
WHERE A1.DocNum = T3.DocNum
AND A0.WTSum>0
AND
(CASE
WHEN month(A0.taxdate) IN (1,2,3) THEN '1'
WHEN month(A0.taxdate) IN (4,5,6) THEN '2'
WHEN month(A0.taxdate) IN (7,8,9) THEN '3'
WHEN month(A0.taxdate) IN (10,11,12) THEN '4'
ELSE 'N/A' END)=@QTR) AS 'ROWS'

FROM ORIN T0 
LEFT JOIN RIN5 T1 ON T1.AbsEntry=T0.DocNum
INNER JOIN RCT2 T3 ON T0.DOCNUM= T3.Docentry AND T3.InvType=14

WHERE 
ISNULL(T0.U_wTaxComCode,T3.U_wTaxComCode) =@WTCOMCODE
AND T0.CANCELED='N'

UNION ALL
--JE
SELECT  
ISNULL(T0.U_wTaxComCode,T3.U_wTaxComCode) AS 'U_wTaxComCode',
T3.DOCNUM,'01' as WTaxDayFrom,
'n/A' AS 'U_WTax',
T0.TaxDate, 
0 AS 'DocTotal', 
--(Select CompnyName from OADM) AS 'Payor',
'SAFETYBULD INC.'+ (ISNULL((select top 1 ' / '+ TaxOffice from OWHS A INNER JOIN OJDT B ON A.Address3=B.Ref3 where B.Number=t0.TransId),'')) AS 'Payor',
ProfitCode AS 'ocrcode',
CASE
    WHEN  month(t0.taxdate) IN (1,2,3) THEN '01'
    WHEN  month(t0.taxdate) IN (4,5,6) THEN '04'
    WHEN  month(t0.taxdate) IN (7,8,9) THEN '07'
    WHEN  month(t0.taxdate) IN (10,11,12) THEN '10'
    ELSE 'N/A' END AS WtaxMonthFrom,
CONVERT(varchar(10), year(T0.taxdate))  as 'WtaxYearFrom',
CASE
    WHEN  month(t0.taxdate) IN (1,2,3) THEN '03'
    WHEN  month(t0.taxdate) IN (4,5,6) THEN '06'
    WHEN   month(t0.taxdate) IN (7,8,9) THEN '09'
    WHEN  month(t0.taxdate) IN (10,11,12) THEN '12'
    ELSE 'N/A'  END AS WtaxMonthTo,
CONVERT(varchar(10), DAY(EOMONTH(
CASE
    WHEN  month(t0.taxdate) IN (1,2,3) THEN '2020-03-20 00:00:00.000'
    WHEN  month(t0.taxdate) IN (4,5,6) THEN '2020-06-20 00:00:00.000'
    WHEN  month(t0.taxdate) IN (7,8,9) THEN '2020-09-20 00:00:00.000'
    WHEN  month(t0.taxdate) IN (10,11,12) THEN '2020-12-20 00:00:00.000'
    ELSE 'N/A' END))) as WTaxDayTo,

CONVERT(varchar(10), year(t0.taxdate))  as 'WtaxYearTo',
T4.CardName AS 'Payee',
LEFT(T4.LicTradNum, 3)
 As 'P1stTIN',
SUBSTRING(T4.LicTradNum,5,3)  
 As 'P2ndTIN',
SUBSTRING(T4.LicTradNum,9,3) 
 As 'P3rdTIN',
SUBSTRING(T4.LicTradNum,13,3) 
 As 'P4thTIN',
    UPPER((SELECT DISTINCT CONCAT(CAST(Building AS varchar(max)),
    (CASE WHEN Building IS NULL THEN '' ELSE ', ' END),Address2,(CASE WHEN Address2 IS NULL THEN '' ELSE ', ' END),Address3,(CASE WHEN Address3 IS NULL THEN '' ELSE ', ' END), 
    Street,(CASE WHEN Street IS NULL THEN '' ELSE ', ' END), StreetNo,(CASE WHEN StreetNo IS NULL THEN '' ELSE ', ' END),[Block],
    (CASE WHEN [Block] IS NULL THEN '' ELSE ', ' END),City,(CASE WHEN City IS NULL THEN '' ELSE ' ' END)) 
    FROM CRD1 WHERE CardCode = t4.CardCode AND AdresType = 'B')) 
AS 'Payee Address',
(SELECT DISTINCT ZipCode FROM CRD1 WHERE CardCode = T4.CardCode AND AdresType = 'B') 
AS 'PayeeZipCode',
T2.TaxbleAmnt AS 'TaxbleAmnt',
T2.WTAmnt AS 'WTAmnt',

(Select top 1 SUBSTRING(FedTaxID,1,3) FROM OWHS A INNER JOIN OJDT B ON A.Address3=B.Ref3 where B.Number=t0.TransId) AS 'PY1stTIN',
(Select top 1 SUBSTRING(FedTaxID,5,3) FROM OWHS A INNER JOIN OJDT B ON A.Address3=B.Ref3 where B.Number=t0.TransId) AS 'PY2ndTIN',
(Select top 1 SUBSTRING(FedTaxID,9,3) FROM OWHS A INNER JOIN OJDT B ON A.Address3=B.Ref3 where B.Number=t0.TransId) AS 'PY3ndTIN',
(Select top 1 SUBSTRING(FedTaxID,13,5) FROM OWHS A INNER JOIN OJDT B ON A.Address3=B.Ref3 where B.Number=t0.TransId) AS 'PY4thTIN',

ISNULL ((select TOP 1 
UPPER( CONCAT(CAST(Building AS varchar(max)),iif(Building IS NULL ,'',', '),
Street,iif(Street IS NULL ,'',', '),StreetNo,iif(StreetNo IS NULL ,'',', '),
[Block],iif([Block] IS NULL ,'',', '), City,iif(City IS NULL ,'',' ')) )
from owhs INNER JOIN PCH1 ON PCH1.WhsCode=OWHS.U_WhseExt AND PCH1.DocEntry=T0.DocNum ), 
    UPPER((SELECT TOP 1 CONCAT(CAST(Building AS varchar(max)),iif(Building IS NULL ,'',', '),
        Street,iif(Street IS NULL ,'',', '),StreetNo,iif(StreetNo IS NULL ,'',', '),
        [Block],iif([Block] IS NULL ,'',', '), City,iif(City IS NULL ,'',' ')) 
        FROM owhs  WHERE WhsCode=(SELECT TOP 1 WhsCode FROM PCH1 WHERE DocEntry=T0.DocNum) )) )
AS 'PayorAddress',
(SELECT TOP 1 ZipCode FROM owhs  WHERE WhsCode=T0.ProfitCode)
    AS 'PayorZipCode',

CASE
    WHEN   month(t0.taxdate) IN (1,2,3) THEN '1'
    WHEN   month(t0.taxdate) IN (4,5,6) THEN '2'
    WHEN   month(t0.taxdate) IN (7,8,9) THEN '3'
    WHEN   month(t0.taxdate) IN (10,11,12) THEN '4'
    ELSE 'N/A'
END AS 'QTR',
t3.docnum  as doc,    
(SELECT TI.U_ATC FROM OWHT TI WHERE  TI.WTCode = T2.WTCode ) AS 'ATC',

(SELECT COUNT(DocNum) FROM  RCT2 A0 WHERE DocNum = T3.DOCNUM) AS 'ROWS'


FROM JDT1 T0 
INNER JOIN JDT2 T2 ON T0.TransId=T2.AbsEntry
INNER JOIN RCT2 T3 ON T0.TransId= T3.Docentry AND T3.InvType=30
INNER JOIN OCRD T4 ON T0.ContraAct=T4.CardCode
where
ISNULL(T0.U_wTaxComCode,T3.U_wTaxComCode)=@WTCOMCODE

 )T
WHERE ATC LIKE '%'+@ATC+'%'
-- AND U_wTaxComCode LIKE '%'+@WTCOMCODE+'%' 
AND QTR =@QTR --AND T.[ATC] IS NOT NULL
ORDER BY TaxDate
OFFSET @GRP ROWS FETCH NEXT 15 ROWS ONLY

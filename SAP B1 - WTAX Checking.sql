
SELECT
T0.Docdate as 'document date',
t0.taxdate,

CASE
WHEN
month(t0.docdate) = '1' OR month(t0.docdate)= '2' OR month(t0.docdate)= '3' THEN '01'
WHEN
month(t0.docdate) = '4' OR month(t0.docdate)= '5' OR month(t0.docdate)= '6' THEN '04'
WHEN
month(t0.docdate) = '7' OR month(t0.docdate)= '8' OR month(t0.docdate)= '9' THEN '07'
WHEN
month(t0.docdate) = '10' OR month(t0.docdate)= '11' OR month(t0.docdate)= '12' THEN '10'
ELSE 'N/A'
END AS WtaxMonthFrom,
'01' as WTaxDayFrom,
year(t0.docdate) as 'WtaxYearFrom',

CASE
WHEN
month(t0.docdate) = '1' OR month(t0.docdate)= '2' OR month(t0.docdate)= '3' THEN '03'
WHEN
month(t0.docdate) = '4' OR month(t0.docdate)= '5' OR month(t0.docdate)= '6' THEN '06'
WHEN
month(t0.docdate) = '7' OR month(t0.docdate)= '8' OR month(t0.docdate)= '9' THEN '09'
WHEN
month(t0.docdate) = '10' OR month(t0.docdate)= '11' OR month(t0.docdate)= '12' THEN '12'
ELSE 'N/A'
END AS WtaxMonthTo,
DAY(EOMONTH(t0.docdate)) as WTaxDayTo,
year(t0.docdate) as WtaxYearTo,

T0.CardCode ,T0.CardName, T0.DocDate , 
(SELECT LEFT(LicTradNum, 3) FROM OCRD TT WHERE TT.CardCode = T0.CardCode) As 'P1stTIN',
(SELECT SUBSTRING(LicTradNum,5,3) FROM OCRD TT WHERE TT.CardCode = T0.CardCode) As 'P2ndTIN',
(SELECT SUBSTRING(LicTradNum,9,3) FROM OCRD TT WHERE TT.CardCode = T0.CardCode) As 'P3rdTIN',
(SELECT SUBSTRING(LicTradNum,13,3) FROM OCRD TT WHERE TT.CardCode = T0.CardCode) As 'P4thTIN', 
T0.DocTotal, 
TaxbleAmnt,
T0.WTSum, T0.U_WTax,  

CASE WHEN T0.DOCTYPE = 'I' THEN
(Select Left(FedTaxID,3) FROM OWHS WHERE WhsCode=(SELECT Distinct WhsCode FROM PCH1 WHERE DocEntry=T0.DocNum))
WHEN T0.DOCTYPE = 'S' THEN
(Select Left(FedTaxID,3) FROM OWHS WHERE WhsCode=(SELECT Distinct OOCR.U_Whse FROM PCH1 
INNER JOIN OOCR ON PCH1.OCRCODE = OOCR.OCRCODE WHERE DocEntry=T0.DocNum)) END AS 'PY1stTIN',

CASE WHEN T0.DOCTYPE = 'I' THEN
(Select SUBSTRING(FedTaxID,5,3) FROM OWHS WHERE WhsCode=(SELECT Distinct WhsCode FROM PCH1 WHERE DocEntry=T0.DocNum))
WHEN T0.DOCTYPE = 'S' THEN
(Select SUBSTRING(FedTaxId,5,3) FROM OWHS WHERE WhsCode=(SELECT Distinct OOCR.U_Whse FROM PCH1 
INNER JOIN OOCR ON PCH1.OCRCODE = OOCR.OCRCODE WHERE DocEntry=T0.DocNum)) END AS 'PY2ndTIN',

CASE WHEN T0.DOCTYPE = 'I' THEN
(Select SUBSTRING(FedTaxID,9,3) FROM OWHS WHERE WhsCode=(SELECT Distinct WhsCode FROM PCH1 WHERE DocEntry=T0.DocNum))
WHEN T0.DOCTYPE = 'S' THEN
(Select SUBSTRING(FedTaxId,9,3) FROM OWHS WHERE WhsCode=(SELECT Distinct OOCR.U_Whse FROM PCH1 
INNER JOIN OOCR ON PCH1.OCRCODE = OOCR.OCRCODE WHERE DocEntry=T0.DocNum)) END AS 'PY3ndTIN',

CASE WHEN T0.DOCTYPE = 'I' THEN
(Select SUBSTRING(FedTaxID,13,3) FROM OWHS WHERE WhsCode=(SELECT Distinct WhsCode FROM PCH1 WHERE DocEntry=T0.DocNum))
WHEN T0.DOCTYPE = 'S' THEN
(Select SUBSTRING(FedTaxId,13,3) FROM OWHS WHERE WhsCode=(SELECT Distinct OOCR.U_Whse FROM PCH1 
INNER JOIN OOCR ON PCH1.OCRCODE = OOCR.OCRCODE WHERE DocEntry=T0.DocNum)) END AS 'PY4thTIN',

(SELECT TI.U_ATCDesc FROM OWHT TI WHERE TI.WTCode = T1.WTCode) AS 'ATC Description', UPPER((SELECT DISTINCT CONCAT(CAST(Building AS varchar(max)),
(CASE WHEN Building IS NULL THEN '' ELSE ' ' END),Street,(CASE WHEN Street IS NULL THEN '' ELSE ', ' END), StreetNo,(CASE WHEN StreetNo IS NULL THEN '' ELSE ', ' END),[Block],
(CASE WHEN [Block] IS NULL THEN '' ELSE ', ' END),City,(CASE WHEN City IS NULL THEN '' ELSE ' ' END)) 
FROM CRD1 WHERE CardCode = t0.CardCode)) AS 'Payee Address',(Select CompnyName from OADM) AS Payor ,


CASE WHEN T0.DOCTYPE = 'I' THEN
UPPER((SELECT DISTINCT CONCAT(CAST(Building AS varchar(max)),(CASE WHEN Building IS NULL THEN '' ELSE ', ' END),
Street,(CASE WHEN Street IS NULL THEN '' ELSE ', ' END),StreetNo,(CASE WHEN StreetNo IS NULL THEN '' ELSE ', ' END),[Block],(CASE WHEN [Block] IS NULL THEN '' ELSE ', ' END),
City,(CASE WHEN City IS NULL THEN '' ELSE ' ' END)) FROM owhs  WHERE WhsCode=(SELECT Distinct WhsCode FROM PCH1 WHERE DocEntry=T0.DocNum) )) 
WHEN T0.DOCTYPE = 'S' THEN
UPPER((SELECT DISTINCT CONCAT(CAST(Building AS varchar(max)),(CASE WHEN Building IS NULL THEN '' ELSE ', ' END),
Street,(CASE WHEN Street IS NULL THEN '' ELSE ', ' END),StreetNo,(CASE WHEN StreetNo IS NULL THEN '' ELSE ', ' END),[Block],(CASE WHEN [Block] IS NULL THEN '' ELSE ', ' END),
City,(CASE WHEN City IS NULL THEN '' ELSE ' ' END)) FROM owhs  WHERE WhsCode=(
SELECT Distinct OOCR.U_Whse FROM PCH1 
INNER JOIN OOCR ON PCH1.OCRCODE = OOCR.OCRCODE WHERE DocEntry=T0.DocNum) )) 
 END AS 'PayorAddress',


CASE WHEN T0.DOCTYPE = 'I' THEN
(SELECT ZipCode FROM owhs  WHERE WhsCode=(SELECT Distinct WhsCode FROM PCH1 WHERE DocEntry=T0.DocNum))
WHEN T0.DOCTYPE = 'S' THEN
(SELECT ZipCode FROM owhs  WHERE WhsCode=(SELECT Distinct OOCR.U_Whse FROM PCH1 
INNER JOIN OOCR ON PCH1.OCRCODE = OOCR.OCRCODE WHERE DocEntry=T0.DocNum)) 
END AS 'PayorZipCode',

( SELECT DISTINCT ZipCode FROM CRD1 WHERE CardCode = T0.CardCode) AS 'PayeeZipCode',

(SELECT COUNT(*) from PDF2 T6 WHERE T6.DOCNUM = 516) AS 'ROWS'


FROM OPCH T0 INNER JOIN PCH5 T1 ON T0.DocNum = T1.AbsEntry 
INNER JOIN PDF2 ON T0.Docentry = PDF2.Docentry 
WHERE PDF2.DocNum = 586

ORDER BY T0.DOCENTRY ASC
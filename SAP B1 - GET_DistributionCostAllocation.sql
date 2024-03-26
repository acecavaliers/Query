

--IF $[OOCR.OCRCODE] LIKE '%ACCT%' OR $[OOCR.OCRCODE] LIKE '%WH%'

--BEGIN

------ Get Total value of Sales (JE)
DECLARE @TotalVal as decimal =(SELECT 
								(SUM(T1.Credit) - SUM((T1.Debit)))
							  FROM OJDT T0
							  INNER JOIN JDT1 T1 ON T0.NUMBER = T1.TRANSID
							  WHERE T1.ACCOUNT = 'RE010000' AND YEAR(T0.TAXDATE) = 2020
							  AND MONTH(T0.TAXDATE) = 2)
------ Get Total Value of Sales (Per Whse - JE)
DECLARE @WhseVal as decimal =(SELECT 
								(SUM(T1.Credit) - SUM((T1.Debit)))
							 FROM OJDT T0
							 INNER JOIN JDT1 T1 ON T0.NUMBER = T1.TRANSID
							 WHERE T1.ACCOUNT = 'RE010000' AND YEAR(T0.TAXDATE) = 2020
							 AND MONTH(T0.TAXDATE) =2
							 AND T1.ProfitCode LIKE '%str2%' )

SELECT @TotalVal, @WhseVal, format(ROUND((@WhseVal/ @TotalVal),2),'P') AS DistributionCostAllocation

SELECT PROFITCODE, T1.NUMBER AS Total
--, (SUM(T0.Credit) - SUM((T0.Debit * -1) / 
--								(SELECT 
--								(SUM(Tb.Credit) - SUM((Tb.Debit * -1)))
--							 FROM OJDT Ta
--							 INNER JOIN JDT1 Tb ON Ta.NUMBER = Tb.TRANSID
--							 WHERE Tb.ACCOUNT = 'RE010000' AND YEAR(Ta.TAXDATE) = 2020
--							 AND MONTH(Ta.TAXDATE) =3
--							 AND Tb.ProfitCode  = T0.ProfitCode)))

FROM JDT1 T0
INNER JOIN OJDT T1 ON NUMBER = T0.TRANSID
WHERE ACCOUNT = 'RE010000' AND MONTH(T0.TaxDate) = 3 AND YEAR(T0.TaxDate) = 2020
AND PROFITCODE LIKE '%WH1%'

--END

--IF $[OOCR.OCRCODE] LIKE '%ACCT%' OR $[OOCR.OCRCODE] LIKE '%WH%'

--BEGIN
--SELECT 
--FORMAT(ROUND(
--(SUM(T1.Credit) - SUM((T1.Debit * -1))) /
--(SELECT (SUM(T1.Credit) - SUM((T1.Debit * -1)))
--FROM OJDT T0
--INNER JOIN JDT1 T1 ON T0.NUMBER = T1.TRANSID
--WHERE T1.ACCOUNT = 'RE010000' 
--AND YEAR(T0.TAXDATE) = YEAR($[OOCR.U_REMDATE]) 
--AND MONTH(T0.TAXDATE) = MONTH($[OOCR.U_REMDATE]) ),2),'P')

--FROM OJDT T0
--INNER JOIN JDT1 T1 ON T0.NUMBER = T1.TRANSID
--WHERE T1.ACCOUNT = 'RE010000' 
--AND YEAR(T0.TAXDATE) = YEAR($[OOCR.U_REMDATE])
--AND MONTH(T0.TAXDATE) = MONTH($[OOCR.U_REMDATE]) 
--AND $[OCR1.PRCCODE] = T1.ProfitCode
--END
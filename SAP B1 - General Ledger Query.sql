



DECLARE @DateFrom as Date = '04/24/2019'
DECLARE @DateTo as Date = '05/21/2020'
DECLARE @i as INT = 0

SELECT 

ROW_NUMBER() OVER(PARTITION BY T1.ACCOUNT ORDER BY T0.NUMBER ASC ) AS Row#,
T0.Number as 'JE Entry',
T0.TransType,
CASE WHEN T0.TRANSTYPE = 69 THEN 'Landed Costs'
WHEN T0.TransType = 15 THEN 'Delivery'
WHEN T0.TransType = 310000001 then 'Inventory Opening Balance'
WHEN T0.TransType = 67 then 'Inventory Transfer'
WHEN T0.TransType = 21 then 'Goods Return'
WHEN T0.TransType = 18 then 'A/P Invoice'
WHEN T0.TransType = 19 then 'A/P Credit Memo'
WHEN T0.TransType = 13 then 'A/R Invoice'
WHEN T0.TransType = 162 then 'Inventory Reevaluation'
WHEN T0.TransType = 59 then 'Goods Receipt'
WHEN T0.TransType = 60 then 'Goods Issue'
WHEN T0.TransType = 20 then 'GRPO'
WHEN T0.TransType = 14 then 'A/R Credit Memo'
WHEN T0.TransType = 30 then 'Journal Entry'
WHEN T0.TransType = 24 then 'Incoming Payment'
WHEN T0.TransType = 25 then 'Deposit'
WHEN T0.TransType = 46 then 'Outgoing Payments'
WHEN T0.TransType = 203 then 'A/R Downpayment'
WHEN T0.TransType = 204 then 'A/P Downpayment'
WHEN T0.TransType = -2 then 'Opening Balance'
WHEN T0.TransType = 1470000090 then 'Asset Transfer'
WHEN T0.TransType = 321 then 'Internal Reconciliation'
WHEN T0.TransType = 1470000049 then 'Capitalization'
WHEN T0.TransType = 1470000071 then 'Depreciation Run'
WHEN T0.TransType = 1470000075 then 'Manual Depreciation'
WHEN T0.TransType = -4 then 'BN'
END AS TransactionType,
'----------------------------',
T0.REFDATE AS Date,
CONCAT('JE-',T0.NUMBER, ':',
CASE WHEN T0.TRANSTYPE = 69 THEN 'IF-'
WHEN T0.TransType = 15 THEN 'DN-'
WHEN T0.TransType = 310000001 then 'OB-'
WHEN T0.TransType = 67 then 'IM-'
WHEN T0.TransType = 21 then 'PR-'
WHEN T0.TransType = 18 then 'PU-'
WHEN T0.TransType = 19 then 'PC-'
WHEN T0.TransType = 13 then 'IN-'
WHEN T0.TransType = 162 then 'MR-'
WHEN T0.TransType = 59 then 'SI-'
WHEN T0.TransType = 60 then 'SO-'
WHEN T0.TransType = 20 then 'PD-'
WHEN T0.TransType = 14 then 'CN-'
WHEN T0.TransType = 30 then 'JE-'
WHEN T0.TransType = 24 then 'RC-'
WHEN T0.TransType = 25 then 'DP-'
WHEN T0.TransType = 46 then 'PS-'
WHEN T0.TransType = 203 then 'DT-'
WHEN T0.TransType = 204 then 'DT-'
WHEN T0.TransType = -2 then 'OB-'
WHEN T0.TransType = 1470000090 then 'FT-'
WHEN T0.TransType = 321 then 'JR-'
WHEN T0.TransType = 1470000049 then 'AC-'
WHEN T0.TransType = 1470000071 then 'DR-'
WHEN T0.TransType = 1470000075 then 'MD-'
WHEN T0.TransType = -4 then 'BN-'
END,
REPLICATE('0', 7 - LEN(T0.BaseRef)) + CAST(T0.BaseRef AS varchar)  ) as 'Base Reference',

CASE WHEN T0.MEMO <> T1.LINEMEMO THEN
concat(t0.Memo,' : ', T1.LineMemo)
ELSE t0.Memo
END as 'Brief Description',


T1.Account as 'Account Code',
T2.Acctname as 'Account Name',
'' as 'PHP Balance',
T1.Debit AS 'PHP Debit',
SUM(isnull(T1.DEBIT,0)) OVER (PARTITION BY T1.ACCOUNT ORDER BY T1.ACCOUNT, T0.REFDATE, T1.Transid, T1.Line_ID ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ) as PHPSumDebit,
SUM(isnull(T1.DEBIT,0)) OVER (ORDER BY T1.ACCOUNT, T0.REFDATE, T1.Transid, T1.Line_ID ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ) as GrandTotalDebit,

T1.Credit AS 'PHP Credit',
SUM(isnull(T1.Credit,0)) OVER (PARTITION BY T1.ACCOUNT ORDER BY T1.ACCOUNT, T0.REFDATE, T1.Transid, T1.Line_ID ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ) as PHPSumCredit,
SUM(isnull(T1.Credit,0)) OVER (ORDER BY T1.ACCOUNT, T0.REFDATE, T1.Transid, T1.Line_ID ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ) as GrandTotalCredit,

--case when 

--CAST(SUM(isnull(T1.DEBIT,0) - isnull(T1.CREDIT,0)) OVER (PARTITION BY T1.ACCOUNT ORDER BY T1.ACCOUNT, T1.Transid, T1.Line_ID ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ) AS MONEY) > 0 then 
--ROW_NUMBER() OVER (PARTITION BY T1.ACCOUNT ORDER BY T1.ACCOUNT, T1.Transid, T1.Line_ID ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ) as test,

--ROW_NUMBER() OVER (PARTITION BY T1.ACCOUNT ORDER BY T0.NUMBER ASC) AS Row#,
CASE WHEN T1.DEBIT > 0 THEN 
SUM(isnull(T1.DEBIT,0) - isnull(T1.CREDIT,0))   OVER (PARTITION BY T1.ACCOUNT ORDER BY T1.ACCOUNT, T0.REFDATE, T1.Transid, T1.Line_ID ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ) - T1.DEBIT
WHEN T1.CREDIT > 0 THEN 
SUM(isnull(T1.DEBIT,0) - isnull(T1.CREDIT,0))   OVER (PARTITION BY T1.ACCOUNT ORDER BY T1.ACCOUNT, T0.REFDATE, T1.Transid, T1.Line_ID ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ) + T1.CREDIT 
END as PHPPreviousBalance,

SUM(isnull(T1.DEBIT,0) - isnull(T1.CREDIT,0)) OVER (PARTITION BY T1.ACCOUNT ORDER BY T1.ACCOUNT, T0.REFDATE, T1.Transid, T1.Line_ID ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ) as PHPRunningBalance

FROM OJDT t0 
INNER JOIN JDT1 T1 ON T0.NUMBER = T1.TRANSID 
LEFT OUTER JOIN OACT T2 ON T1.ACCOUNT = T2.AcctCode
--WHERE T0.TransType = 1470000075
--WHERE T0.MEMO <> T1.LINEMEMO
--WHERE T1.Account = 'CA01010101'
ORDER BY T1.ACCOUNT, T0.REFDATE, T1.Transid, T1.Line_ID ASC

--select * from jdt1 


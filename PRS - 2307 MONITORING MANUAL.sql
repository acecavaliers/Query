





SELECT 
T0.PRFID,
T3.INVDATE AS 'Date',
T2.SUPPNAME AS 'Supplier',
T2.ADDRESS AS 'Address',
T2.TIN AS 'TIN No.',
SUBSTRING(T2.TIN, 13,15) AS 'Branchcode',
T3.INVREF AS 'Invoice #',
T3.InvAmt as 'Invoice Amount',
T3.VATABLEAMT AS 'Vatable Amount',
T3.NONVATW as 'Non-Vatable Amount',
T3.DiscW AS 'Discounts - W',
T3.VATABLEAMT+T3.NONVATW AS 'Total (VAT+NONVAT)',
T3.NONVATNW AS 'Non Vatable Amount - NW', 
T3.DISC as 'Discounts - NW',
T3.INPUTTAX AS '12%VAT',
SUBSTRING(T3.WTAXTYPE, 0,4) AS 'Percentage',
T3.WTAXAMT AS 'Amount',
T3.PAYABLE AS 'Amount Paid to Supplier',
T3.PayableAcctTag,
T1.CompCode,
T0.PrepBy
FROM tbl_PRFHeader T0 
INNER JOIN tbl_Company T1 ON T0.COMPID = T1.CompID
INNER JOIN tbl_Supplier T2 ON T0.SUPPID = T2.SUPPID
INNER JOIN tbl_PRFDetails T3 ON T0.PRFID = T3.PRFID 
WHERE T0.PREPBY LIKE '%GPAULE%' AND MONTH(T0.DatePrep) = 2




SELECT 
T0.PRFID,
T2.SUPPNAME AS 'Supplier',
T2.ADDRESS AS 'Address',
T2.TIN AS 'TIN No.',
SUBSTRING(T2.TIN, 13,15) AS 'Branchcode',
T3.DATE,
T3.REFNUM,
t4.accounttitle,
t4.customerjob,
t4.amount,
t4.amountpayableGL,
t4.referencenumber,
T5.SuppName,
T5.TIN,
T5.Address,
T1.CompCode,
T0.PrepBy,
t3.memo, 
t4.memo AS 'Entry Memo'
FROM tbl_PRFHeader T0 
INNER JOIN tbl_Company T1 ON T0.COMPID = T1.CompID
INNER JOIN tbl_Supplier T2 ON T0.SUPPID = T2.SUPPID
INNER JOIN tbl_PRFPayrollPettyCashDetails T3 ON T0.PRFID = T3.PRFID
INNER JOIN tbl_PRFPayrollPettyCashDetails2 T4 ON T3.PRFID = T4.PRFID
INNER JOIN TBL_SUPPLIER T5 ON T4.psuppid = T5.SuppID
WHERE T0.PREPBY LIKE '%GPAULE%' AND MONTH(T0.DatePrep) = 2
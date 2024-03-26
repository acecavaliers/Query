SELECT

T0.PRFID AS 'PRFID',
T3.INVDATE AS 'Invoice Date',
T1.SUPPNAME AS 'Supplier Name',
T1.ADDRESS AS 'Address',
T1.TIN AS 'TIN Number',
SUBSTRING(T1.TIN, 13,15) AS 'Branchcode',
T3.InvRef as 'Invoice Number',
T3.InvAmt as 'Invoice Amount',
T3.InputTax as 'Input Tax',
T3.vatableAmt as 'Vatable Amount',
T3.NonVatW as 'Non - Vatable Amount/W',
T3.DiscW as 'Discounts/W',
T3.vatableAmt + T3.NonVatW AS 'Total',
T3.NonVatNW as 'Non - Vatable Amount/NW',
T3.Disc as 'Discount/NW',
T3.VatableAmt  * 0.12 as 'VAT'


FROM TBL_PRFHEADER T0
INNER JOIN TBL_SUPPLIER T1
ON T0.SUPPID = T1.SUPPID
INNER JOIN TBL_COMPANY T2
ON T0.COMPID = T2.COMPID
INNER JOIN TBL_PRFDETAILS T3
ON T0.PRFID = T3.PRFID

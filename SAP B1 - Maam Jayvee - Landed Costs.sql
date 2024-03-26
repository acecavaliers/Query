












SELECT 
T0.DOCNUM AS 'Landed Cost Document Number',
T0.DOCDATE AS 'Posting Date',
T0.CARDCODE AS 'Vendor Code',
T0.SUPPNAME AS 'Supplier Name',
T0.AGENTCODE AS 'Agent Code',
T0.AGENTNAME AS 'Agent Name',
T0.DESCR AS 'Remarks',
T1.ItemCode as 'Item Code',
T1.Dscription as 'Item Description',
T1.Quantity as 'Quantity',
T1.TtlExpndLC as 'Alloc. Costs. Val' 
FROM OIPF T0
INNER JOIN IPF1 T1 ON T0.DOCNUM = T1.DOCENTRY

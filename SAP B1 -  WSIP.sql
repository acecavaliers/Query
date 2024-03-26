
SELECT 

T0.DOCNUM AS 'Document Number',
T0.TAXDATE AS 'Document Date',
T0.DocDueDate AS 'Delivery Date',
T0.CARDCODE AS 'BP Code',
T0.CARDNAME AS 'Supplier Name',
T1.ITEMCODE AS 'Item Code',
T1.DSCRIPTION AS 'Item Name',
T1.QUANTITY AS 'Quantity',
T1.UNITMSR AS 'UNIT',
T1.WHSCODE AS 'Warehouse',
T1.BASEREF AS 'Reference Number',
(SELECT TX.CARDNAME FROM ORDR TX WHERE TX.DOCENTRY = T1.BASEREF) AS 'Customer Name',
(SELECT DISTINCT TOP 1 ta.DocEntry FROM INV1 TA where TA.BASEREF = T1.BASEREF) AS 'AR Invoice Number'


FROM OPOR T0
INNER JOIN POR1 T1
ON T0.DOCNUM = T1.DOCENTRY
WHERE T0.CARDCODE = 'V000105' AND T1.WHSCODE LIKE '%DS%'
ORDER BY 'Document Number' ASC

select * from oinv t0
inner join inv1 t1 on
t0.docentry = t1.docentry
where t1.docentry = 1135

select * from inv1
where DOCENTRY = 6453

SELECT * FROM OINV

-- Purchase Order Details -> POR1
-- Purchase Order Header -> OPOR
-- Sales Order Header -> ORDR
-- Sales Order Details -> RDR1
-- AR Invoice Header -> OINV
-- AR Invoice Details -> INV1


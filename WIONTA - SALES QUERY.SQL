SELECT a.id,a.crdate,e.dirname,a.crinvno,a.crtotam,b.crqty,b.crunit,b.crprice,b.crprono,
concat(d.brand,' ', c.size)as Description
FROM Cusdr a 
INNER JOIN Cusdri b on a.id = truncate(b.crcode,0)
INNER JOIN Size c ON b.crprono = c.pdno
INNER JOIN Brand d on c.scode = d.scode
INNER JOIN Director e ON a.Crcuno = e.ID
WHERE YEAR(a.CRDate)=2019 AND (d.Brand LIKE '%CELLO%' OR c.Size LIKE '%CELLO%') AND (d.Brand NOT LIKE '%CELLOPHANE%' OR c.Size NOT LIKE '%CELLOPHANE%')
ORDER BY a.CRdate,a.ID

SELECT a.id,a.cidate,a.ciname,a.ciinvno,a.citotam,b.ciqty,b.ciunit,b.ciprice,b.ciprono,
concat(d.brand,' ', c.size)as Description
FROM CUSINV a 
INNER JOIN CUSINVI b on a.id = truncate(b.cicode,0)
INNER JOIN Size c ON b.ciprono = c.pdno
INNER JOIN Brand d on c.scode = d.scode
WHERE YEAR(a.CiDate)=2019 AND (d.Brand LIKE '%CELLO%' OR c.Size LIKE '%CELLO%') AND (d.Brand NOT LIKE '%CELLOPHANE%' OR c.Size NOT LIKE '%CELLOPHANE%')
ORDER BY a.Cidate,a.ID

SELECT ID, ItemLookupCode, Description +''+
CONVERT(NVARCHAR(MAX),ExtendedDescription) , Price as CustomerPrice, PriceC as BasePrice,
Price - PriceC as Commision,
Quantity, QuantityCommitted,
UnitOfMeasure FROM [dbo].[Item] WHERE QUANTITY > 0
order by 
Quantity desc

select company, accountbalance, creditlimit from customer
order by creditlimit asc 

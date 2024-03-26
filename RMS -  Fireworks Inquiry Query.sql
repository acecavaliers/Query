




SELECT CAST([Description] AS varchar) +'-' + CAST([ExtendedDescription] AS varchar) as 'Item',
UnitOfMeasure 'Quantity/ Unit of Measure',
Quantity 'Stock on Hand',
QuantityCommitted AS 'Stocks Committed',
Price as 'Retail Price',
PriceA as 'Discounted 1',
PriceB as 'Discounted 2',
PriceC as '!BASED PRICE!'  FROM ITEM
Where Quantity > 0
ORDER BY PRICE ASC

--WHERE [ExtendedDescription] LIKE '%C01%'


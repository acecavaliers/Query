-- GET Warehouse
DECLARE @whse VARCHAR(30)
	SELECT @whse = 'KORST1'
		--@whse = LEFT($[$13.15.0] , 6) 
--GET MAX SERIES BASED ON TENDER TYPE -- 
	DECLARE @docSeries INT
	IF EXISTS(SELECT * FROM OPRR WHERE U_DocSeries LIKE '%'+@whse+'%') 
		BEGIN
			SELECT @docSeries = (SELECT COUNT(*) + 1 FROM OPRR TA WHERE LEFT(TA.U_DocSeries, CHARINDEX('-', TA.U_DocSeries) - 1) = @whse)
		END 
	ELSE 
		BEGIN SELECT @docSeries = 1 END
-- RETURN FINAL OUTPUT --
SELECT @whse + '-' + FORMAT(@docSeries,'000000000')
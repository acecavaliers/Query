DECLARE @whse VARCHAR(30)
DECLARE @docSeries INT
DECLARE @col VARCHAR(100)	

IF $[$3.1-4.0] = 'I' 
	BEGIN
		SELECT @whse = LEFT($[$38.24.0] , 6) 
	END
ELSE
	BEGIN
		SELECT @whse = (SELECT LEFT(T0.U_WHSE,6) FROM	 T0 WHERE T0.OcrCode = $[$39.2004.0])
	END

IF $[$1.0.0] <> 'Update' and $[$1.0.0] <> 'Ok'
	BEGIN
		SELECT @docSeries = (SELECT COUNT(*) + 1 FROM OPCH TA WHERE LEFT(TA.U_DocSeries, CHARINDEX('-', TA.U_DocSeries) - 1) = @whse)
		SELECT @whse + '-' + FORMAT(@docSeries,'000000000')
	END
ELSE IF($[$1.0.0] = 'Update' OR $[$1.0.0] = 'Ok')
	BEGIN
		SELECT $[$U_DocSeries.0.0]		
	END


		IF 
			(SELECT LEFT(T0.U_DocSeries, 6)  FROM OPOR T0
			WHERE T0.[DocNum]=@list_of_cols_val_tab_del) 
			<>
			(SELECT DISTINCT LEFT(T0.WhsCode, 6)  FROM POR1 T0
			WHERE T0.Docentry=@list_of_cols_val_tab_del)
				BEGIN
					SET @error=601
					SET @error_message ='Series Store & Document Warehouse does not Match.'
				END
		IF (SELECT LEFT(T0.U_DocSeries, 6)  FROM OPOR T0 WHERE T0.[DocNum]=@list_of_cols_val_tab_del) IS NULL
			BEGIN
				SET @error=602
				SET @error_message ='Empty Series Number not Allowed'
			END
		IF EXISTS (SELECT T0.U_DOCSERIES FROM OPOR T0 WHERE T0.DocNum=@list_of_cols_val_tab_del AND T0.U_DocSeries IN (SELECT U_DocSeries FROM OPOR WHERE DocNum<>@list_of_cols_val_tab_del))
			BEGIN
				SET @error=603
				SET @error_message ='Series Number Already Exists!'
			END

			SELECT DOCNUM, U_DOCSERIES FROM OPCH
			where U_DocSeries is not null  
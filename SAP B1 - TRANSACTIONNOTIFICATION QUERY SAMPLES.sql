IF @object_type = '46' AND (@transaction_type='A' OR @transaction_type='U')
      BEGIN 
			--To required remarks  
			IF EXISTS (SELECT DocEntry FROM OVPM WHERE Comments IS NULL AND DocEntry=@list_of_cols_val_tab_del)
			BEGIN
				SET @error=10
				SET @error_message ='Remarks is required.' 
			END

			--To Check if check number exists in check issuance
			IF EXISTS(SELECT T0.U_ChkNumExt FROM VPM1 T0
			INNER JOIN OVPM T1 ON T0.DocNum = T1.DocNum
			WHERE T1.DocNum = @list_of_cols_val_tab_del AND T1.Canceled = 'N' AND T1.CheckSum > 0 
			AND 
			(T0.CheckNum IN (SELECT TA.CheckNum FROM VPM1 TA
			INNER JOIN OVPM TB ON TB.DOCNUM = TA.DocNum 
			WHERE TB.CANCELED = 'N' AND TB.DocEntry <> @list_of_cols_val_tab_del )
			AND
			T0.U_ChkNumExt IN (SELECT U_ChkNumExt FROM VPM1 TA
			INNER JOIN OVPM TB ON TB.DOCNUM = TA.DocNum 
			WHERE TB.CANCELED = 'N' AND TB.DocEntry <> @list_of_cols_val_tab_del )))

			BEGIN
				SET @error=10
				SET @error_message ='14 - Check No. Already used in Previous Transaction.' 
			END

			--To ensure that the only Managing Director can add the approved Outgoing Payment Entry
			IF EXISTS(SELECT T0.UserSign FROM OVPM T0 INNER JOIN OUSR T1
					  ON T0.UserSign=T1.USERID
					  WHERE T0.DocEntry =  @list_of_cols_val_tab_del AND (T1.SUPERUSER='N' AND T1.USER_CODE !='ACCT1'))
			BEGIN
				SET @error=10
				SET @error_message ='Only the Managing Director can add the Outgoing Payment entry' 
			END

			--To ensure that the Date Issued was inputted
			IF (SELECT T1.CHECKSUM FROM OVPM T1 WHERE T1.DocNum = @list_of_cols_val_tab_del ) > 0
			AND (SELECT U_ISSUEDATE FROM VPM1 T1 WHERE T1.docnum = @list_of_cols_val_tab_del ) is null
				BEGIN
					SET @error=101
					SET @error_message = 'Date Issued for Check Number is Required'
				END
	END
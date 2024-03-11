

DECLARE 
@DATEFROM DATE ='2023-05-01', 
@DATETO DATE ='2023-12-31',
@DEPARTMENT VARCHAR(100)='',
@CATEGORY VARCHAR(100)='',
@ITEMNAME VARCHAR(200)='',
@STORE VARCHAR(50)=''

SELECT * FROM (
    -- STANDARD AR
SELECT 
    T4.Name AS C,
    'AR INVOICE' AS 'TYPE',
    
    T0.DocEntry AS 'Transaction#',
    T3.TaxDate AS 'Posting Date',
    Month(T3.TaxDate) AS 'Month',
    CONCAT(Month(T3.TaxDate),'G' )AS 'GRSMonth',
    CONCAT(Month(T3.TaxDate),'Q' )AS 'QMonth',
    
   
    T3.CardName AS 'Customer',
    
   
    
    
    T0.ItemCode AS 'Item Code',
    T0.unitMsr AS 'unit',
    T0.UOMCODE,
    T0.NumPerMsr,
    IIF(T0.NumPerMsr>1,T0.QUANTITY*T0.NumPerMsr,T0.Quantity) LWST,
    T0.Quantity AS 'Quantity Sold',
    T0.U_GPBD AS 'Price Before Discount',
    T0.PriceAfVAT AS 'Price After Discount',
    T0.INMPrice AS 'Price After Discount(VAT-Ex)',
    T0.StockValue/T0.Quantity AS 'COST',

    T0.INMPrice * T0.Quantity AS 'Total Sales',
    T0.FreeTxt


    FROM INV1 T0
    INNER JOIN OINV T3 ON T0.DocEntry = T3.DocNum
    INNER JOIN dbo.[@SALESAGENT] T4 ON T4.Code=T3.U_SalesAgent 

    WHERE T3.DocType = 'I'    
    AND T3.CANCELED='N'
    AND T3.isIns='N'
    -- AND T3.TaxDate BETWEEN @DATEFROM AND @DATETO
    AND T3.U_BO_DRS ='N' AND T3.U_BO_DSDD ='N' AND T3.U_BO_DSDV ='N' AND T3.U_BO_DSPD ='N'

    UNION ALL --AR RESERRVE
    SELECT
    T4.Name AS C,
    'AR RESERVE' AS 'TYPE',
    
    T0.DocEntry AS 'Transaction#',
    T3.TaxDate AS 'Posting Date',
    Month(T3.TaxDate) AS 'Month',
    CONCAT(Month(T3.TaxDate),'G' )AS 'GRSMonth',
    CONCAT(Month(T3.TaxDate),'Q' )AS 'QMonth',
    
    
    T3.CardName AS 'Customer',
    
   
    
    
    T0.ItemCode AS 'Item Code',
    T0.unitMsr AS 'unit',
    T0.UOMCODE,
    T0.NumPerMsr,
    
    IIF(T0.NumPerMsr>1,(T0.Quantity-ISNULL(T7.QTY,0))*T0.NumPerMsr,T0.Quantity-ISNULL(T7.QTY,0)) LWST,
    T0.Quantity-ISNULL(T7.QTY,0) AS 'Quantity Sold',
    T0.U_GPBD AS 'Price Before Discount',
    T0.PriceAfVAT AS 'Price After Discount',
    T0.INMPrice AS 'Price After Discount(VAT-Ex)',
    CASE WHEN T0.UOMCODE=T0.UOMCODE2 
    THEN (SELECT AvgPrice FROM OITW WHERE ItemCode= T0.ItemCode AND WhsCode=T0.WhsCode) 
    ELSE  (SELECT AvgPrice FROM OITW WHERE ItemCode= T0.ItemCode AND WhsCode=T0.WhsCode)*T0.NumPerMsr
    END AS 'COST',

    T0.INMPrice * (T0.Quantity-ISNULL(T7.QTY,0)) AS 'Total Sales'
    ,NULL AS FreeTxt

    FROM INV1 T0

    INNER JOIN OINV T3 ON T0.DocEntry = T3.DocNum
    INNER JOIN dbo.[@SALESAGENT] T4 ON T4.Code=T3.U_SalesAgent 
    LEFT JOIN (SELECT SUM(Quantity)AS QTY,A0.BaseEntry,ITEMCODE FROM DLN1 A0 
                INNER JOIN ODLN A1 ON A0.DocEntry=A1.DocNum 
                WHERE CANCELED='N'
                GROUP BY  A0.BaseEntry ,ItemCode
              )AS T7 ON T0.DocEntry=T7.BaseEntry
               AND T7.ItemCode=T0.ItemCode

    WHERE T3.DocType = 'I' 
    AND T3.CANCELED='N'
    AND T3.isIns='Y'
    -- AND T3.TaxDate BETWEEN @DATEFROM AND @DATETO
    AND T3.U_BO_DRS ='N' AND T3.U_BO_DSDD ='N' AND T3.U_BO_DSDV ='N' AND T3.U_BO_DSPD ='N'
    AND T0.Quantity-ISNULL(T7.QTY,0)>0

    UNION ALL --DELIVERIES


    SELECT 
    
    T4.Name AS C,
    'DELIVERY' AS 'TYPE',
    
    T0.BaseEntry AS 'Transaction#',

    T7.TaxDate AS 'Posting Date',
    Month(T7.TaxDate) AS 'Month',
    CONCAT(Month(T7.TaxDate),'G' )AS 'GRSMonth',
    CONCAT(Month(T7.TaxDate),'Q' )AS 'QMonth',
   
  
    T7.CardName AS 'Customer',
    
   
    
    
    T0.ItemCode AS 'Item Code',
    T0.unitMsr AS 'unit',
    T0.UOMCODE,
    T0.NumPerMsr,
    
    IIF(T0.NumPerMsr>1,T0.QUANTITY*T0.NumPerMsr,T0.Quantity) LWST,
    T0.Quantity AS 'Quantity Sold',
    T0.U_GPBD AS 'Price Before Discount',
    T0.PriceAfVAT AS 'Price After Discount',
    T0.INMPrice AS 'Price After Discount(VAT-Ex)',
    T0.StockValue/T0.Quantity AS 'COST',
    T0.INMPrice * T0.Quantity AS 'Total Sales'
    ,NULL AS FreeTxt

    FROM DLN1 T0
    INNER JOIN ODLN T3 ON T0.DocEntry = T3.DocNum
    INNER JOIN dbo.[@SALESAGENT] T4 ON T4.Code=T3.U_SalesAgent 
    LEFT JOIN OINV T7 ON T0.BaseEntry=T7.DocNum


    WHERE T3.DocType = 'I' 
    AND T3.CANCELED='N'
    -- AND T7.TaxDate BETWEEN @DATEFROM AND @DATETO 

    UNION ALL --DROPSHIP--DROPSHIP

    SELECT DISTINCT 
   
    T4.Name AS C,
    CASE 
        WHEN T3.isIns ='Y' 
        THEN 'AR RESERVE' 
        ELSE 'AR INVOICE' 
    END AS 'TYPE',
    
    T0.DocEntry AS 'Transaction#',
    T3.DocDate AS 'Posting Date',
    Month(T3.DocDate) AS 'Month',
    CONCAT(Month(T3.DocDate),'G' )AS 'GRSMonth',
    CONCAT(Month(T3.DocDate),'Q' )AS 'QMonth',
    
    
    T3.CardName AS 'Customer',
    
   
    
    
    T0.ItemCode AS 'Item Code',
    T0.unitMsr AS 'unit',
    T0.UOMCODE,
    T0.NumPerMsr,
    
    -- (T0.Quantity - ISNULL(T11.Quantity,0))

    -- AS 'Quantity Sold', 
    
    CASE 
        WHEN T6.Quantity IS NOT NULL 
        THEN IIF(T6.NumPerMsr>1,(T6.QUANTITY*T6.NumPerMsr),T6.QUANTITY)
        WHEN T7.ARCNT=1
        THEN IIF(T7.NumPerMsr>1,(T7.QUANTITY*T7.NumPerMsr),T7.QUANTITY)
        WHEN T7.ARCNT>1 AND T7.ARLAST=1
        
        THEN IIF(T7.NumPerMsr>1,(T7.QUANTITY*T7.NumPerMsr),T7.QUANTITY)-ISNULL((SELECT SUM(QQ) FROM(
                                SELECT (SELECT SUM(Quantity) FROM INV1 WHERE DocEntry=Z.RefDocNum) AS QQ FROM PCH21 Z 
                                WHERE DocEntry=T7.DocEntry AND RefObjType=13
                                and LineNum<>(SELECT MAX(LineNum) FROM PCH21 WHERE DocEntry=Z.DocEntry)
                                )DDD),0) 

        
    ELSE     
    IIF(T0.NumPerMsr>1,(T0.Quantity - ISNULL(T11.Quantity,0))*T0.NumPerMsr,(T0.Quantity - ISNULL(T11.Quantity,0)))
           
    END LWST,
     CASE 
        WHEN T6.Quantity IS NOT NULL 
        THEN IIF(T6.NumPerMsr>T0.NumPerMsr,(T6.QUANTITY*T6.NumPerMsr),T6.QUANTITY)
        WHEN T7.ARCNT=1
        THEN IIF(T7.NumPerMsr>T0.NumPerMsr,(T7.QUANTITY*T7.NumPerMsr),T7.QUANTITY)
        WHEN T7.ARCNT>1 AND T7.ARLAST=1
        
        THEN IIF(T7.NumPerMsr>T0.NumPerMsr,(T7.QUANTITY*T7.NumPerMsr),T7.QUANTITY)-ISNULL((SELECT SUM(QQ) FROM(
                                SELECT (SELECT SUM(Quantity) FROM INV1 WHERE DocEntry=Z.RefDocNum) AS QQ FROM PCH21 Z 
                                WHERE DocEntry=T7.DocEntry AND RefObjType=13
                                and LineNum<>(SELECT MAX(LineNum) FROM PCH21 WHERE DocEntry=Z.DocEntry)
                                )DDD),0) 

        
    ELSE 
        (T0.Quantity - ISNULL(T11.Quantity,0))
       
    END AS 'Quantity Sold',

    T0.U_GPBD AS 'Price Before Discount',
    T0.PriceAfVAT AS 'Price After Discount',
    T0.INMPrice AS 'Price After Discount(VAT-Ex)',

    IIF(T0.ITEMCODE LIKE '%SVSVS%' ,0,
        CASE 
        WHEN T6.INMPrice IS NOT NULL 
            THEN IIF(T6.NumPerMsr>T0.NumPerMsr,(T6.INMPrice/T6.NumPerMsr),T6.INMPrice) 
            + ISNULL(((T0.INMPrice*(T0.Quantity - ISNULL(T11.Quantity,0))/T12.[SALES SUM])
            *T6.[LANDEDCOST])/(T0.Quantity - ISNULL(T11.Quantity,0)),0)    

            
        WHEN T7.INMPrice IS NOT NULL 
            THEN IIF(T7.NumPerMsr>T0.NumPerMsr,(T7.INMPrice/T7.NumPerMsr),T7.INMPrice) 
            + ISNULL(((T0.INMPrice*(T0.Quantity - ISNULL(T11.Quantity,0))/T12.[SALES SUM])
            *T7.[LANDEDCOST])/(T0.Quantity - ISNULL(T11.Quantity,0)),0)
            
        ELSE IIF(T5.NumPerMsr>T0.NumPerMsr,(T5.INMPrice/T5.NumPerMsr),T5.INMPrice) 
            + ISNULL(((T0.INMPrice*(T0.Quantity - ISNULL(T11.Quantity,0))/T12.[SALES SUM])
            *T5.[LANDEDCOST])/(T0.Quantity - ISNULL(T11.Quantity,0)),0)
        END
    )
                                               
         AS 'COST',

    
    T0.INMPrice*(
        CASE 
        WHEN T6.Quantity IS NOT NULL 
        THEN IIF(T6.NumPerMsr>T0.NumPerMsr,(T6.QUANTITY*T6.NumPerMsr),T6.QUANTITY)
        WHEN T7.ARCNT=1
        THEN IIF(T7.NumPerMsr>T0.NumPerMsr,(T7.QUANTITY*T7.NumPerMsr),T7.QUANTITY)
        WHEN T7.ARCNT>1 AND T7.ARLAST=1
        
        THEN IIF(T7.NumPerMsr>T0.NumPerMsr,(T7.QUANTITY*T7.NumPerMsr),T7.QUANTITY)-ISNULL((SELECT SUM(QQ) FROM(
                                SELECT (SELECT SUM(Quantity) FROM INV1 WHERE DocEntry=Z.RefDocNum) AS QQ FROM PCH21 Z 
                                WHERE DocEntry=T7.DocEntry AND RefObjType=13
                                and LineNum<>(SELECT MAX(LineNum) FROM PCH21 WHERE DocEntry=Z.DocEntry)
                                )DDD),0) 
       
        ELSE 
            (T0.Quantity - ISNULL(T11.Quantity,0))
        
        END)
    AS 'Total Sales'
    ,NULL AS FreeTxt
    FROM INV1 T0
    INNER JOIN OINV T3 ON T0.DocEntry = T3.DocNum
    INNER JOIN dbo.[@SALESAGENT] T4 ON T4.Code=T3.U_SalesAgent 
    --VIA PO
    LEFT JOIN (	
                SELECT TB.NumPerMsr,TA.DocEntry,TC.DocNum,TB.BaseEntry,TC.TaxDate ,TB.Quantity,TB.ItemCode,TB.WhsCode,TB.INMPRICE,TB.DocEntry AS 'PO_#','PO'AS 'RTYPE'
                 
                ,0 AS 'LANDEDCOST'
                FROM INV21 TA
                INNER JOIN POR1 TB ON TA.RefDocNum=TB.DocEntry 
                INNER JOIN OPOR TC ON TB.DocEntry=TC.DocNum
                WHERE 
                TA.RefObjType=22
                AND TC.CANCELED='N'
                AND TB.TrgetEntry=0
                )AS T5
                ON T5.DocEntry=T0.DocEntry
                AND T5.ItemCode=T0.ItemCode 
    -- --VIA AP
    LEFT JOIN (
            SELECT TC.NumPerMsr, TA.DocEntry,TD.DocNum,TD.TaxDate ,TC.Quantity,TC.ItemCode,TC.WhsCode,TC.INMPRICE        ,TC.DocEntry AS 'PO_#','AP'AS 'RTYPE'            
            ,(SELECT COUNT(DISTINCT DOCENTRY) FROM PCH1 WHERE BaseType=22 AND BaseEntry=TB.DocEntry) AS APCNT
            ,(SELECT COUNT(DocEntry) FROM PCH21 WHERE RefObjType=13 AND DocEntry=TC.DocEntry) AS ARCNT 
           
            ,0 AS 'LANDEDCOST'
            FROM INV21 TA
            INNER JOIN POR1 TB ON TA.RefDocNum=TB.DocEntry 
            INNER JOIN PCH1 TC ON TB.DocEntry=TC.BaseEntry AND TC.BaseType=22
            INNER JOIN OPCH TD ON TC.DocEntry=TD.DocNum 
            WHERE 
            TA.RefObjType=22
            AND TD.CANCELED='N'
            AND TD.DOCNUM NOT IN (SELECT DOCENTRY FROM PCH21 WHERE RefObjType=13)
            ) 
            AS T6
            ON T6.DocEntry=T0.DocEntry
            AND T6.ItemCode=T0.ItemCode
    -- --VIA AP
    LEFT JOIN (
                SELECT TC.NumPerMsr,TT.RefDocNum, TT.DocEntry,TD.DocNum,TD.TaxDate ,TC.Quantity,TC.ItemCode,TC.WhsCode,TC.INMPRICE        ,TC.DocEntry AS 'PO_#','AP'AS 'RTYPE'
                ,(SELECT COUNT(DISTINCT DOCENTRY) FROM PCH1 WHERE BaseType=22 AND BaseEntry=TB.DocEntry) AS APCNT
                ,(SELECT COUNT(DocEntry) FROM PCH21 WHERE RefObjType=13 AND DocEntry=TC.DocEntry) AS ARCNT 
                ,CASE WHEN (SELECT COUNT(DocEntry) FROM PCH21 WHERE RefObjType=13 AND DocEntry=TC.DocEntry)>1 
                        AND (SELECT TOP 1 RefDocNum FROM PCH21 WHERE RefObjType=13 AND DOCENTRY=TC.DOCENTRY ORDER BY LineNum DESC) =RefDocNum
                        THEN 1
                        ELSE 0
                        END
                
                AS ARLAST
                ,0 AS 'LANDEDCOST'
                FROM  PCH21 TT
                INNER JOIN PCH1 TC ON TT.DocEntry=TC.DocEntry --AND TC.BaseType=22
                INNER JOIN OPCH TD ON TC.DocEntry=TD.DocNum 
                INNER JOIN POR1 TB ON TB.DocEntry=TC.BaseEntry AND TC.BaseType=22 
                WHERE 
                TT.RefObjType=13
                AND TD.CANCELED='N'
                ) 
                AS T7
                ON T7.RefDocNum=T0.DocEntry
                AND T7.ItemCode=T0.ItemCode


    --LANDED COST
    LEFT JOIN (SELECT  A0.DOCENTRY,A1.REFDOCNUM,A0.DocTotal-ISNULL(SUM(A3.DocTotal),0) AS 'LANDEDCOST',A2.Number 
            FROM OPCH A0
            INNER JOIN PCH21 A1 ON A0.DOCNUM=A1.DocEntry
            INNER JOIN OJDT A2 ON A0.DocNum=A2.BaseRef AND TransType=18
            LEFT JOIN (SELECT TT.BaseEntry,DocTotal
                        FROM ORPC T INNER JOIN RPC1 TT ON T.DocNum=TT.DocEntry 
                        WHERE TT.BaseType=18
                      )AS A3 ON A0.DocNum=A3.BaseEntry
            WHERE A1.RefObjType=13 AND A0.CANCELED='Z' AND A0.DocType='S'
            GROUP BY A0.DOCENTRY,A1.RefObjType,A1.REFDOCNUM,A1.DOCENTRY,A0.DocTotal,A2.Number) 
            AS T9
            ON T0.DocEntry=T9.REFDOCNUM 
    

    LEFT JOIN (SELECT A1.QUANTITY,A1.ITEMCODE,A0.RefDocNum FROM IGE21 A0
            INNER JOIN IGE1 A1 ON A0.DOCENTRY=A1.DOCENTRY
            WHERE A0.REFOBJTYPE =13) 
            AS T11 ON T11.REFDOCNUM=T0.DOCENTRY AND T11.ITEMCODE=T0.ITEMCODE

    INNER JOIN (SELECT  DOCENTRY,SUM(A2.INMPrice*(A2.Quantity-ISNULL(A3.Quantity,0))) AS 'SALES SUM' 
                FROM INV1 A2 
                LEFT JOIN (SELECT B1.QUANTITY,REFDOCNUM,B1.ItemCode FROM IGE21 B0
                            INNER JOIN IGE1 B1 ON B0.DOCENTRY=B1.DOCENTRY
                            WHERE B0.REFOBJTYPE =13)
                            AS A3 ON A2.DocEntry=A3.REFDOCNUM AND A2.ItemCode=A3.ItemCode
                GROUP BY DOCENTRY)
            AS T12 ON T0.DocEntry=T12.DocEntry

    WHERE T3.DocType = 'I' 
    AND T3.CANCELED='N'
    AND T3.ISINS='N'
    -- AND T3.DocDate BETWEEN @DATEFROM AND @DATETO
    AND T3.U_BO_DRS ='Y' OR T3.U_BO_DSDD ='Y' OR T3.U_BO_DSDV ='Y' OR T3.U_BO_DSPD ='Y'  

    UNION ALL --DS PO=AP QTY BALANCE

    SELECT DISTINCT 
    T4.Name AS C,
    CASE 
        WHEN T3.isIns ='Y' 
        THEN 'AR RESERVE' 
        ELSE 'AR INVOICE' 
    END AS 'TYPE',
    
    T0.DocEntry AS 'Transaction#',
    T3.DocDate AS 'Posting Date',
    Month(T3.DocDate) AS 'Month',
    CONCAT(Month(T3.DocDate),'G' )AS 'GRSMonth',
    CONCAT(Month(T3.DocDate),'Q' )AS 'QMonth',
    
    
    T3.CardName AS 'Customer',
   
   
    
    
    T0.ItemCode AS 'Item Code',
    T0.unitMsr AS 'unit',
    T0.UOMCODE,
    T0.NumPerMsr,
    
    
 
    
    IIF(T0.NumPerMsr>1,T5.TTLAPQTY*T0.NumPerMsr,T5.TTLAPQTY) LWST,
    T5.TTLAPQTY 
     AS 'Quantity Sold',

    T0.U_GPBD AS 'Price Before Discount',
    T0.PriceAfVAT AS 'Price After Discount',
    T0.INMPrice AS 'Price After Discount(VAT-Ex)',
        
    ISNULL( IIF(T5.NumPerMsr>T0.NumPerMsr,(T5.INMPrice/T5.NumPerMsr),T5.INMPrice) + ISNULL(((T0.INMPrice*(T0.Quantity - ISNULL(T11.Quantity,0))/T12.[SALES SUM])*T5.[LANDEDCOST])/T0.Quantity - ISNULL(T11.Quantity,0),0)
    ,0
    )
    AS 'COST',

    
    T0.INMPrice*T5.TTLAPQTY 
    AS 'Total Sales'
    ,NULL AS FreeTxt
    FROM INV1 T0 
    INNER JOIN OINV T3 ON T0.DocEntry = T3.DocNum
    INNER JOIN dbo.[@SALESAGENT] T4 ON T4.Code=T3.U_SalesAgent 
    --VIA PO
    LEFT JOIN (	
                SELECT TB.NumPerMsr,TA.DocEntry,TC.DocNum,TB.BaseEntry,TC.TaxDate ,TB.Quantity,TB.ItemCode,TB.WhsCode,TB.INMPRICE,TB.DocEntry AS 'PO_#','PO'AS 'RTYPE'               
                ,0 AS 'LANDEDCOST'
                ,TD.Quantity AS APQ
                
                ,TB.QUANTITY                
                -(ISNULL((SELECT SUM(SB.QUANTITY) AS APQTY FROM OPCH SA
                    INNER JOIN PCH1 SB ON SA.DocNum=SB.DocEntry
                    WHERE SA.CANCELED='N'
                    AND SB.BASEREF=TB.DocEntry AND SB.BaseType=TB.ObjType AND SB.ItemCode=TB.ItemCode),0) 
                +ISNULL((SELECT  SUM(A1.QUANTITY )FROM IGE21 A0
                    INNER JOIN IGE1 A1 ON A0.DOCENTRY=A1.DOCENTRY AND A1.AcctCode LIKE '%CS010%'
                    WHERE A0.REFOBJTYPE =13 AND RefDocNum = TA.DocEntry),0))  
                AS 'TTLAPQTY' 

                ,CASE WHEN TC.DocStatus='O'
                THEN 1
                WHEN TC.DocStatus<>'O' AND (SELECT COUNT(DocEntry) FROM RIN1 WHERE BaseEntry=TA.DocEntry AND BaseType=13 )>0
                THEN 1
                ELSE 0
                END AS X

                FROM INV21 TA
                INNER JOIN POR1 TB ON TA.RefDocNum=TB.DocEntry 
                INNER JOIN OPOR TC ON TB.DocEntry=TC.DocNum
                INNER JOIN (SELECT AA.BASEREF,AA.BASETYPE, AA.DocEntry,AA.ItemCode,AA.Quantity,AA.ObjType FROM PCH1 AA INNER JOIN OPCH AB ON AA.DocEntry=AB.DocNum WHERE AB.CANCELED='N' AND AA.BaseType=22)
                AS TD ON TD.BASEREF=TB.DOCENTRY AND TD.BASETYPE=TB.ObjType
                
                WHERE 
                TA.RefObjType=22
                AND TC.CANCELED='N'
                -- AND TC.DocStatus='O'
                )AS T5
                ON T5.DocEntry=T0.DocEntry
                AND T5.ItemCode=T0.ItemCode 
                AND T5.TTLAPQTY >0
                AND T5.X=1

    LEFT JOIN (SELECT  A0.DOCENTRY,A1.REFDOCNUM,A0.DocTotal-ISNULL(SUM(A3.DocTotal),0) AS 'LANDEDCOST',A2.Number FROM OPCH A0
            INNER JOIN PCH21 A1 ON A0.DOCNUM=A1.DocEntry
            INNER JOIN OJDT A2 ON A0.DocNum=A2.BaseRef AND TransType=18
            LEFT JOIN (SELECT TT.BaseEntry,DocTotal
                FROM ORPC T INNER JOIN RPC1 TT ON T.DocNum=TT.DocEntry 
                WHERE TT.BaseType=18
                )AS A3 ON A0.DocNum=A3.BaseEntry
            WHERE A1.RefObjType=13 AND A0.CANCELED='Z' AND A0.DocType='S'
            GROUP BY A0.DOCENTRY,A1.RefObjType,A1.REFDOCNUM,A1.DOCENTRY,A0.DocTotal,A2.Number) 
            AS T9
            ON T0.DocEntry=T9.REFDOCNUM 
   
    LEFT JOIN (SELECT A1.QUANTITY,A1.ITEMCODE,A0.RefDocNum FROM IGE21 A0
            INNER JOIN IGE1 A1 ON A0.DOCENTRY=A1.DOCENTRY
            WHERE A0.REFOBJTYPE =13) 
            AS T11 ON T11.REFDOCNUM=T0.DOCENTRY AND T11.ITEMCODE=T0.ITEMCODE

    INNER JOIN (SELECT  DOCENTRY,SUM(A2.INMPrice*(A2.Quantity-ISNULL(A3.Quantity,0))) AS 'SALES SUM' 
                FROM INV1 A2 
                LEFT JOIN (SELECT B1.QUANTITY,REFDOCNUM,B1.ItemCode FROM IGE21 B0
                            INNER JOIN IGE1 B1 ON B0.DOCENTRY=B1.DOCENTRY
                            WHERE B0.REFOBJTYPE =13)
                            AS A3 ON A2.DocEntry=A3.REFDOCNUM AND A2.ItemCode=A3.ItemCode
                GROUP BY DOCENTRY)
            AS T12 ON T0.DocEntry=T12.DocEntry

    WHERE T3.DocType = 'I' 
    AND T3.CANCELED='N'
    AND T3.ISINS='N'
    -- AND T3.DocDate BETWEEN @DATEFROM AND @DATETO
    AND T3.U_BO_DRS ='Y' OR T3.U_BO_DSDD ='Y' OR T3.U_BO_DSDV ='Y' OR T3.U_BO_DSPD ='Y'  


     UNION ALL --DS AP EXCESS TO PO

    SELECT DISTINCT 
    T4.Name AS C,
    CASE 
        WHEN T3.isIns ='Y' 
        THEN 'AR RESERVE' 
        ELSE 'AR INVOICE' 
    END AS 'TYPE',
    
    T0.DocEntry AS 'Transaction#',
    T3.DocDate AS 'Posting Date',
    Month(T3.DocDate) AS 'Month',
    CONCAT(Month(T3.DocDate),'G' )AS 'GRSMonth',
    CONCAT(Month(T3.DocDate),'Q' )AS 'QMonth',
    
    
    T3.CardName AS 'Customer',
    
   
    
    
    T0.ItemCode AS 'Item Code',
    T0.unitMsr AS 'unit',
    T0.UOMCODE,
    T0.NumPerMsr,
     
    
    IIF(T0.NumPerMsr>1,T5.TTLAPQTY*T0.NumPerMsr,T5.TTLAPQTY) LWST,
    T5.TTLAPQTY 
     AS 'Quantity Sold',

    T0.U_GPBD AS 'Price Before Discount',
    T0.PriceAfVAT AS 'Price After Discount',
    T0.INMPrice AS 'Price After Discount(VAT-Ex)',
        
    ISNULL( IIF(T5.NumPerMsr>T0.NumPerMsr,(T5.INMPrice/T5.NumPerMsr),T5.INMPrice) + ISNULL(((T0.INMPrice*(T0.Quantity - ISNULL(T11.Quantity,0))/T12.[SALES SUM])*T5.[LANDEDCOST])/T0.Quantity - ISNULL(T11.Quantity,0),0)
    ,0
    )
    AS 'COST',

    
    T0.INMPrice*T5.TTLAPQTY 
    AS 'Total Sales'
    ,NULL AS FreeTxt
    FROM INV1 T0
    INNER JOIN OINV T3 ON T0.DocEntry = T3.DocNum
    INNER JOIN dbo.[@SALESAGENT] T4 ON T4.Code=T3.U_SalesAgent 
    --VIA PO
    LEFT JOIN (	
                SELECT TB.NumPerMsr,TA.DocEntry,TC.DocNum,TB.BaseEntry,TC.TaxDate ,TB.Quantity,TB.ItemCode,TB.WhsCode,TB.INMPRICE,TB.DocEntry AS 'PO_#','PO'AS 'RTYPE'               
                ,0 AS 'LANDEDCOST'
                ,TD.Quantity AS APQ
                
                ,TB.QUANTITY
                
                -(ISNULL((SELECT SUM(SB.QUANTITY) AS APQTY FROM OPCH SA
                    INNER JOIN PCH1 SB ON SA.DocNum=SB.DocEntry
                    WHERE SA.CANCELED='N'
                    AND SB.BASEREF=TB.DocEntry AND SB.BaseType=TB.ObjType AND SB.ItemCode=TB.ItemCode),0) 
                +ISNULL((SELECT  SUM(A1.QUANTITY )FROM IGE21 A0
                    INNER JOIN IGE1 A1 ON A0.DOCENTRY=A1.DOCENTRY AND A1.AcctCode LIKE '%CS010%'
                    WHERE A0.REFOBJTYPE =13 AND RefDocNum = TA.DocEntry),0))  
                AS 'TTLAPQTY' 

                ,CASE WHEN TC.DocStatus='O'
                THEN 1
                WHEN TC.DocStatus<>'O' AND (SELECT COUNT(DocEntry) FROM RIN1 WHERE BaseEntry=TA.DocEntry AND BaseType=13 )>0
                THEN 1
                ELSE 0
                END AS X

                FROM INV21 TA
                INNER JOIN POR1 TB ON TA.RefDocNum=TB.DocEntry 
                INNER JOIN OPOR TC ON TB.DocEntry=TC.DocNum
                INNER JOIN (SELECT AA.BASEREF,AA.BASETYPE, AA.DocEntry,AA.ItemCode,AA.Quantity,AA.ObjType FROM PCH1 AA INNER JOIN OPCH AB ON AA.DocEntry=AB.DocNum WHERE AB.CANCELED='N' AND AA.BaseType=22)
                AS TD ON TD.BASEREF=TB.DOCENTRY AND TD.BASETYPE=TB.ObjType
                
                
                WHERE 
                TA.RefObjType=22
                AND TC.CANCELED='N'
                -- AND TC.DocStatus='O'
                -- AND TB.TrgetEntry=0
                )AS T5
                ON T5.DocEntry=T0.DocEntry
                AND T5.ItemCode=T0.ItemCode 
                AND T5.TTLAPQTY <0
                AND T5.X=1
                -- AND T5.WhsCode=T0.WhsCode

    LEFT JOIN (SELECT  A0.DOCENTRY,A1.REFDOCNUM,A0.DocTotal-ISNULL(SUM(A3.DocTotal),0) AS 'LANDEDCOST',A2.Number FROM OPCH A0
            INNER JOIN PCH21 A1 ON A0.DOCNUM=A1.DocEntry
            INNER JOIN OJDT A2 ON A0.DocNum=A2.BaseRef AND TransType=18
            LEFT JOIN (SELECT TT.BaseEntry,DocTotal
                FROM ORPC T INNER JOIN RPC1 TT ON T.DocNum=TT.DocEntry 
                WHERE TT.BaseType=18
                )AS A3 ON A0.DocNum=A3.BaseEntry
            WHERE A1.RefObjType=13 AND A0.CANCELED='Z' AND A0.DocType='S'
            GROUP BY A0.DOCENTRY,A1.RefObjType,A1.REFDOCNUM,A1.DOCENTRY,A0.DocTotal,A2.Number) 
            AS T9
            ON T0.DocEntry=T9.REFDOCNUM 
    --JE

    LEFT JOIN (SELECT A1.QUANTITY,A1.ITEMCODE,A0.RefDocNum FROM IGE21 A0
            INNER JOIN IGE1 A1 ON A0.DOCENTRY=A1.DOCENTRY
            WHERE A0.REFOBJTYPE =13) 
            AS T11 ON T11.REFDOCNUM=T0.DOCENTRY AND T11.ITEMCODE=T0.ITEMCODE

    INNER JOIN (SELECT  DOCENTRY,SUM(A2.INMPrice*(A2.Quantity-ISNULL(A3.Quantity,0))) AS 'SALES SUM' 
                FROM INV1 A2 
                LEFT JOIN (SELECT B1.QUANTITY,REFDOCNUM,B1.ItemCode FROM IGE21 B0
                            INNER JOIN IGE1 B1 ON B0.DOCENTRY=B1.DOCENTRY
                            WHERE B0.REFOBJTYPE =13)
                            AS A3 ON A2.DocEntry=A3.REFDOCNUM AND A2.ItemCode=A3.ItemCode
                GROUP BY DOCENTRY)
            AS T12 ON T0.DocEntry=T12.DocEntry

    WHERE T3.DocType = 'I' 
    AND T3.CANCELED='N'
    AND T3.ISINS='N'
    -- AND T3.DocDate BETWEEN @DATEFROM AND @DATETO
    AND T3.U_BO_DRS ='Y' OR T3.U_BO_DSDD ='Y' OR T3.U_BO_DSDV ='Y' OR T3.U_BO_DSPD ='Y'  

    UNION ALL --GOODS ISSUE

    SELECT 
    T4.Name AS C,
    CASE WHEN T3.isIns ='Y' THEN 'AR RESERVE' ELSE 'AR INVOICE' END AS 'TYPE',
    
    T0.DocEntry AS 'Transaction#',
    T3.TaxDate AS 'Posting Date',
    Month(T3.TaxDate) AS 'Month',
    CONCAT(Month(T3.TaxDate),'G' )AS 'GRSMonth',
    CONCAT(Month(T3.TaxDate),'Q' )AS 'QMonth',
    
   
    T3.CardName AS 'Customer',
   
   
    
    
    T0.ItemCode AS 'Item Code',
    T0.unitMsr AS 'unit',
    T0.UOMCODE,
    T0.NumPerMsr,
    
    
    IIF(T0.NumPerMsr>1,T8.QUANTITY*T0.NumPerMsr,T8.Quantity) LWST,
    T8.Quantity 
        AS 'Quantity Sold',
    --T0.Quantity-ISNULL(T5.QTY,0) AS 'Quantity Sold',
    T0.U_GPBD AS 'Price Before Discount',
    T0.PriceAfVAT AS 'Price After Discount',
    T0.INMPrice AS 'Price After Discount(VAT-Ex)',
    T8.PRICE AS 'COST',

    T0.INMPrice * T8.Quantity AS 'Total Sales'
    ,NULL AS FreeTxt
    FROM INV1 T0

    INNER JOIN OINV T3 ON T0.DocEntry = T3.DocNum
    INNER JOIN dbo.[@SALESAGENT] T4 ON T4.Code=T3.U_SalesAgent 
    LEFT JOIN (SELECT SUM(Quantity) AS 'QTY', A0.BaseEntry , ItemCode,WHSCODE 
            FROM DLN1 A0 INNER JOIN ODLN A1 ON A0.DOCENTRY=A1.DOCNUM
            WHERE CANCELED = 'N'
            GROUP BY  A0.BaseEntry ,ItemCode,WHSCODE) AS T5  
            ON T5.BaseEntry =T0.DocEntry AND T5.ItemCode=T0.ItemCode AND T5.WHSCODE=T0.WHSCODE  

    INNER JOIN (SELECT A1.DOCENTRY,REFDOCNUM, A1.QUANTITY,A1.LINETOTAL/A1.QUANTITY AS 'PRICE',A0.IssueDate FROM IGE21 A0
            INNER JOIN IGE1 A1 ON A0.DOCENTRY=A1.DOCENTRY AND A1.AcctCode LIKE '%CS010%'
            WHERE A0.REFOBJTYPE =13) AS T8
            ON T8.REFDOCNUM=T0.DOCENTRY 
    INNER JOIN OJDT T9 ON T8.DOCENTRY=T9.BaseRef AND T9.TransType =60

    WHERE T3.DocType = 'I' 
    AND T3.CANCELED='N'
    -- AND T3.TaxDate BETWEEN @DATEFROM AND @DATETO
    AND T3.U_BO_DRS ='Y' OR T3.U_BO_DSDD ='Y' OR T3.U_BO_DSDV ='Y' OR T3.U_BO_DSPD ='Y' 

    UNION ALL  --AR CM

    SELECT 
    T4.Name AS C,
    'AR Credit Memo' AS 'TYPE',
    
    T0.DocEntry AS 'Transaction#',
    T3.TaxDate AS 'Posting Date',
    Month(T3.TaxDate) AS 'Month',
    CONCAT(Month(T3.TaxDate),'G' )AS 'GRSMonth',
    CONCAT(Month(T3.TaxDate),'Q' )AS 'QMonth',
 
  
    T3.CardName AS 'Customer',
  
   
    
    
    T0.ItemCode AS 'Item Code',
    T0.unitMsr AS 'unit',
    T0.UOMCODE,
    T0.NumPerMsr,
    
    IIF(T0.NumPerMsr>1,T0.QUANTITY*T0.NumPerMsr,T0.Quantity)*-1 LWST,
    T0.Quantity * -1 AS 'Quantity Sold',
    T0.U_GPBD AS 'Price Before Discount',
    T0.PriceAfVAT * -1 AS 'Price After Discount',
    T0.INMPrice * -1 AS 'Price After Discount(VAT-Ex)',
    CASE 
    WHEN   T3.U_BO_DRS ='Y' OR T3.U_BO_DSDD ='Y' OR T3.U_BO_DSDV ='Y' OR T3.U_BO_DSPD ='Y' 
    THEN ISNULL(T7.INMPrice,ISNULL(T8.INMPrice,ISNULL(T9.INMPrice,T10.INMPrice)))
    WHEN (SELECT isIns FROM OINV WHERE DOCNUM=T0.BaseEntry AND CANCELED='N')='Y'
        THEN 
        CASE WHEN T0.ITEMCODE IN ((SELECT ITEMCODE FROM DLN1 A0 INNER JOIN ODLN A1 ON A0.DOCENTRY=A1.DOCNUM WHERE A0.BaseEntry=T0.BaseEntry AND CANCELED='N' AND A1.DOCNUM=T0.ActBaseNum))
                THEN (SELECT TOP 1 StockValue/Quantity AS 'PRICE' FROM DLN1 WHERE BaseEntry=T0.BaseEntry AND ItemCode=T0.ItemCode)
            
                ELSE (SELECT IIF(T0.UomCode=T0.UomCode2,AvgPrice,AvgPrice*T0.NumPerMsr) FROM OITW WHERE ItemCode= T0.ItemCode AND WhsCode=T0.WhsCode)
                END
    WHEN T0.BASETYPE=203
    THEN (SELECT DISTINCT A1.StockValue/A1.Quantity FROM DPI1 A0 INNER JOIN INV1 A1 ON A0.BaseEntry=A1.BaseEntry WHERE A0.DocEntry=T0.BaseEntry AND A1.ItemCode=T0.ItemCode)
    WHEN T0.BaseType=13
    THEN (SELECT TOP 1 StockValue/Quantity FROM INV1 WHERE DocEntry=T0.BaseEntry AND  ItemCode=T0.ItemCode AND T0.UomCode=UomCode AND ObjType=T0.BaseType)
                    
    --NEW                
    WHEN (SELECT COUNT(B.DocNum) AS X FROM RIN21 A
          INNER JOIN OINV B ON A.RefDocNum=B.DocNum AND A.RefObjType=13 AND B.isIns='Y'  WHERE A.DocEntry=T0.DocEntry )>0
    
    THEN (SELECT StockValue/Quantity FROM RIN21 A
          INNER JOIN INV1 B ON A.RefDocNum=B.DocEntry AND A.RefObjType=13                    
          WHERE A.DocEntry=T0.DocEntry AND B.ItemCode=T0.ItemCode)

    END *-1 AS 'Cost',
    (T0.INMPrice * T0.Quantity) * -1 AS 'Total Sales'
    ,NULL AS FreeTxt

    from RIN1 T0

    INNER JOIN ORIN T3 ON T0.DocEntry = T3.DocNum
    INNER JOIN dbo.[@SALESAGENT] T4 ON T4.Code=T3.U_SalesAgent 
    LEFT JOIN (
            SELECT TB.NumPerMsr,TA.DocEntry,TC.DocNum,TB.BaseEntry,TC.TaxDate ,TB.Quantity,TB.ItemCode,TB.WhsCode,TB.INMPRICE,TB.DocEntry AS 'PO_#','PO'AS 'RTYPE'
            ,0 AS 'LANDEDCOST'
            FROM INV21 TA
            INNER JOIN POR1 TB ON TA.RefDocNum=TB.DocEntry 
            INNER JOIN OPOR TC ON TB.DocEntry=TC.DocNum
            WHERE 
            TA.RefObjType=22
            AND TC.CANCELED='N'
            AND TB.TrgetEntry=0
            )AS T7 
            ON T7.DOCENTRY=T0.BaseEntry AND T7.ItemCode=T0.ItemCode
    --COST DROPSHIP
    LEFT JOIN (
            SELECT TC.NumPerMsr, TA.DocEntry,TD.DocNum,TD.TaxDate ,TC.Quantity,TC.ItemCode,TC.WhsCode,TC.INMPRICE        ,TC.DocEntry AS 'PO_#','AP'AS 'RTYPE'
            
            , 0 AS 'LANDEDCOST'
            FROM INV21 TA
            INNER JOIN POR1 TB ON TA.RefDocNum=TB.DocEntry 
            INNER JOIN PCH1 TC ON TB.DocEntry=TC.BaseEntry AND TC.BaseType=22  AND TB.ItemCode=TC.ItemCode
            INNER JOIN OPCH TD ON TC.DocEntry=TD.DocNum 
            
            -- INNER JOIN PCH21 TE ON TD.DocNum=TE.DocEntry AND TE.RefObjType=14
            WHERE 
            TA.RefObjType=22
            AND TD.CANCELED='N'
            AND (SELECT COUNT(DISTINCT DocEntry) FROM PCH1 WHERE BaseRef=TB.DocEntry AND BaseType=TB.ObjType)=1
            )AS T8
            ON T8.DocEntry=T0.BASEENTRY AND T8.ItemCode=T0.ItemCode and T0.BaseType=13

    LEFT JOIN (
            SELECT TC.NumPerMsr,TA.DocEntry,TD.DocNum,TD.TaxDate ,TC.Quantity,TC.ItemCode,TC.WhsCode,TC.INMPRICE        ,TC.DocEntry AS 'PO_#','AP'AS 'RTYPE'
           
            ,0 AS 'LANDEDCOST'
            ,TA.RefDocNum
            FROM PCH21 TA
            INNER JOIN PCH1 TC ON TA.DocEntry=TC.DocEntry AND TC.BaseType=22
            INNER JOIN OPCH TD ON TC.DocEntry=TD.DocNum 
            WHERE 
            TA.RefObjType=13
            AND TD.CANCELED='N'
            AND (SELECT COUNT(DISTINCT DocEntry) FROM PCH1 WHERE BaseRef=TC.BASEREF AND BaseType=TC.BaseRef)=1
            )AS T9
            ON T9.RefDocNum=T0.BaseRef AND T9.ItemCode=T0.ItemCode and T0.BaseType=13

    LEFT JOIN (
            SELECT TC.NumPerMsr,TA.DocEntry,TD.DocNum,TD.TaxDate ,TC.Quantity,TC.ItemCode,TC.WhsCode,TC.INMPRICE        ,TC.DocEntry AS 'PO_#','AP'AS 'RTYPE'
           
            ,0 AS 'LANDEDCOST'
            ,TA.RefDocNum
            ,TA.RefObjType
            FROM PCH21 TA
            INNER JOIN PCH1 TC ON TA.DocEntry=TC.DocEntry AND TC.BaseType=22
            INNER JOIN OPCH TD ON TC.DocEntry=TD.DocNum 
            -- INNER JOIN PCH21 TE ON TD.DocNum=TE.DocEntry AND TE.RefObjType=14
            WHERE 
            TA.RefObjType=14
            AND TD.CANCELED='N'
   
            )AS T10
            ON T10.RefDocNum=T0.DocEntry AND T10.ItemCode=T0.ItemCode
            --END COST DROP SHIP


    WHERE T3.DocType = 'I' 
    AND T3.CANCELED='N'
    AND T0.BaseType<>203
    -- AND T3.TaxDate BETWEEN @DATEFROM AND @DATETO
)X 
-- WHERE [Posting Date] BETWEEN @DATEFROM AND  @DATETO
SELECT
 PDNO, ITEMNAME, SUM(qty * price) FROM (
---CHARGE
SELECT 
a.id,
a.crdate as Date,
e.dirname,
a.crinvno,
b.crprono AS PDNO, 
concat(d.brand,' ', c.size)as ITEMNAME,
b.crunit, 
b.crqty as qty ,
b.crprice as price, 
b.crcos as Cost,
a.crtotam AS TOTALSALES, 

FROM Cusdr a 
INNER JOIN Cusdri b on a.id = truncate(b.crcode,0)
INNER JOIN Size c ON b.crprono = c.pdno
INNER JOIN Brand d on c.scode = d.scode
INNER JOIN Director e ON a.Crcuno = e.ID
WHERE YEAR(a.CRDate)=2019 and MONTH(a.CRDate)>6
ORDER BY a.CRDate ASC

UNION ALL 
---CASHHHH
SELECT 
a.id,
a.cidate as Date ,a.ciname as dirname,a.ciinvno,b.ciprono AS PDNO, concat(d.brand,' ', c.size)as ITEMNAME ,b.ciunit ,b.ciqty as qty 
,b.ciprice as price, b.cicos as Cost,
a.citotam AS TOTALSALES 

FROM CUSINV a 
INNER JOIN CUSINVI b on a.id = truncate(b.cicode,0)
INNER JOIN Size c ON b.ciprono = c.pdno
INNER JOIN Brand d on c.scode = d.scode
WHERE YEAR(a.CiDate)=2019 AND MONTH(a.CiDate)>=11  AND MONTH(a.CiDate)<=12
ORDER BY A.CIDATE, A.ID ASC

UNION ALL 
--CM
SELECT 
a.id,a.srdate as Date,e.dirname,a.srinvno, b.srprono AS PDNO,concat(d.brand,' ', c.size)as ITEMNAME, 
b.srunit,b.srqty  * -1 as qty,b.srprice as price, B.SRCOS AS COST, a.srtotam * -1 AS TOTALSALES

FROM `salret` a 
INNER JOIN salreti b on a.id = truncate(b.srcode,0)
INNER JOIN Size c ON b.srprono = c.pdno
INNER JOIN Brand d on c.scode = d.scode
INNER JOIN Director e ON a.srcuno = e.ID
WHERE YEAR(a.srDate)=2019 
ORDER BY A.srDATE, A.ID ASC


select * from director  where dirname like '%homesol%'
 
WHERE YEAR(a.srDate)=2020
ORDER BY Date, ID) AS T

GROUP BY PDNO, ITEMNAME
ORDER BY SUM(TOTALSALES) DESC

''CHARGE SALES''
SELECT a.id,a.crdate,e.dirname,a.crinvno,a.crtotam,b.crqty,b.crunit,b.crprice,b.crprono,
concat(d.brand,' ', c.size)as Description
FROM Cusdr a 
INNER JOIN Cusdri b on a.id = truncate(b.crcode,0)
INNER JOIN Size c ON b.crprono = c.pdno
INNER JOIN Brand d on c.scode = d.scode
INNER JOIN Director e ON a.Crcuno = e.ID
WHERE (YEAR(a.CRDate)=2020)
ORDER BY a.CRdate,a.ID

''CASH SALES''
SELECT a.id,a.cidate,a.ciname,a.ciinvno,a.citotam,b.ciqty,b.ciunit,b.ciprice,b.ciprono,
concat(d.brand,' ', c.size)as Description
FROM CUSINV a 
INNER JOIN CUSINVI b on a.id = truncate(b.cicode,0)
INNER JOIN Size c ON b.ciprono = c.pdno
INNER JOIN Brand d on c.scode = d.scode
WHERE (YEAR(a.CiDate)=2020 AND MONTH(a.CiDate)>= 9 AND  MONTH(a.CiDate)<= 12 )
ORDER BY a.Cidate,a.ID

''PURCHASE ORDERS''
select a.`id`,a.`drdate`,a.drno,b.`cqtyc`,b.`cunit`,concat(d.brand,' ', c.size)as Description
from veninv  a
inner join code b on a.id = TRUNCATE(b.vcode,0)
inner join size c on b.`ccode` = c.pdno
inner join brand d on c.scode = d.scode
where (YEAR(a.drdate)=2020) 
order by a.`drdate`,a.id

''SALES RETURNS''
select a.id ,a.srdate,a.`srinvno`,b.`srqty`,b.`srprice`,b.`srunit`,concat(d.brand,' ', c.size)as Description
from salret a
inner join salreti b on a.id = truncate(b.srcode,0)
inner join size c on b.`srprono` = c.pdno
INNER JOIN Brand d on c.scode = d.scode
where (YEAR(a.`srdate`)=2020)
order by a.srdate


SELECT T0.ID AS DIRID, T0.DIRINIT, T0.DIRNAME, T1.ARDATE, T1.ARREF, T1.ARPONO, T1.ARAMOUNT, T1.ARPOST, T1.ARCUSDR
 FROM DIRECTOR T0
 INNER JOIN ACCREC_NEW T1 ON T0.ID = T1.ARCUNO
WHERE T0.DIRNAME LIKE '%HOME SOL%' AND T0.ID = 9902

SELECT 
t1.pdno as PDNO, t0.brand, t1.size, concat(t0.brand,' ', t1.size)as ItemDescription, t1.retail, t1.ru as UOM, t1.Soh
FROM BRAND T0
INNER JOIN SIZE T1 ON T0.SCODE = T1.SCODE


select * from checks
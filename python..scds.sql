

  scd1

update dim_cust_addr1_python_IN1542
set

[CITY]=a.[CITY],
[MUNICIPALITY]=a.[MUNICIPALITY],
[TOWN]=a.[TOWN],
[VILLAGE]=a.[VILLAGE],
[COUNTY]=a.[COUNTY],
[DISTRICT]=a.[DISTRICT]

from  
stg_dim_cust_addr1_python_IN1542 a left join dim_cust_addr1_python_IN1542 t

on a.[ADDR_ID]=t.[ADDR_ID]
where t.[ADDR_ID] is not null  and (a.CITY<>t.CITY or a.[MUNICIPALITY]<>t.[MUNICIPALITY]
                                    or a.TOWN<>t.TOWN  or a.VILLAGE<>t.VILLAGE or 
                                    a.[COUNTY]<>t.[COUNTY] or a.[DISTRICT]<>t.[DISTRICT] )
-----------------------------------------------------------
scd2  start_date end_date
    
insert into dim_CUST_ACCT_python_IN1542
 select 

a.[ACCT_ID],
a.[CUST_ID],
a.[TENANT_ORG_ID],
a.[ACCT_STS_ID],
a.[ACCT_TYPE_ID],
a.[EMAIL],
a.[VALID_CUST_IND],
a.[CRE_DT],
a.[CRE_USER],
a.[UPD_TS],
a.[UPD_USER],
a.[Start_Date],
null ,
a.[DELTD_YN]




 from stg_dim_CUST_ACCT_python_IN1542 a left join dim_CUST_ACCT_python_IN1542 b
on a.[ACCT_ID]=b.[ACCT_ID]
where (b.[ACCT_ID] IS NULL)or(b.[END_DATE] is null and a.[EMAIL]<>b.[EMAIL]  )

update dim_CUST_ACCT_python_IN1542
SET end_date=getdate()
 from stg_dim_CUST_ACCT_python_IN1542 a left join dim_CUST_ACCT_python_IN1542 b
on a.[ACCT_ID]=b.[ACCT_ID]
where (b.[END_DATE] is null and a.[EMAIL]<>b.[EMAIL]  )
-------------------------------------------------------------------------------------------------------
scd2 flag
insert into DIM_ORG_BUSINESS_UNIT_python_IN1542
SELECT
a.[ORG_ID],
a.[SRC_ORG_CD],
a.[ORG_TYPE_ID],
a.[ORG_NM],
a.[PARENT_ORG_ID],
a.[PARENT_ORG_NM],
a.[WM_RDC_NUM],
a.[WM_STORE_NUM],
a.[WM_DSTRBTR_NO],
a.[WH_IND],
a.[DSV_IND],
a.[ACTV_IND],
a.[EFF_BEGIN_DT],
a.[EFF_END_DT],
a.[CRE_DT],
1 as Is_Valid_Flag,
a.[UPD_TS]
FROM stg_DIM_ORG_BUSINESS_UNIT_python_IN1542 a LEFT join DIM_ORG_BUSINESS_UNIT_python_IN1542 t
 ON a.[ORG_ID]=t.[ORG_ID]
WHERE t.[ORG_ID] IS NULL or ((  
    
    t.ORG_NM!=a.ORG_NM or
    t.PARENT_ORG_ID!=a.PARENT_ORG_ID or
    t. PARENT_ORG_NM!=a. PARENT_ORG_NM or
    t.WM_RDC_NUM!=a.WM_RDC_NUM or
    t.WM_STORE_NUM!=a.WM_STORE_NUM  or
    t.WM_DSTRBTR_NO!=a.WM_DSTRBTR_NO ) and t.[Is_Valid_Flag]= 1)

UPDATE DIM_ORG_BUSINESS_UNIT_python_IN1542
SET Is_Valid_Flag= 0
FROM stg_DIM_ORG_BUSINESS_UNIT_python_IN1542 a left JOIN DIM_ORG_BUSINESS_UNIT_python_IN1542 t
ON a.[ORG_ID]=t.[ORG_ID]
WHERE (  
    
    t.ORG_NM!=a.ORG_NM or
    t.PARENT_ORG_ID!=a.PARENT_ORG_ID or
    t.PARENT_ORG_NM!=a. PARENT_ORG_NM or
    t.WM_RDC_NUM!=a.WM_RDC_NUM or
    t.WM_STORE_NUM!=a.WM_STORE_NUM  or
    t.WM_DSTRBTR_NO!=a.WM_DSTRBTR_NO
) and  t.[Is_Valid_Flag]= 1
------------------------------------------------------------------------------------------------
SD2 VERSION
INSERT INTO DIM_CHARGE_CATEG_PYTHON_IN1542
            SELECT s.CHARGE_CATEG_ID
            , s.TENANT_ORG_ID
            , s.CHARGE_CATEG
            , s.CHARGE_CATEG_DESC
            , s.TAX_IND,
            CASE
            WHEN t.CHARGE_CATEG_ID IS NULL THEN 1
            ELSE 1+(SELECT MAX(t.Version) FROM DIM_CHARGE_CATEG_PYTHON_IN1548 t JOIN STG_DIM_CHARGE_CATEG_PYTHON_IN1542 s ON s.CHARGE_CATEG_ID = t.CHARGE_CATEG_ID WHERE t.CHARGE_CATEG <> s.CHARGE_CATEG) END as Version
            FROM STG_DIM_CHARGE_CATEG_PYTHON_IN1548 s
            LEFT JOIN DIM_CHARGE_CATEG_PYTHON_IN1548 t
            ON t.CHARGE_CATEG_ID = s.CHARGE_CATEG_ID
            LEFT JOIN
            (SELECT CHARGE_CATEG_ID, MAX(Version) as Max_Version from DIM_CHARGE_CATEG_PYTHON_IN1548 GROUP BY CHARGE_CATEG_ID) a
            on t.CHARGE_CATEG_ID=a.CHARGE_CATEG_ID
            WHERE t.CHARGE_CATEG_ID IS NULL OR ((t.CHARGE_CATEG_ID IS NOT NULL) AND (t.CHARGE_CATEG <> s.CHARGE_CATEG ) AND 
            t.Version = a.Max_Version)
--------------------------------------------------------------------------			----------------------------------------
-	SCD 3 :2 history
--------------------------------------
INSERT INTO Dim_ORG_TYPE_LKP_python_IN1542
SELECT 
a.[ORG_TYPE_ID],
a.[ORG_TYPE_CD],
a.[ORG_TYPE_DESC],
a.[ORG_TYPE_NM],
a.[PARENT_ORG_TYPE_NM],
a.[PARENT_ORG_TYPE_CD],
a.[CRE_DT],
a.[CRE_USER],
NULL as p1,NULL AS p2
FROM stg_Dim_ORG_TYPE_LKP_python_IN1542 a  LEFT JOIN  Dim_ORG_TYPE_LKP_python_IN1542 t ON a.[ORG_TYPE_ID] = t.[ORG_TYPE_ID]
WHERE  t.[ORG_TYPE_ID] IS NULL

UPDATE Dim_ORG_TYPE_LKP_python_IN1542
SET [PARENT_ORG_TYPE_NM]=a.[PARENT_ORG_TYPE_NM] ,p1=t.[PARENT_ORG_TYPE_NM],p2=t.p1
FROM stg_Dim_ORG_TYPE_LKP_python_IN1542 a left JOIN Dim_ORG_TYPE_LKP_python_IN1542 t ON a.[ORG_TYPE_ID] = t.[ORG_TYPE_ID]
WHERE t.[PARENT_ORG_TYPE_NM] <> a.[PARENT_ORG_TYPE_NM] 
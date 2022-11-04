/*

select * into custacc.dbo.T_T_HBRS_HGAA_CU_SUBSEGM_HIST  from dbs02.custacc.dbo.T_T_HBRS_HGAA_CU_SUBSEGM_HIST 
*/

--exec [dbo].[SPReportFormirajMjesecniPrometNewSegM] null,null

Alter  PROCEDURE [dbo].[SPReportFormirajMjesecniPrometNewSegM]
 @datumOd date,
 @datumDo date

	
AS
/*

declare @datumDo datetime
declare @datumOd datetime
set @DatumDo=dateadd(day,-day(getdate()),Cast(Floor(Cast(GetDate() as float)) as datetime))
set @datumOd=DATEADD(day,-day(@DatumDo)+1,@datumDo)
*/



DECLARE @SQL NVARCHAR(1000)
DECLARE @Datum1 nvarchar(10)
DECLARE @Datum2 nvarchar(10)

If @datumDo is null set @datumDo=dateadd(day,-day(getdate()),Cast(Floor(Cast(GetDate() as float)) as datetime))
If @datumOd is null set @datumOd=DATEADD(day,-day(@DatumDo)+1,@datumDo)




set @Datum1 = replace(CONVERT( char(10),@datumOd,20),'-','')
set @Datum2 = replace(CONVERT( char(10),@datumDo,20),'-','')

--print @Datum1
--print @Datum2


--BEGIN TRY
	
	
	--SET NOCOUNT ON;
	if exists (select * from sysobjects where name='prometnewDebit' and xtype='U')
	DROP TABLE dbo.PrometnewDebit



	

	SET @SQL = 'SELECT * into prometnewDebit FROM OPENQUERY(DWPRO,
        ''select  ca.original_source_id,  count(*) as DebitBroj, sum(f.DEBIT_TRANSACTION_ENTRY_AMOUNT) as DebitIznos
          from  DWPROHRS.DWH.t_f_transaction_entry f
          left join  DWPROHRS.DWH.T_D_CUSTOMER_ACCOUNT ca on ca.customer_account_sid = f.CUSTOMER_ACCOUNT_ID 
          where TRANSACTION_ENTRY_VALUE_DATE >= ''''' + rtrim(@Datum1) + ''''' and TRANSACTION_ENTRY_VALUE_DATE <= ''''' + Rtrim(@Datum2) + '''''
          and substr(f.original_source_id,1,1) = ''''S'''' and f.DEBIT_TRANSACTION_ENTRY_AMOUNT <> 0
          group by ca.original_source_id'')'

    --print @SQL
	EXEC (@SQL)
    
   if exists (select * from sysobjects where name='prometnewCredit' and xtype='U')
	DROP TABLE dbo.prometnewCredit



	
    SET @SQL = 'SELECT * into prometnewCredit FROM OPENQUERY(DWPRO,
        ''select  ca.original_source_id,  count(*) as CreditBroj, sum(f.Credit_TRANSACTION_ENTRY_AMOUNT) as CreditIznos
          from  DWPROHRS.DWH.t_f_transaction_entry f
          left join  DWPROHRS.DWH.T_D_CUSTOMER_ACCOUNT ca on ca.customer_account_sid = f.CUSTOMER_ACCOUNT_ID 
          where TRANSACTION_ENTRY_VALUE_DATE >= ''''' + rtrim(@Datum1) + ''''' and TRANSACTION_ENTRY_VALUE_DATE <= ''''' + Rtrim(@Datum2) + '''''
          and substr(f.original_source_id,1,1) = ''''S'''' and  f.CREDIT_TRANSACTION_ENTRY_AMOUNT<> 0
          group by ca.original_source_id'')'

    --print @SQL
	EXEC (@SQL)
   
    if exists (select * from sysobjects where name='prometnew' and xtype='U')
 	DROP TABLE dbo.prometnew


    select X.Account_id,
		 isnull(C.CreditIznos,0) as CreditIznos, isnull(c.Creditbroj,0) as CreditBroj, 
		 isnull(D.DebitIznos,0)  as Debitiznos,  isnull(d.Debitbroj,0)  as DebitBroj 
		 into dbo.prometnew
		 from
		(select  distinct original_source_id as Account_Id from prometnewDebit
		union
		select  distinct original_source_id as Account_Id from prometnewCredit) X
		left Join  prometnewDebit  D on D.original_source_id = x.account_id
		left Join  prometnewCredit C on C.original_source_id = x.account_id

        Truncate table  MjesecniprometCORAcount
		insert into MjesecniprometCORAcount
		select 
			Cast(substring(@Datum1,1,4) as Int)   as Godina,
			Cast(substring(@Datum1,5,2) as Int)   as Mjesec,
			a.customer,C.jmbg as ib,c.FULL_NAME as naziv,
			c.corp_segm as segment,
			C.subsegm as Segmentacija2	,
            DS.SHORT_DESC as Segmentacija2Opis,
			c.ACCOUNT_OFFICER,
			a.rec_id as account_id,a.category,a.currency,a.Posting_Restrict,a.Inactiv_marker ,
			P.CreditIznos,
			P.CreditBroj,
			P.DebitIznos,
			P.DebitBroj
			from custacc.dbo.itaccount a 
			left join custacc.dbo.ITCUSTOMER C On c.REC_ID = a.customer
			left Join custacc.dbo.T_T_HBRS_HGAA_CU_SUBSEGM_HIST  DS on DS.subsegm = c.subsegm
			left Join dbo.prometnew  P  On p.account_id = a.rec_id
			where  a.REC_ID in ( select account_id from  dbo.prometnew  P ) 
			and a.category in ( '1100','1101','1102','1103','1104', '1105','1106','1107')
			and a.CUSTOMER in (select REC_ID from custacc.dbo.ITCUSTOMER where ret_cor = 'C')



			 

          delete from  MjesecniprometCORAcountArhiva where Godina = year(@datumOd) and mjesec = Month(@datumOd)
          insert into MjesecniprometCORAcountArhiva select * from  MjesecniprometCORAcount

		  if exists (select * from sysobjects where name='prometnewDebit' and xtype='U')
      	  DROP TABLE dbo.PrometnewDebit

		  if exists (select * from sysobjects where name='prometnewCredit' and xtype='U')
	      DROP TABLE dbo.prometnewCredit

		  if exists (select * from sysobjects where name='prometnew' and xtype='U')
 	      DROP TABLE dbo.prometnew


		  
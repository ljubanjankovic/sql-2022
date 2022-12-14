USE [Report]
GO
/****** Object:  StoredProcedure [dbo].[SPReportIstekleVIPNaknade]    Script Date: 23.9.2022. 11:01:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

-- exec [SPReporInoOdlivi]



Create PROCEDURE [dbo].[SPReportInoOdlivi]

AS
BEGIN

    DECLARE @SQL NVARCHAR(4000)
	declare @datumDo datetime
    declare @datumOd datetime
	declare @datumCOd  nvarchar(10)
	declare @datumCDo  nvarchar(10)




	set @DatumDo=dateadd(day,-day(getdate()),Cast(Floor(Cast(GetDate() as float)) as datetime))
    set @datumOd=DATEADD(day,-day(@DatumDo)+1,@datumDo)

	set @DatumCOd = Replace(CONVERT( char(10),@datumOd,20),'-','')
	set @DatumCdo = Replace(CONVERT( char(10),@datumDo,20),'-','')

	print @DatumCOD
	print @DatumCDo


	
	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'TInoOdlivi') AND type in (N'U'))
	   drop table TInoOdlivi

	SET @SQL ='select  * into TInoOdlivi from     OPENQUERY(DSPRO, ''select
	    Cast( null as nvarchar(100)) as ACCOUNT_TITLE, 
		f.ref_no,f.POPULATION_ID,f.PROCESSING_DATE,f.debit_acct_no,f.credit_acct_no,f.TRANSACTION_TYPE, Cast(f.loc_amt_CREDITED as Numeric(18,2)) as  loc_amt_CREDITED,
		f.CREDIT_CURRENCY,
		f.DEBIT_CURRENCY,
		f.e_BANK_prov,
		f.PMT_CHANNEL,
		f.inward_pay_type,
		f.E_Banking_Ref,
		f.CREDIT_AMOUNT,
		F.DEBIT_AMOUNT,
		Cast(f.LOCAL_CHARGE_AMT as Numeric(18,2)) as  LOCAL_CHARGE_AMT,
		s.COMMISSION_TYPE as COMMISSION_TYPE1,
		s.COMMISSION_AMT  as COMMISSION_AMT1,
		s2.COMMISSION_TYPE as COMMISSION_TYPE2,
		s2.COMMISSION_AMT  as COMMISSION_AMT2,
		F.BEN_OUR_CHARGES,
		f.BENEF_COUNTRY,
		f.BEN_BNK_COUNTRY,
		s.ACCT_WITH_BANK,
		s.PMT_REA_CODE_IN,
		s.PMT_REA_COD_OUT,
		f.DEBTOR_COUNTRY,
		f.ORD_BNK_COUNTRY,
		s.ORDERING_BANK,
		f.RECEIVER_BANK,
		S.REC_CORR_BANK,
		substr(s.inputter,6,8) as Inputter,
		substr(f.authoriser,6,8) as Authoriser
		from      DSPROHRS.STAGE_T24.T_T_HBRS_FUNDS_TRANSFER_HIS_DELTA f
		left join DSPROHRS.STAGE_T24.T_T_HBRS_FUNDS_TRANSFER_HIS_DELTA_DETAILS s on s.REF_No = f.ref_no and s.m = 1  and f.POPULATION_ID = s.POPULATION_ID   
		left join DSPROHRS.STAGE_T24.T_T_HBRS_FUNDS_TRANSFER_HIS_DELTA_DETAILS s2 on s2.REF_No = f.ref_no and s2.m = 2  and f.POPULATION_ID = s2.POPULATION_ID   
		
		Where f.PROCESSING_DATE  >=  ''''' +  @DatumCOd+ '''''  and
			  f.PROCESSING_DATE  <=  ''''' +  @DatumCDo+ '''''  and
			  f.RECORD_STATUS = ''''MAT''''            and
			 f.TRANSACTION_TYPE in (''''OTCT'''',''''OTCX'''')    ''  )' 
		 

	     EXEC   sp_executesql @SQL 
	
		 delete from TInoOdlivi  where ref_no+cast(POPULATION_ID as varchar(15)) not in
		 (select ref_no+cast(maxid as varchar(15)) from
		 (select ref_no,max(POPULATION_ID) as MaxID from TInoOdlivi group by ref_no) X)	
	
	
		   Update F set ACCOUNT_TITLE = a.ACCOUNT_TITLE_1
		   from TInoOdlivi F
		   left join custacc.dbo.itaccount  a on a.rec_id = f.CREDIT_ACCT_NO
	
	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'TInoOdliviZbirno') AND type in (N'U'))
	   drop table TInoOdliviZbirno	

	select f.ACCOUNT_TITLE ,f.CREDIT_ACCT_NO, count(*) as Broj into TInoOdliviZbirno
    from TInoOdlivi  F
    group by f.ACCOUNT_TITLE,f.CREDIT_ACCT_NO
	



END

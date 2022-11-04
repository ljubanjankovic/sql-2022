-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

-- exec SPReportIstekleVIPNaknade
CREATE PROCEDURE SPReportIstekleVIPNaknade
AS
BEGIN

	
	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'T24ET_T_HBRS_FT_GROUP_CONDITION_HIST') AND type in (N'U'))
	drop table T24ET_T_HBRS_FT_GROUP_CONDITION_HIST

	select  *  into T24ET_T_HBRS_FT_GROUP_CONDITION_HIST  from     OPENQUERY(DSPRO, 'select * FROM
	DSPROHRS.STAGE_EFICAZ.T_T_HBRS_FT_GROUP_CONDITION_HIST S')


	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'TIstekleVIPNaknade') AND type in (N'U'))
	drop table TIstekleVIPNaknade


  select 
  c.jmbg as JIB,
  substring(c.account_officer,3,2) as OD,
  o.naziv as NazivPoslovnice,
  c.full_name,
  FT_GROUP_CONDITION,
  RATE_SPREAD,	CHG_COMM_SEPARATE,	COM_DEFER2,	GR_COND_DATE_TO
  into TIstekleVIPNaknade
  from T24ET_T_HBRS_FT_GROUP_CONDITION_HIST G
  left join custacc.dbo.itcustomer c on c.rec_id = substring(FT_GROUP_CONDITION,3,20)
  left join custacc.dbo.od o on o.od =  substring(c.account_officer,3,2) 
  where GR_COND_DATE_TO is not null
  order by	G.GR_COND_DATE_TO

	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'T24ET_T_HBRS_FT_GROUP_CONDITION_HIST') AND type in (N'U'))
	drop table T24ET_T_HBRS_FT_GROUP_CONDITION_HIST



END
GO

USE [Report]
GO

/****** Object:  Table [dbo].[ABBL]    Script Date: 26.8.2022. 09:50:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


select * from log

CREATE TABLE [dbo].[LOG](
	[LOG_ID] [int] IDENTITY(1,1) NOT NULL,
	ReportID Char(20)  not NULL,
	LOGOpis Char(20)  not NULL,
	DatumVrijeme  [datetime] NULL )
 
GO







select * from log
truncate table log










drop table [Report]

CREATE TABLE [dbo].[Report](
	[ReportID] Char(20)  not NULL,
	[ReportNaziv] nvarchar(100) not  NULL,
	[ReportVlasnik] nvarchar(100) NULL,
	[DEPARTMENT] nvarchar(100) NULL,
	[PATHServer] nvarchar(200) NULL,
	[PATHReport] nvarchar(200) NULL,
	[NacinSlanja] nvarchar(20) NULL,
	[SPProcedura] nvarchar(50) NULL,
	[SPparametar] nvarchar(10) NULL,
	[EmailTo] nvarchar(200) NULL,
	[EmailCC] nvarchar(200) NULL,
	[EmailSubject] nvarchar(200) NULL,
	Obradjen char(1) null
) ON [PRIMARY]
GO


drop table [ReportExcel]

CREATE TABLE [dbo].[ReportExcel](
	[ReportID] Char(20)  not NULL,
	[ReportExcel] nvarchar(100) not  NULL,
	[ExcelSufix]  nvarchar(10) not  NULL,
	[Template] nvarchar(100) not  NULL,
	Obradjen char(1) null
) ON [PRIMARY]
GO


drop table [ReportTabele]

CREATE TABLE [dbo].[ReportTabele](
	[ReportID] Char(20)  not NULL,
	[ReportExcel] nvarchar(100) not  NULL,
	[Tabela] nvarchar(100) not  NULL,
	[ReportExcelTab] nvarchar(100) NULL,
	Obradjen char(1) null
) ON [PRIMARY]
GO


select * from Report
select * from ReportExcel
select * from ReportTabele

Update report set Obradjen = null where ReportNaziv = 'MjesecniPrometNewSegM'


truncate table Report

insert into Report values( '2183', 'IstekleVIPNaknade', 'Trakilović Ljilja', 'Operacije','\\dbs33000sv02\Radni\Mjesecni',null                                            ,'email'     ,'SPReportIstekleVIPNaknade',null,'Svjetlana.Lukic@addiko.com;smiljana.talajic@addiko.com;zorka.blazevic@addiko.com' ,'ljiljana.trakilovic@addiko.com;ljuban.jankovic@addiko.com','Istekle VIP naknade na dan ',null)
insert into Report values( 'X001', 'InoOdlivi'        , 'Trakilović Ljilja', 'Operacije','\\dbs33000sv02\Radni\Mjesecni','\\fileserver02\projekti\Gotovinske transakcije','FileServer','SPReportInoOdlivi'        ,null,  null                      ,null                         ,null                         ,null)

insert into Report values( 'X002', 'MjesecniPrometNewSegM'        , 'Đurić Željko',      'Kontroling','\\dbs33000sv02\Radni\Mjesecni',null,                              'email',      'SPReportFormirajMjesecniPrometNewSegM','null,null', 'zeljko.djuric@addiko.com;bojan.sikora@addiko.com','ljuban.jankovic@addiko.com','Mjesečno promet pravnih lica za period',null)


--'ljiljana.trakilovic@addiko.com;Svjetlana.Lukic@addiko.com;smiljana.talajic@addiko.com;zorka.blazevic@addiko.com' )


insert into ReportExcel values( '2183','IstekleVipNaknade'           , 'DATE','Template\Template-IstekleVipNaknade.xlsx', null)
insert into ReportExcel values( 'X001','InoOdlivi'                   , 'MONTH','Template\Template-InoOdlivi.xlsx', null)
insert into ReportExcel values( 'X002','MjesecniPrometPravnaAccount' , 'MONTH','Template\Template-MjesecniPrometPravnaAccount.xlsx', null)


insert into ReportTabele values( '2183','IstekleVipNaknade','TIstekleVipNaknade', 'IstekleVipNaknade',null)
insert into ReportTabele values( 'X001','InoOdlivi','TInoOdlivi', 'InoOdlivi',null)
insert into ReportTabele values( 'X001','InoOdlivi'                  ,'TInoOdliviZbirno'       , 'InoOdliviZbirno',null)
insert into ReportTabele values( 'X002','MjesecniPrometPravnaAccount','MjesecniprometCORAcount', 'MjesecniprometCORAcount',null)




truncate table MjesecniprometCORAcount

delete  from  MjesecniprometCORAcount where account_id <> '10120403'

delete  from Tisteklevipnaknade where JIB <> '4400854240008'

delete  from [dbo].[TInoOdlivi] where REF_NO <> 'FT22237LY6YT;1'
select * from [TInoOdlivi]

sp_help MjesecniprometCORAcount

insert into  
                            delete from
							OPENROWSET('Microsoft.ACE.OLEDB.12.0',
							'Excel 12.0;Database=\\dbs33000sv02\Radni\Mjesecni\MjesecniPrometPravnaAccount202208.xlsx;''zisuser'';''bankuser'';HDR=YES',
							'SELECT * FROM [MjesecniprometCORAcount$]')
							where account_id = '9999999999'
10120567



select * from Report where ReportID = '2183'


sp_help Report

EmailTo
ljiljana.trakilovic@addiko.com;Svjetlana.Lukic@addiko.com;smiljana.talajic@addiko.com;zorka.blazevic@addiko.com
ljiljana.trakilovic@addiko.com;Svjetlana.Lukic@addiko.com;smiljana.talajic@addiko.com;zorka.blazevic@addiko.com
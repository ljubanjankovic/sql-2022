USE [Report]
GO
/****** Object:  StoredProcedure [dbo].[SPReport]    Script Date: 29.9.2022. 11:43:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

--exec SPReport

--Use report

ALTER PROCEDURE [dbo].[SPReport]
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @CmdShell  VARCHAR(2000)
	declare @query     varchar(max)
	declare @fileattachments varchar(200)

	declare @ReportNaziv  varchar(100)
	declare @ReportId     varchar(20)
	declare @PathServer   varchar(100)
	declare @PathReport   varchar(100)

    declare @SPProcedura  varchar(100)
	declare @EmailTo      varchar(100)
	declare @EmailCC      varchar(100)
	declare @EmailSubject varchar(100)
	declare @NacinSlanja  varchar(20)


	declare @Tabela     varchar(100)
	declare @Template   varchar(100)
	declare @ExcelSufix varchar(100)
	declare @ReportExcel varchar(100)
	declare @ReportExcelTab varchar(100)

	declare @filepathtemp varchar(250)
    declare @filepathTarget varchar(250)
	declare @filepathReport varchar(250)
	
	declare @datumDo datetime
	declare @datumOd datetime
	declare @Period  nvarchar(25)
	declare @Mjesec  nvarchar(10)
	
	
	set @DatumDo=dateadd(day,-day(getdate()),Cast(Floor(Cast(GetDate() as float)) as datetime))
	set @datumOd=DATEADD(day,-day(@DatumDo)+1,@datumDo)
	
	set @Mjesec = substring(Replace(CONVERT( char(10),@datumDo,20),'-',''),1,6)
	set @Period = CONVERT( char(10), @datumOd,104) + ' do ' + CONVERT( char(10) ,@datumDo,104) 

	print @Mjesec
	print @Period
	
	

	--select * from ReportTabele



	
	update Report  set Obradjen = null
	update ReportTabele  set Obradjen = null
	update ReportExcel   set Obradjen = null
	while  ((select count(*) from Report  where obradjen is null) <> 0 )
    Begin
	     set @ReportId      = ( select top 1 ReportId    from Report  where obradjen is null order by ReportID )
		 set @ReportNaziv   = ( select ReportNaziv  from Report  where ReportID = @ReportID  )
		 set @PathServer    = ( select PATHServer   from Report  where ReportID = @ReportId )
		 set @PathReport    = ( select PATHReport   from Report  where ReportID = @ReportId )
		 set @SPProcedura   = ( select SPProcedura  from Report  where ReportID = @ReportId ) + ' ' + ( select isnull(SPParametar,'')  from Report  where ReportID = @ReportId ) 
		 set @EmailTo       = ( select EmailTo      from Report  where ReportID = @ReportId )
		 set @EmailCC       = ( select EmailCC      from Report  where ReportID = @ReportId )
		 set @NacinSlanja   = ( select NacinSlanja  from Report  where ReportID = @ReportId )
		 --set @EmailSubject  = ( select EmailSubject from Report  where ReportID = @ReportId ) +  convert( char(10) , GETDATE(),104)
		 Insert into [dbo].[LOG] values ( @ReportId ,'Start' ,GETDATE() )
		 print @ReportNaziv
		 print @SPProcedura
		 exec (@SPProcedura)
		 update ReportExcel  set Obradjen = null where ReportID = @ReportID  
		 while  ((select count(*) from ReportExcel  where obradjen is null  and ReportID = @ReportID     ) <> 0 )
         Begin
			 set @ReportExcel     = ( select top 1 ReportExcel    from ReportExcel  where ReportID = @ReportID order by ReportExcel )
			 set @Template        = ( select Template             from ReportExcel  where ReportID = @ReportID and ReportExcel  = @ReportExcel )
			 set @ExcelSufix      = ( select ExcelSufix           from ReportExcel  where ReportID = @ReportID and ReportExcel  = @ReportExcel )
			 

			 set @filepathtemp   = @PathServer + '\' + @Template
			 
			 If @ExcelSufix = 'DATE'  Begin
			    set @filepathTarget = @PathServer + '\' + @ReportExcel  + convert( char(10), GETDATE() ,102) +'.xlsx'
				set @EmailSubject  = ( select EmailSubject from Report  where ReportID = @ReportId ) +  convert( char(10) , GETDATE(),104)
			 end
			 If @ExcelSufix = 'MONTH' begin
			    set @filepathTarget = @PathServer + '\' + @ReportExcel  +  @Mjesec  +'.xlsx'
				set @EmailSubject  = ( select EmailSubject from Report  where ReportID = @ReportId ) + ' ' +  @Period

             end
			 
			  If @NacinSlanja = 'FileServer' 
			     set @filepathReport = @PathReport 
			 
			 Set @CmdShell = 'copy  "'+@filepathtemp+'"  "'+@filepathTarget+'"  '
			 print @CmdShell
			 EXEC master..xp_cmdshell @CmdShell




			 update ReportTabele  set Obradjen = null where ReportID = @ReportID and ReportExcel = @ReportExcel

			 while  ((select count(*) from ReportTabele  where obradjen is null  and ReportID = @ReportID  and ReportExcel = @ReportExcel   ) <> 0 )
			 Begin
				set @Tabela          = ( select top 1 Tabela   from ReportTabele  where obradjen is null  and ReportID = @ReportID order by Tabela )
				set @ReportExcelTab  = ( select ReportExcelTab from ReportTabele  where ReportID = @ReportID and Tabela = @Tabela )




				set @query=' insert into  
							OPENROWSET(''Microsoft.ACE.OLEDB.12.0'',
							''Excel 12.0;Database='+@filepathTarget+';''''zisuser'''';''''bankuser'''';HDR=YES'',
							''SELECT * FROM ['+@ReportExcelTab+'$]'')
							select *  from '+@Tabela
							
							

				print @query
			    exec (@query)
				update  ReportTabele set obradjen = 'D'  where ReportID = @ReportID  and ReportExcel = @ReportExcel and Tabela = @Tabela
			 end
		     
			 --set @fileattachments = isnull(@fileattachments,'')  + @filepathTarget

			 set @fileattachments = Case
									   when @fileattachments is null then @filepathTarget
									   else  @fileattachments + ';'  + @filepathTarget
									End

			 
			 
			 update  ReportExcel set obradjen = 'D'  where ReportID = @ReportID  and ReportExcel = @ReportExcel 
		 end
		 --- slanje mejla ili kopiranje excela
		 
		 IF @NacinSlanja = 'email' Begin
			 if ( @@error = 0 ) Begin
				 EXEC msdb.dbo.sp_send_dbmail
						@profile_name = 'Mail',
						@recipients = @EmailTo,
						@copy_recipients = @Emailcc,
						@subject  =  @EmailSubject,
						@file_attachments = @fileattachments
			 end	
         end

		 IF @NacinSlanja = 'FileServer' Begin
			 if ( @@error = 0 ) Begin
				
				 Set @CmdShell = 'copy  "'+@filepathTarget+'"  "'+@filepathReport+'"  '
			     print @CmdShell
			     EXEC master..xp_cmdshell @CmdShell
				
				
			 end	
         end



         Insert into [dbo].[LOG] values ( @ReportId ,'Stop' ,GETDATE() )
		 update  Report set obradjen = 'D'  where ReportID = @ReportID
		 set @fileattachments = null
		 
	
	end	 




	

END

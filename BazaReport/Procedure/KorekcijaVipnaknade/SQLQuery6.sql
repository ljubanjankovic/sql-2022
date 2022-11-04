select I.*,
x.brojpartija
 from TIstekleVIPNaknade I
left join custacc.dbo.itcustomer c on c.jmbg = i.jib
left join ( select customer , count(*) as Brojpartija from custacc.dbo.itaccount a where isnull(a.posting_restrict,'') not in ( '80','90') group by a.customer  ) X on x.customer = c.rec_id

select * from TIstekleVIPNaknade

select 
c.rec_id ,i.* from TIstekleVIPNaknade I
left join custacc.dbo.itcustomer c on c.jmbg = i.jib

)


select 
c.jmbg,
c.full_name,
a.* from custacc.dbo.itaccount a 
left join custacc.dbo.itcustomer c on c.rec_id = a.customer
where customer in (select c.rec_id from TIstekleVIPNaknade I
                   left join custacc.dbo.itcustomer c on c.jmbg = i.jib )

				  and isnull(a.posting_restrict,'') not in ( '80','90')

 where JIB = '4400690030007'


  select 
  c.jmbg as JIB,
  substring(c.account_officer,3,2) as OD,
  o.naziv as NazivPoslovnice,
  c.full_name,
  FT_GROUP_CONDITION,
  RATE_SPREAD,	CHG_COMM_SEPARATE,	COM_DEFER2,	GR_COND_DATE_TO
  into TIstekleVIPNaknadeBez
  from T24ET_T_HBRS_FT_GROUP_CONDITION_HIST G
  left join custacc.dbo.itcustomer c on c.rec_id = substring(FT_GROUP_CONDITION,3,20)
  left join custacc.dbo.od o on o.od =  substring(c.account_officer,3,2) 
  where GR_COND_DATE_TO is  null
  order by	G.GR_COND_DATE_TO



  select I.*,
x.brojpartija
 from TIstekleVIPNaknadebez I
left join custacc.dbo.itcustomer c on c.jmbg = i.jib
left join ( select customer , count(*) as Brojpartija from custacc.dbo.itaccount a where isnull(a.posting_restrict,'') not in ( '80','90') group by a.customer  ) X on x.customer = c.rec_id



select 
c.jmbg,
c.full_name,
a.* from custacc.dbo.itaccount a 
left join custacc.dbo.itcustomer c on c.rec_id = a.customer
where customer in (select c.rec_id from TIstekleVIPNaknadebez I
                   left join custacc.dbo.itcustomer c on c.jmbg = i.jib )

				  and isnull(a.posting_restrict,'') not in ( '80','90')
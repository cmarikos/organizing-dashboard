select
cc.vanid,
cc.contacttypename,
cc.resultshortname,
cc.utc_datecanvassed,
extract(year from cc.utc_datecanvassed) as year,
cc.canvassedby,
u.organizer_user


from `proj-tmc-mem-mvp.everyaction_cleaned.cln_everyaction__contactscontacts` as cc

left join `proj-tmc-mem-mvp.everyaction_enhanced.enh_everyaction__contacts` as ec
  on cc.vanid = ec.vanid

left join `prod-organize-arizon-4e1c0a83.organizing_view.ea_publicuser_organizers` as u
  on cc.canvassedby = u.canvassedby

where cc.contacttypename <> 'No Actual Contact'
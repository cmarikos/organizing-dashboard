-- supports distinct events extract in the big nasty connected sheet: https://docs.google.com/spreadsheets/d/1VJ9Q_i2ehaiS3U7g_1ElCt-cZfryS9I0eccgqRl5XJg/edit?gid=1510850427#gid=1510850427
CREATE OR REPLACE VIEW `prod-organize-arizon-4e1c0a83.organizing_view.distinctevents011025` as (

SELECT DISTINCT
  e.eventid,
  e.event_name,
  e.event_location_city,
  e.start_date,

FROM
  `proj-tmc-mem-mvp.everyaction_enhanced.enh_everyaction__events` AS e

LEFT JOIN `proj-tmc-mem-mvp.everyaction_cleaned.cln_everyaction__eventscodes` AS ec
  ON e.eventid = ec.eventid

LEFT JOIN `proj-tmc-mem-mvp.everyaction_cleaned.cln_everyaction__codes` AS c
  ON ec.codeid = c.codeid

WHERE

EXTRACT(YEAR FROM start_date) = 2025
  AND c.codename = 'Organizing'
ORDER BY
  start_date
)
CREATE OR REPLACE VIEW `prod-organize-arizon-4e1c0a83.organizing_view.new_volunteers` AS(
WITH volunteers AS(
SELECT DISTINCT
e.vanid
, c.codename AS organizer
, MIN(EXTRACT(MONTH FROM e.start_date)) AS first_month
FROM `proj-tmc-mem-mvp.everyaction_enhanced.enh_everyaction__events` AS e

LEFT JOIN `proj-tmc-mem-mvp.everyaction_cleaned.cln_everyaction__eventscodes` AS ec
  ON e.eventid = ec.eventid 

LEFT JOIN `proj-tmc-mem-mvp.everyaction_cleaned.cln_everyaction__codes` AS c
  ON ec.codeid = c.codeid

WHERE e.role = 'Volunteer'
AND e.final_status = 'Completed'
AND c.codename IN ('Jhanitzel Bogarin','Leny Rivera','Tara Clayton','Hector Castellanos','Elyanna Juarez')

GROUP BY 1,2
ORDER BY 3
)

, attendees AS(
SELECT DISTINCT
e.vanid
, c.codename AS organizer
, MIN(EXTRACT(MONTH FROM e.start_date)) AS first_month
FROM `proj-tmc-mem-mvp.everyaction_enhanced.enh_everyaction__events` AS e

LEFT JOIN `proj-tmc-mem-mvp.everyaction_cleaned.cln_everyaction__eventscodes` AS ec
  ON e.eventid = ec.eventid 

LEFT JOIN `proj-tmc-mem-mvp.everyaction_cleaned.cln_everyaction__codes` AS c
  ON ec.codeid = c.codeid

WHERE e.role = 'Attendee'
and e.final_status = 'Completed'
AND c.codename IN ('Jhanitzel Bogarin','Leny Rivera','Tara Clayton','Hector Castellanos','Elyanna Juarez')

GROUP BY 1,2
ORDER BY 3
)

SELECT
a.vanid
, a.organizer
, a.first_month AS first_event
, v.first_month AS first_vol
FROM attendees AS a


LEFT JOIN volunteers AS v
  ON a.vanid = v.vanid

WHERE a.organizer IS NOT NULL
)

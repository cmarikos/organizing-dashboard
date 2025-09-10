CREATE OR REPLACE VIEW `prod-organize-arizon-4e1c0a83.organizing_view.volunteershifts02182025` AS (
WITH event_signups AS(
SELECT 
e.eventid,
e.vanid,
e.event_name,
e.eventsignupid,
e.role,
e.status,
e.start_date,
EXTRACT(month FROM e.end_date) AS month,


FROM `proj-tmc-mem-mvp.everyaction_enhanced.enh_everyaction__events` AS e

LEFT JOIN `proj-tmc-mem-mvp.everyaction_cleaned.cln_everyaction__eventscodes` AS ec
  ON e.eventid = ec.eventid 

LEFT JOIN `proj-tmc-mem-mvp.everyaction_cleaned.cln_everyaction__codes` AS c
  ON ec.codeid = c.codeid


WHERE e.start_date >= '2025-01-01'
AND c.codename = 'Organizing'
)
, counties AS(
SELECT 
e.eventsignupid,
c.codename AS county


FROM `proj-tmc-mem-mvp.everyaction_enhanced.enh_everyaction__events` AS e

LEFT JOIN `proj-tmc-mem-mvp.everyaction_cleaned.cln_everyaction__eventscodes` AS ec
  ON e.eventid = ec.eventid 

LEFT JOIN `proj-tmc-mem-mvp.everyaction_cleaned.cln_everyaction__codes` AS c
  ON ec.codeid = c.codeid


WHERE e.start_date >= '2025-01-01'
AND c.codename LIKE '%County%'
OR c.codename = 'Virtual'
)

, organizers AS(
SELECT 
e.eventsignupid,
c.codename AS Organizer


FROM `proj-tmc-mem-mvp.everyaction_enhanced.enh_everyaction__events` AS e

LEFT JOIN `proj-tmc-mem-mvp.everyaction_cleaned.cln_everyaction__eventscodes` AS ec
  ON e.eventid = ec.eventid 

LEFT JOIN `proj-tmc-mem-mvp.everyaction_cleaned.cln_everyaction__codes` AS c
  ON ec.codeid = c.codeid


WHERE e.start_date >= '2025-01-01'
AND c.codename IN ('Jhanitzel Bogarin','Lily Hernandez','Tara Clayton','Hector Castellanos','Elyanna Juarez')
)

SELECT 

es.*
, c.county
, o.organizer
FROM event_signups AS es

LEFT JOIN counties AS c
  ON es.eventsignupid = c.eventsignupid

LEFT JOIN organizers AS o
  ON es.eventsignupid = o.eventsignupid
)
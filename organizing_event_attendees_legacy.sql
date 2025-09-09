CREATE OR REPLACE VIEW `prod-organize-arizon-4e1c0a83.organizing_view.organizing_event_attendees` AS (
WITH attendees AS(
SELECT
e.eventid
, e.event_name
, e.start_date
, COUNT(DISTINCT e.vanid) AS attendees
FROM `proj-tmc-mem-mvp.everyaction_enhanced.enh_everyaction__events` AS e

LEFT JOIN `proj-tmc-mem-mvp.everyaction_cleaned.cln_everyaction__eventscodes` AS ec
  ON e.eventid = ec.eventid 

LEFT JOIN `proj-tmc-mem-mvp.everyaction_cleaned.cln_everyaction__codes` AS c
  ON ec.codeid = c.codeid

WHERE e.final_status = 'Completed'

GROUP BY 1,2,3
)

, volunteers AS(
SELECT
e.eventid
, e.event_name
, e.start_date
, COUNT(DISTINCT e.vanid) AS volunteers
FROM `proj-tmc-mem-mvp.everyaction_enhanced.enh_everyaction__events` AS e

LEFT JOIN `proj-tmc-mem-mvp.everyaction_cleaned.cln_everyaction__eventscodes` AS ec
  ON e.eventid = ec.eventid 

LEFT JOIN `proj-tmc-mem-mvp.everyaction_cleaned.cln_everyaction__codes` AS c
  ON ec.codeid = c.codeid

WHERE e.role = 'Volunteer'
AND e.final_status = 'Completed'

GROUP BY 1,2,3
)

, county AS(
SELECT
e.eventid
, c.codename as county
FROM `proj-tmc-mem-mvp.everyaction_enhanced.enh_everyaction__events` AS e

LEFT JOIN `proj-tmc-mem-mvp.everyaction_cleaned.cln_everyaction__eventscodes` AS ec
  ON e.eventid = ec.eventid 

LEFT JOIN `proj-tmc-mem-mvp.everyaction_cleaned.cln_everyaction__codes` AS c
  ON ec.codeid = c.codeid

WHERE c.codename LIKE '%County'
  OR c.codename = 'Virtual'
)

, organizer AS(
SELECT
e.eventid
, c.codename as organizer
FROM `proj-tmc-mem-mvp.everyaction_enhanced.enh_everyaction__events` AS e

LEFT JOIN `proj-tmc-mem-mvp.everyaction_cleaned.cln_everyaction__eventscodes` AS ec
  ON e.eventid = ec.eventid 

LEFT JOIN `proj-tmc-mem-mvp.everyaction_cleaned.cln_everyaction__codes` AS c
  ON ec.codeid = c.codeid

WHERE c.codename IN ('Jhanitzel Bogarin','Leny Rivera','Tara Clayton','Hector Castellanos','Elyanna Juarez')
)

SELECT
a.*
, COALESCE(v.volunteers, 0) AS volunteers
, c.county
, o.organizer
FROM attendees AS a

LEFT JOIN volunteers AS v
  ON a.eventid = v.eventid

LEFT JOIN county AS c
  ON a.eventid = c.eventid

LEFT JOIN organizer AS o
  ON a.eventid = o.eventid
)
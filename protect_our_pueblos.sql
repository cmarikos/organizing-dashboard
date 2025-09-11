CREATE OR REPLACE VIEW `prod-organize-arizon-4e1c0a83.organizing_view.protect_our_pueblos` AS(
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

WHERE c.codename = 'Protect our Pueblos'
AND e.final_status = 'Completed'

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

WHERE c.codename = 'Protect our Pueblos'
  AND e.role = 'Volunteer'
  AND e.final_status = 'Completed'

GROUP BY 1,2,3
)

SELECT
a.*
, COALESCE(v.volunteers, 0) AS volunteers
, o.organizer
, c.codename
FROM attendees AS a

LEFT JOIN volunteers AS v
  ON a.eventid = v.eventid

LEFT JOIN `prod-organize-arizon-4e1c0a83.organizing_view.organizing_user_events` AS o
  ON (a.event_name = o.event_name
  AND a.start_date = o.start_date)

LEFT JOIN `proj-tmc-mem-mvp.everyaction_cleaned.cln_everyaction__eventscodes` AS ec
  ON a.eventid = ec.eventid 

LEFT JOIN `proj-tmc-mem-mvp.everyaction_cleaned.cln_everyaction__codes` AS c
  ON ec.codeid = c.codeid

WHERE c.codename LIKE '%County'
  OR c.codename = 'Virtual'

)
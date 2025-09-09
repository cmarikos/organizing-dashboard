, new_volunteers AS(
SELECT
e.eventid
, e.event_name
, MIN(EXTRACT(MONTH FROM e.start_date)) AS first_month
, COUNT(DISTINCT e.vanid) AS volunteers
FROM `proj-tmc-mem-mvp.everyaction_enhanced.enh_everyaction__events` AS e

LEFT JOIN `proj-tmc-mem-mvp.everyaction_cleaned.cln_everyaction__eventscodes` AS ec
  ON e.eventid = ec.eventid 

LEFT JOIN `proj-tmc-mem-mvp.everyaction_cleaned.cln_everyaction__codes` AS c
  ON ec.codeid = c.codeid

WHERE e.role = 'Volunteer'
AND e.final_status = 'Completed'

GROUP BY 1,2
)
-- updated to align with scheduled query 08/21/2025

CREATE OR REPLACE VIEW `prod-organize-arizon-4e1c0a83.organizing_view.organizing_event_attendees` AS (
WITH event_attendees AS (
SELECT 
eventid
, event_name
, start_date
, COUNT(vanid) AS attendees
FROM
(SELECT DISTINCT
e.eventid
, e.start_date
, e.event_name
, e.vanid
, e.role
, e.final_status
FROM `proj-tmc-mem-mvp.everyaction_enhanced.enh_everyaction__events` AS e

WHERE e.final_status = 'Completed'
AND e.start_date > '2024-12-31'
)

GROUP BY 1,2,3
ORDER BY 3 ASC

)

SELECT DISTINCT
    
    ou.event_name
    , ae.eventid
    , ou.start_date
    , ou.organizer
    , c.codename as event_location
    , ou.event_location_city
    , ae.attendees
  

  FROM `prod-organize-arizon-4e1c0a83.organizing_view.organizing_user_events` AS ou

  LEFT JOIN event_attendees AS ae
    ON (ou.event_name = ae.event_name AND ou.start_date = ae.start_date)
  
  LEFT JOIN `proj-tmc-mem-mvp.everyaction_cleaned.cln_everyaction__eventscodes` AS ec
    ON ae.eventid = ec.eventid

  LEFT JOIN `proj-tmc-mem-mvp.everyaction_cleaned.cln_everyaction__codes` AS c
    ON ec.codeid = c.codeid

  

  WHERE ou.start_date > '2024-12-31'
  AND ou.program LIKE '%Organizing%'
  AND c.codename LIKE '%County'
  OR c.codename = 'Virtual'
)
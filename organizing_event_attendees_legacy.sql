--<<<<<<< HEAD
WITH attendees AS(
SELECT
e.eventid
, e.event_name
, e.start_date
, COUNT(DISTINCT e.vanid) AS attendees
FROM `proj-tmc-mem-mvp.everyaction_enhanced.enh_everyaction__events` AS e
--=======
CREATE OR REPLACE VIEW `prod-organize-arizon-4e1c0a83.organizing_view.organizing_event_attendees` AS (
  WITH event_attendees AS (
    SELECT DISTINCT
    e.event_name||e.start_date as event_id
    , e.role
    , COUNT(e.role) as role_count
    FROM `proj-tmc-mem-mvp.everyaction_enhanced.enh_everyaction__events` AS e

    WHERE e.status = 'Completed'
    GROUP BY 1,2
    ORDER BY 1
  )
  SELECT DISTINCT
    
    ou.event_name
    , ou.start_date
    , EXTRACT(MONTH FROM ou.start_date) AS month
    , ou.organizer
    , CASE
        WHEN ou.organizer = 'Elyanna Juarez' THEN 'Pinal'
        WHEN ou.organizer = 'Hector Castellanos' THEN 'Pinal'
        WHEN ou.organizer = 'Tara Clayton' THEN 'Cochise'
        WHEN ou.organizer = 'Jhanitzel Bogarin' THEN 'Yuma'
        WHEN ou.organizer IS NULL THEN 'Virtual'
        ELSE NULL
      END AS event_location
    , ae.role
    , ae.role_count
-->>>>>>> refs/heads/main

LEFT JOIN `proj-tmc-mem-mvp.everyaction_cleaned.cln_everyaction__eventscodes` AS ec
  ON e.eventid = ec.eventid 

LEFT JOIN `proj-tmc-mem-mvp.everyaction_cleaned.cln_everyaction__codes` AS c
  ON ec.codeid = c.codeid

--<<<<<<< HEAD

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

INNER JOIN `prod-organize-arizon-4e1c0a83.organizing_view.organizing_user_events` AS o
  ON (a.event_name = o.event_name
  AND a.start_date = o.start_date)

LEFT JOIN `proj-tmc-mem-mvp.everyaction_cleaned.cln_everyaction__eventscodes` AS ec
  ON a.eventid = ec.eventid 

LEFT JOIN `proj-tmc-mem-mvp.everyaction_cleaned.cln_everyaction__codes` AS c
  ON ec.codeid = c.codeid

WHERE c.codename LIKE '%County'
  OR c.codename = 'Virtual'
--=======
  WHERE ou.start_date > '2024-12-31'
  AND ou.program LIKE '%Organizing%'
)
-->>>>>>> refs/heads/main

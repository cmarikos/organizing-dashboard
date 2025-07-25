CREATE OR REPLACE VIEW `prod-organize-arizon-4e1c0a83.organizing_view.unique_attendee_volunteers` AS (
WITH main_query AS (
  WITH unique_attendees AS (
    SELECT DISTINCT
      vanid
      , 'event_attendee' as role
    FROM `proj-tmc-mem-mvp.everyaction_enhanced.enh_everyaction__events` 
    WHERE start_date > '2024-12-31'
      AND status = 'Completed'
      AND current_status = 1
  )


  SELECT 
    c.first_name||" "||c.last_name AS full_name
    , c.phone_number
    , e.vanid
    ,a.role
    , STRING_AGG(DISTINCT CAST(e.event_name AS STRING), ', ') AS agg_events         
    , ARRAY_LENGTH(ARRAY_AGG(DISTINCT e.event_name)) AS event_count  

  FROM `proj-tmc-mem-mvp.everyaction_enhanced.enh_everyaction__events`  AS e

  LEFT JOIN unique_attendees AS a
    ON e.vanid = a.vanid

  LEFT JOIN `proj-tmc-mem-mvp.everyaction_enhanced.enh_everyaction__contacts` AS c
    ON e.vanid = c.vanid

  WHERE e.start_date > '2024-12-31'
    AND status = 'Completed'

  GROUP BY 1, 2, 3, 4
)

SELECT 
  m.full_name
  , m.phone_number
  , m.vanid
  , m.role
  , m.agg_events
  , m.event_count
  , (
      SELECT STRING_AGG(DISTINCT oe.organizer, ', ')
      FROM `prod-organize-arizon-4e1c0a83.organizing_view.organizing_user_events` AS oe
      WHERE oe.event_name IN UNNEST(SPLIT(m.agg_events, ', '))
    ) AS agg_organizers
FROM main_query AS m
)

CREATE OR REPLACE VIEW `prod-organize-arizon-4e1c0a83.organizing_view.unique_attendee_volunteers` AS (
WITH main_query AS (
  WITH unique_attendees AS (
    SELECT DISTINCT
      vanid,
      'Volunteer' AS role
    FROM `proj-tmc-mem-mvp.everyaction_enhanced.enh_everyaction__events` 
    WHERE start_date > '2024-12-31'
      AND status = 'Completed'
      AND role = 'Volunteer'
      AND current_status = 1
  )

  SELECT 
    c.first_name || " " || c.last_name AS full_name,
    e.vanid,
    a.role,
    STRING_AGG(DISTINCT e.event_name, ', ') AS agg_events,
    ARRAY_LENGTH(ARRAY_AGG(DISTINCT e.event_name)) AS event_count,

    -- NEW: how many DISTINCT events where this person was a Volunteer & Completed & current_status=1
    COUNT(DISTINCT IF(e.role = 'Volunteer'
                      AND e.status = 'Completed'
                      AND e.current_status = 1,
                      e.event_name, NULL)) AS volunteer_event_count

  FROM `proj-tmc-mem-mvp.everyaction_enhanced.enh_everyaction__events` AS e
  LEFT JOIN unique_attendees AS a
    ON e.vanid = a.vanid
  LEFT JOIN `proj-tmc-mem-mvp.everyaction_enhanced.enh_everyaction__contacts` AS c
    ON e.vanid = c.vanid
  WHERE e.start_date > '2024-12-31'
    AND status = 'Completed'
  GROUP BY 1, 2, 3
)

SELECT 
  CAST(c.utc_datecreated AS DATE) date_of_first_engagement,
  m.full_name,
  c.phone_number,
  c.email_address,
  m.vanid,
  CASE WHEN m.role IS NULL THEN "" ELSE m.role END AS is_volunteer,
  m.agg_events,
  m.event_count,
  IFNULL(m.volunteer_event_count, 0) AS volunteer_event_count,   -- ← just return it
  (
    SELECT STRING_AGG(DISTINCT oe.organizer, ', ')
    FROM `prod-organize-arizon-4e1c0a83.organizing_view.organizing_user_events` AS oe
    WHERE oe.event_name IN UNNEST(SPLIT(m.agg_events, ', '))
    AND oe.organizer IN ('Tara Clayton', 'Jhanitzel Bogarin', 'Leny Rivera')
  ) AS agg_organizers
FROM main_query AS m
LEFT JOIN `proj-tmc-mem-mvp.everyaction_enhanced.enh_everyaction__contacts` AS c
  ON m.vanid = c.vanid

ORDER BY 1 ASC
)
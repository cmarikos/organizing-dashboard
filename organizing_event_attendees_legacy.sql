CREATE OR REPLACE VIEW `prod-organize-arizon-4e1c0a83.organizing_view.organizing_event_attendees` AS (
  WITH event_attendees AS (
    SELECT DISTINCT
    e.event_name||e.start_date as event_id
    , e.role
    , COUNT(e.role) as role_count
    FROM `proj-tmc-mem-mvp.everyaction_enhanced.enh_everyaction__events` AS e
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

  FROM `prod-organize-arizon-4e1c0a83.organizing_view.organizing_user_events` AS ou

  LEFT JOIN event_attendees AS ae
    on ou.event_name||ou.start_date = ae.event_id

  WHERE ou.start_date > '2024-12-31'
  AND ou.program LIKE '%Organizing%'
)
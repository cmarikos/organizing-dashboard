CREATE OR REPLACE VIEW `prod-organize-arizon-4e1c0a83.organizing_view.organizing_goals02182025` AS (
  WITH a AS (
    SELECT
       organizer_user
      ,EXTRACT(MONTH FROM utc_datecanvassed) AS month
      ,COUNT(contacttypename) AS phone_attempts
    FROM `prod-organize-arizon-4e1c0a83.organizing_view.contacts_011325`
    WHERE contacttypename = 'Phone'
      AND utc_datecanvassed >= '2025-01-01 00:00:00 UTC'
    GROUP BY organizer_user, month
  ),
  b AS (
    SELECT
       organizer_user
      ,EXTRACT(MONTH FROM utc_datecanvassed) AS month
      ,COUNT(contacttypename) AS phone_conversations
    FROM `prod-organize-arizon-4e1c0a83.organizing_view.contacts_011325`
    WHERE contacttypename = 'Phone'
      AND utc_datecanvassed >= '2025-01-01 00:00:00 UTC'
      AND resultshortname = 'Canvassed'
    GROUP BY organizer_user, month
  ),
  c AS (
    SELECT
       organizer_user
      ,EXTRACT(MONTH FROM utc_datecanvassed) AS month
      ,COUNT(contacttypename) AS one_on_ones
    FROM `prod-organize-arizon-4e1c0a83.organizing_view.contacts_011325`
    WHERE contacttypename = 'One on One'
      AND utc_datecanvassed >= '2025-01-01 00:00:00 UTC'
      AND resultshortname = 'Canvassed'
    GROUP BY organizer_user, month
  ),
  d AS (
    SELECT
       organizer
      ,EXTRACT(MONTH FROM start_date) AS month
      ,COUNT(vanid) AS volunteer_shifts
    FROM `prod-organize-arizon-4e1c0a83.organizing_view.volunteershifts02182025`
    WHERE role = 'Volunteer'
    GROUP BY organizer, month
  ),
  e AS (
    SELECT
       organizer
      ,EXTRACT(MONTH FROM start_date) AS month
      ,COUNT(DISTINCT vanid) AS volunteers
    FROM `prod-organize-arizon-4e1c0a83.organizing_view.volunteershifts02182025`
    WHERE role = 'Volunteer'
    GROUP BY organizer, month
  )
  SELECT DISTINCT
       a.organizer_user
      ,a.month
      ,a.phone_attempts
      ,b.phone_conversations
      ,c.one_on_ones
      ,d.volunteer_shifts
      ,e.volunteers
  FROM a
  LEFT JOIN b ON a.organizer_user = b.organizer_user AND a.month = b.month
  LEFT JOIN c ON a.organizer_user = c.organizer_user AND a.month = c.month
  LEFT JOIN d ON a.organizer_user = d.organizer AND a.month = d.month
  LEFT JOIN e ON a.organizer_user = e.organizer AND a.month = e.month
  ORDER BY a.organizer_user, a.month
);

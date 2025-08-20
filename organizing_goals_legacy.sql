CREATE OR REPLACE VIEW `prod-organize-arizon-4e1c0a83.organizing_view.organizing_goals02182025` AS (
  WITH
  -- 1) lift up each contact, join to shifts to backfill organizer_user
  contact_details AS (
    SELECT
      -- if c.organizer_user is null, grab the shift organizer for that vanid & date
      COALESCE(c.organizer_user, vs.organizer) AS organizer_user,
      DATE_TRUNC(CAST(c.utc_datecanvassed AS DATE), MONTH)  AS month,
      c.contacttypename,
      c.resultshortname
    FROM
      `prod-organize-arizon-4e1c0a83.organizing_view.contacts_011325` c
    LEFT JOIN
      `prod-organize-arizon-4e1c0a83.organizing_view.volunteershifts02182025` vs
      ON c.vanid = vs.vanid
     AND DATE(c.utc_datecanvassed) = vs.start_date
    WHERE
      c.utc_datecanvassed >= '2025-01-01'
  ),

  -- 2) now aggregate all of your phone & 1-on-1 metrics off that cleaned set
  phone_metrics AS (
    SELECT
      organizer_user,
      month,
      COUNTIF(contacttypename = 'Phone')                             AS phone_attempts,
      COUNTIF(contacttypename = 'Phone'
              AND resultshortname = 'Canvassed')                    AS phone_conversations,
      COUNTIF(contacttypename = 'One on One'
              AND resultshortname = 'Canvassed')                    AS one_on_ones
    FROM
      contact_details
    GROUP BY
      organizer_user,
      month
  ),

  -- 3) same date‐truncated grouping for volunteers
  volunteer_metrics AS (
    SELECT
      organizer           AS organizer_user,
      DATE_TRUNC(start_date, MONTH)  AS month,
      COUNTIF(role = 'Volunteer')      AS volunteer_shifts,
      COUNT(DISTINCT CASE WHEN role = 'Volunteer' THEN vanid END) AS volunteers
    FROM
      `prod-organize-arizon-4e1c0a83.organizing_view.volunteershifts02182025`
    WHERE
      role = 'Volunteer'
      AND start_date >= '2025-01-01'
    GROUP BY
      organizer_user,
      month
  )

SELECT
  pm.organizer_user,
  pm.month,
  pm.phone_attempts,
  pm.phone_conversations,
  pm.one_on_ones,
  COALESCE(vm.volunteer_shifts, 0)  AS volunteer_shifts,
  COALESCE(vm.volunteers, 0)        AS volunteers
FROM
  phone_metrics pm
LEFT JOIN
  volunteer_metrics vm
ON
  pm.organizer_user = vm.organizer_user
 AND pm.month         = vm.month

WHERE pm.organizer_user IN ('Elyanna Juarez', 'Hector Castellanos','Jhanitzel Bogarin','Tara Clayton')
ORDER BY
  pm.organizer_user,
  pm.month
);

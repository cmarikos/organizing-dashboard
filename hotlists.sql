CREATE OR REPLACE VIEW `prod-organize-arizon-4e1c0a83.organizing_view.hotlist_metrics` AS (
WITH volunteer_leaders AS(
  SELECT DISTINCT
    ac.vanid
    , c.first_name||" "||c.last_name AS full_name
    , ac.activistcodename
  FROM `proj-tmc-mem-mvp.everyaction_enhanced.enh_everyaction__activist_codes` AS ac

  LEFT JOIN `proj-tmc-mem-mvp.everyaction_enhanced.enh_everyaction__contacts` AS c
    ON ac.vanid = c.vanid
  WHERE ac.activistcodename IN ('Tara Hotlist', 'Jhanitzel Hotlist','Lily Hotlist')
),

phone_conversations AS(
  SELECT
  cc.vanid
  , COUNT(cc.vanid) AS phone_conversations
  FROM `proj-tmc-mem-mvp.everyaction_enhanced.enh_everyaction__contact_attempts` AS cc
  WHERE cc.contacttypename = 'Phone'
    AND cc.resultshortname = 'Canvassed'
  GROUP BY 1
),

one_on_ones AS(
  SELECT
  cc.vanid
  , COUNT(cc.vanid) AS one_on_ones
  FROM `proj-tmc-mem-mvp.everyaction_enhanced.enh_everyaction__contact_attempts` AS cc
  WHERE cc.contacttypename = 'One on One'
    AND cc.resultshortname = 'Canvassed'
  GROUP BY 1
)

SELECT
CASE
    WHEN v.activistcodename = 'Tara Hotlist' THEN 'Tara'
    WHEN v.activistcodename = 'Jhantizel Hotlist' THEN 'Jhanitzel'
    WHEN v.activistcodename = 'Lily Hotlist' THEN 'Lily'
  ELSE NULL
END AS Organizer
, v.full_name
, p.phone_conversations
, o.one_on_ones
FROM volunteer_leaders AS v

LEFT JOIN phone_conversations AS p
  ON v.vanid = p.vanid

LEFT JOIN one_on_ones AS o
  ON v.vanid = o.vanid
)
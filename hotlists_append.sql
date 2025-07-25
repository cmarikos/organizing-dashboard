CREATE OR REPLACE VIEW `prod-organize-arizon-4e1c0a83.organizing_view.hotlist_append` AS (
SELECT
current_date AS date
, * 
FROM `prod-organize-arizon-4e1c0a83.organizing_view.hotlist_metrics`
)
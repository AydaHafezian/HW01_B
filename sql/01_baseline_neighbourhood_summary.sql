
WITH calendar_30 AS (
    
SELECT
    c.listing_id,
    AVG(c.price) FILTER (WHERE c.price IS NOT NULL) AS avg_calendar_price_30,
    AVG(CASE WHEN c.available THEN 1.0 ELSE 0.0 END) AS availability_30_rate
FROM core.calendar_day c
WHERE c.date >= CURRENT_DATE
  AND c.date < CURRENT_DATE + INTERVAL '30 days'
GROUP BY c.listing_id

),
review_counts AS (
    
SELECT
    r.listing_id,
    COUNT(*) AS total_reviews
FROM core.review r
GROUP BY r.listing_id

)
SELECT
    l.neighbourhood_id AS neighbourhood,
    COUNT(*) AS num_listings,
    AVG(l.listing_price) AS avg_price,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY l.listing_price) AS median_price,
    AVG(l.minimum_nights) AS avg_minimum_nights,
    SUM(COALESCE(rc.total_reviews, 0)) AS total_reviews,
    AVG(COALESCE(rc.total_reviews, 0)) AS reviews_per_listing,
    AVG(c30.availability_30_rate) AS availability_30_rate
FROM core.listing l
LEFT JOIN calendar_30 c30
    ON l.listing_id = c30.listing_id
LEFT JOIN review_counts rc
    ON l.listing_id = rc.listing_id
GROUP BY l.neighbourhood_id
ORDER BY num_listings DESC


# EXPLAIN Notes

## Observation 1
The baseline query performs aggregation over `core.calendar_day` for the next 30 days grouped by `listing_id`.
This step is expensive because it scans calendar records and computes both average price and availability rate before joining back to listings.

## Observation 2
The query separately aggregates `core.review` by `listing_id` to compute total review counts.
This introduces another full aggregation step over a large source table before the final neighbourhood-level aggregation.

## Observation 3
The final result is produced only after joining listing data with both aggregated CTEs and then grouping again by `neighbourhood_id`.
This means the same heavy work is repeated every time the dashboard query runs, which is inefficient for repeated BI reads.

## Baseline Runtime Summary
- Best runtime: 0.7276 seconds
- Average runtime: 1.0557 seconds

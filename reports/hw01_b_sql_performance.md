
# HW01_B - SQL Performance and Metabase

## Student Information
- Schema: `student_ayda_hafezian`
- Database: `qbc12_airbnb`

## Objective
The objective of this assignment was to build a performant neighbourhood-level summary for Airbnb data, measure baseline latency, optimize the workload using a materialized view, and prepare the result for dashboarding in Metabase.

## Source Tables
The source data was read from the `core` schema:
- `core.listing`
- `core.calendar_day`
- `core.review`

## Baseline Query
The baseline query joined listing data with:
- 30-day calendar aggregates
- review count aggregates

It produced the following fields:
- `neighbourhood`
- `num_listings`
- `avg_price`
- `median_price`
- `avg_minimum_nights`
- `total_reviews`
- `reviews_per_listing`
- `availability_30_rate`

Baseline SQL was saved to:
- `sql/01_baseline_neighbourhood_summary.sql`

## Baseline Runtime
- Best runtime: `0.7276` seconds
- Average runtime: `1.0557` seconds

The baseline execution plan was saved to:
- `reports/baseline_explain_analyze.txt`

## Optimization
A materialized view was created in my personal schema:

- `"student_ayda_hafezian".mv_airbnb_neighbourhood_summary`

This object precomputes neighbourhood-level metrics and avoids repeated heavy joins and aggregations over raw source tables.

Additional indexes were created on:
- `neighbourhood`
- `num_listings`

Optimized SQL was saved to:
- `sql/02_create_materialized_view.sql`

## Materialized View Runtime
The dashboard query read directly from the materialized view.

- Best runtime: `0.3566` seconds
- Average runtime: `0.4016` seconds

The materialized-view execution plan was saved to:
- `reports/mv_explain_analyze.txt`

## Speedup
- Speedup vs baseline (best-to-best): `2.04x`

## What Changed
Compared to the baseline query, the optimized version:
1. moved repeated aggregations into a materialized view,
2. reduced dashboard-time computation,
3. made Metabase read from a prepared analytics object instead of re-running a large multi-step query.

## Metabase Dashboard
Dashboard name:
- `QBC12 HW01 - AydaHafezian - Airbnb Ops`

Required cards:
- listings by neighbourhood
- average price by neighbourhood
- review activity by neighbourhood
- availability rate by neighbourhood
- top neighbourhoods table

Screenshot path:
- `screenshots/metabase_dashboard.png`

If a shared dashboard link is required, add it here manually after creating the dashboard in Metabase.

## Deliverables
Generated files:
- `sql/01_baseline_neighbourhood_summary.sql`
- `sql/02_create_materialized_view.sql`
- `reports/baseline_explain_analyze.txt`
- `reports/explain_notes.md`
- `reports/hw01_b_sql_performance.md`

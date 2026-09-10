# NYC Taxi Data Pipeline — Snowflake + dbt

End-to-end ELT pipeline that ingests NYC Yellow Taxi trip data into Snowflake and transforms it into an analytics-ready star schema using dbt.

## Architecture

**Layers:**
- **RAW** — raw trip data loaded as-is (VARIANT/JSON) via internal stage (`PUT` + `COPY INTO`), preserving the source schema exactly as delivered.
- **ANALYTICS_STAGING** — typed, cleaned views. Raw JSON fields are cast to proper types (timestamps, floats, integers) and renamed to snake_case.
- **ANALYTICS** — dimensional model (star schema) ready for consumption: `fct_trips` (fact table) and `dim_locations` (dimension, sourced from a versioned dbt seed).

## Tech Stack

- **Snowflake** — cloud data warehouse (compute/storage separation, internal stages, RBAC)
- **dbt Core** — transformation layer (models, sources, seeds, tests, documentation)
- **Snowflake CLI** — file staging and connection management
- **Python** — environment orchestration (`python-dotenv` for credential management)

## Key Design Decisions

- **Raw layer stores data as VARIANT, not typed columns.** Ingestion should never make modeling decisions — that's dbt's job. This keeps ingestion resilient to upstream schema changes.
- **Fact table stores foreign keys, not denormalized zone names.** `fct_trips` keeps `pickup_location_id`/`dropoff_location_id` as integers; the join to human-readable zone names happens at the BI layer, not in the transformation layer — avoiding redundant storage across millions of rows.
- **Zone lookup is a dbt seed, not an external source.** It's a small, stable reference table, versioned alongside the code that depends on it — not an ever-growing operational dataset.
- **Staging = views, Marts = tables.** Staging models are cheap, always-fresh passthroughs. Marts are materialized as physical tables since they're the layer queried directly by BI tools.

## Project Structure
nyc_taxi/
├── models/
│ ├── staging/ # typed, renamed views
│ │ ├── _sources.yml
│ │ ├── _staging__models.yml
│ │ ├── stg_yellow_tripdata.sql
│ │ └── stg_taxi_zone_lookup.sql
│ └── marts/ # star schema (tables)
│ ├── fct_trips.sql
│ └── dim_locations.sql
├── seeds/
│ └── taxi_zone_lookup.csv
└── dbt_project.yml


## Data Source

[NYC TLC Trip Record Data](https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page) — official public dataset from the NYC Taxi & Limousine Commission.

## How to Run

1. Clone this repo and create a Python virtual environment
2. `pip install -r requirements.txt`
3. Set up a `.env` file with your Snowflake credentials (see `.env.example`)
4. `python run_dbt.py seed` — loads reference data
5. `python run_dbt.py run` — builds all models
6. `python run_dbt.py test` — validates data quality

## Status

🚧 Actively evolving — next additions: CI/CD (GitHub Actions), incremental materialization, and expanded data quality tests.
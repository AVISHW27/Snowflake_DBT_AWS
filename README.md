# End-to-End ELT Data Platform on Snowflake (dbt + AWS)

An end-to-end ELT pipeline that loads booking, listing and host data from AWS S3 into Snowflake and transforms it with dbt Core using a medallion architecture (bronze → silver → gold).

## Architecture

```
AWS S3 (raw CSV files)
   │  external stage + storage integration (AWS IAM)
   ▼
Snowflake STAGING (COPY INTO)
   │  dbt Core
   ▼
BRONZE  →  SILVER  →  GOLD
raw copy   cleaned,     OBT, fact table,
           incremental  SCD Type 2 dimensions
```

## Tech Stack

Snowflake · dbt Core · AWS S3 · AWS IAM · Python (uv) · Git

## What's Inside

- **Ingestion:** S3 files loaded into Snowflake through an external stage, file format and `COPY INTO`, with IAM-based secure access.
- **Bronze:** Raw tables built from dbt sources with incremental loads.
- **Silver:** Cleaned and enriched models with incremental upsert logic (`unique_key`).
- **Gold:** Metadata-driven one-big-table (OBT) and fact model generated with Jinja loops, plus ephemeral helper models.
- **Snapshots:** SCD Type 2 history for hosts, listings and bookings.
- **Macros:** Reusable Jinja macros (`multiply`, `trimmer`, `tag`) and custom schema routing (`generate_schema_name`).

## Project Structure

```
aws_dbt_snowflake_project/
├── models/
│   ├── sources/     # source definitions
│   ├── bronze/      # raw layer
│   ├── silver/      # cleaned, incremental layer
│   └── gold/        # OBT, facts, ephemeral models
├── snapshots/       # SCD Type 2 dimensions
├── macros/          # reusable Jinja macros
└── analyses/        # Jinja examples
```

## How to Run

```bash
uv sync
cd aws_dbt_snowflake_project
dbt deps
dbt build          # runs models, snapshots and tests
```

Set up your Snowflake connection in `~/.dbt/profiles.yml` (credentials are not stored in this repo).

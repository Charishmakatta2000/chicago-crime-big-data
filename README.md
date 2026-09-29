Big Data Analysis of Chicago Crime Records
A serverless big-data pipeline on AWS that stores, processes, and analyzes millions of Chicago crime records. Built as a team class project for IT 5613 – Big Data and Cloud Computing. A 2.2 GB raw CSV sits in an S3 data lake; schema discovery runs through AWS Glue, and all analysis is done with Amazon Athena SQL — no servers managed at any point.

Architecture
City of Chicago open data (CSV, 2.2 GB)
        │
        ▼
Amazon S3 ── data lake (decoupled storage & compute)
        │
        ▼
AWS Glue crawler ──► Glue Data Catalog (column headers & types)
        │
        ▼  (crawler misfired on hidden system files → fixed with custom DDL)
Amazon Athena ── ad-hoc SQL analytics on the S3 data
The interesting engineering part: the Glue crawler initially indexed hidden system files and returned technical metadata (hive, varchar, …) instead of crime records. The fix was a custom CREATE EXTERNAL TABLE DDL using the OpenCSVSerde library (handles commas/quotes inside CSV text) with every column defined as STRING — a schema-on-read strategy, since the file has dirty data (e.g. empty coordinate fields) that crashes numeric parsing. Numbers are CAST only inside the analysis queries, where needed.

Key findings (verified from the Athena query results)
Frequency & density — where the pressure on city resources is highest:

Crime type

Reports

Theft

1,804,952

Battery

1,547,900

Criminal damage

966,131

Narcotics

765,924

Assault

570,715

Other offense

530,466

Burglary

448,831

Motor vehicle theft

436,600

Deceptive practice

393,124

Temporal analysis — crime volume per year from 2001 to the present, showing the long-term trend for policy evaluation.

Arrest-rate KPIs — arrest rate computed per crime type with CAST + SUM logic. Narcotics shows a near-100% arrest rate while other crime types are much lower, pinpointing where law enforcement is most and least successful.

Visualizations — bar chart of top crimes, line chart of crimes by year, pie chart of total arrests (see presentation/).

Repository structure
chicago-crime-big-data/
├── README.md
├── sql/
│   ├── 01_create_table_ddl.sql        # external-table DDL (OpenCSVSerde, all-STRING schema-on-read)
│   ├── 02_verify_raw_records.sql      # validation: SELECT * LIMIT 10 after the DDL fix
│   ├── 03_frequency_analysis.sql      # COUNT/GROUP BY crime type → density analysis
│   ├── 04_yearly_crime_trend.sql      # crimes per year, 2001 → present
│   └── 05_arrest_rate_performance.sql # arrest-rate KPI per crime type
├── presentation/
│   ├── chicago_crime_presentation.pdf  # 14-slide class presentation (PDF, previews on GitHub)
│   └── chicago_crime_presentation.pptx # editable slide deck
└── docs/
    └── chicago_crime_script_and_guide.pdf # presentation script + Q&A + project summary
The SQL files are reproduced from the project's Athena query history; run them in numbered order.

How to reproduce
Upload the Chicago crime CSV to an S3 bucket (the City of Chicago open data portal publishes the file).
Either run an AWS Glue crawler over the bucket, or run sql/01_create_table_ddl.sql in Athena to create the external table directly (point LOCATION at your S3 folder).
Run sql/02_verify_raw_records.sql to confirm the schema maps to real records.
Run sql/03–05 for the frequency, temporal, and arrest-rate analyses.
Future work
Amazon QuickSight dashboards and crime heat maps
Amazon SageMaker hotspot prediction from historical locations/times
AWS Lambda for real-time updates as new reports land
S3 partitioning by year/district to cut Athena scan costs
Skills demonstrated
AWS (S3 data lake, Glue, Athena) · serverless analytics · SQL DDL & SerDe configuration · schema-on-read data engineering · data validation · aggregation analysis (frequency, temporal trends, KPIs) · big-data troubleshooting

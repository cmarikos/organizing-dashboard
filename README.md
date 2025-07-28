# Organizing Dashboard

This repository contains the BigQuery SQL queries and potentially other assets related to the "Organizing Dashboard" used for tracking and analyzing organizing efforts.

## Overview

The Organizing Dashboard provides key insights into our organizing activities, primarily by aggregating and analyzing event and contact data. It helps us monitor engagement, track event participation, and understand the effectiveness of our outreach. The oututs of this project produces a live Looker Studio dashboard (which will remain for internal use only)

## Data Sources

The dashboard relies on data primarily sourced from:

*   **`proj-tmc-mem-mvp.everyaction_enhanced.enh_everyaction__contacts`**: This table likely contains contact information and details from our EveryAction system.
*   **`prod-organize-arizon-4e1c0a83.organizing_view.organizing_user_events`**: This view seems to hold details about events and user participation.

## Key Queries

The core logic of the dashboard is driven by BigQuery SQL queries. Some key queries found in this project include:

*   `hotlists_append.sql`
*   `hotlists.sql`
*     ^ these two are on thin ice as we re-work how our organizers understand their core volunteers
*   `organizing_event_attendees_legacy.sql`
*   `organizing_goals_legacy.sql`
*   `unique_attendee_volunteers`

These queries transform raw data into a format suitable for reporting and visualization. For example, some queries calculate:

*   Date of first engagement
*   Volunteer status and event counts
*   Aggregated event lists and organizers

## Google Cloud / BigQuery Information

This dashboard heavily leverages Google BigQuery for data warehousing and analytics.

*   **Project ID**: `prod-organize-arizon-4e1c0a83`
*   **Dataset(s)**: Data is drawn from various datasets, including `everyaction_enhanced` and `organizing_view`.
*   **Cost Considerations**: Be aware that running queries in BigQuery incurs costs based on the amount of data processed. For instance, some of the queries used for this dashboard can process around 9.7 GB per run.

## Setup and Usage

### Prerequisites

*   Access to the Google Cloud Project `prod-organize-arizon-4e1c0a83`.
*     You'd replace this with your project name and adapt queries to your datasets and projects if you were going to fork this repo
*   Permissions to query tables and views within the relevant BigQuery datasets.
*   Any datasets within `the proj-tmc-mem-mvp.` project are TMC syncs, and tables should be standardized across TMC users. If you are a CTA user, or use another engineering partner your data structure will likely look really different


### Data Refresh

*   I have these queries scheduled to run hourly, as well as the connected sheets that are pulled into this project

## Dashboard Visualization

*   The dashboard is built out in Looker studio and will remain internal (I am happy to show you on request and answer questions on the source data, I just don't want it published publicly here)

## Contributing

*   There is some real spaghetti code in here as a result of these queries being worked and re-worked over the course of the year. If you notice any improvements or issues please feel free to contribute

## Contact

For questions or support, please contact christina@ruralazaction.org

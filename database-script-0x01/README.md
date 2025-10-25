# Database Schema Design (DDL)
This directory contains the **Data Definition Language (DDL) SQL script** required to provision the database for the AirBnB Clone backend project. The schema is designed to meet Third Normal Form (3NF) standards.
---

## Objective
The primary goal of the `schema.sql` script is to:
1. **Create all necessary tables** (Entities) for the platform (Users, Properties, Bookings, Payments, Reviews, Messages).
2. **Define all constraints** (Primary Keys, Foreign Keys, NOT NULL, CHECK).
3. **Implement custom PostgreSQL features** (UUIDs, ENUM types, and Triggers).
4. **Create essential indexes** to ensure optimal read performance for key search columns and JOIN operations.
---

## 2. Prerequisites and Setup
To execute this script, you must have a running **PostgreSQL** instance and a utility to connect to it (like `psql` or a graphical client).

This script assumes the database is already running via the docker container set up in the initial environment:
* ***Database:*** `airbnb_clone`
* ***Host:*** `localhost: 5432`
* ***credentials:*** `admin/admin`
---


## 3. Schema Highlights
The schema is built aournd six primary entities, linked using **UUID** keys.

| Entity | Primary Key (PK) Type | Key Relationships (FKs) |
| :--- | :--- | :---|
|***User***|`UUID`|N/A|
|***Property***|`UUID`|`host_id` (User)|
|***Booking***|`UUID`|`user_id` (User), `property_id` (Property)|
|***Payment***|`UUID`|`booking_id` (Booking)|
|***Review***|`UUID`|`user_id` (User), `property_id` (Property)|
|***Message***|`UUID`|`sender_id`, `recipient_id` (User)|

### Key Features Implemented:
* **Referential Integrity:** Enforced using **`ON DELETE CASCADE`** for all Foreign Keys.
* **Automatic Timestamps:** A **PL/pgSQL Trigger Function** is used to automatically update the `updated_at` column on change for sensitive tables (Property, Payment, Review, Message).
* **Controlled Values:** Custom **`ENUM` types** (`user_role`, `booking_status`, `payment_method`) are defined to restrict input values.
* **Rating Integrity:** The **Review** table uses a **`CHECK` constraint** to ensure ratings are always between 1 and 5.
---

## 4. Usage
To run this script and create the schema in your PostgreSQL database, use the `psql` command-line tool, replacing `[database_name]` with `airbnb_clone`:

```bash
psql -h localhost -U admin -d [database_name] -f schema.sql
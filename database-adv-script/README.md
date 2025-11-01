# JOINs Practice - `database-adv-script`

This directory contains practice SQL queries to exercise different types of JOINs usign the schema defined in teh project's [database-script-0x01/schema.sql](lameckirungu/alx-airbnb-database/database-script-0x01/schema.sql).

### Files:
- `joins_queries.sql` - Contains three example queries:
    1. INNER JOIN: list all bookings with their booking user information (only bookings that have a matching user).
    2. LEFT JOIN: list all properties with their reviews, including properties that have no reviews (NULLs for review fields).
    3. FULL OUTER JOIN: list all users and bookings, returning rows even when a user has no bookings or a booking is not linked to a user.

### Notes:
- The schema uses postgres-specific features (UUID, enums, triggers). The FULL OUTER JOIN query uses Postgres syntax and is compatible with PostgreSQL.
- `FULL OUTER JOIN` is not supported by all databases such as older MySQL versions.
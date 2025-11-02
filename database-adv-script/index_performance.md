This document describes how I identified candidate columns, the indexes I created, and how to measure query performance before and after indexing. 

Summary of candidates
- User: email, role (lookups, filters)
- booking: user_id, property_id, status, start_date (joins, date ranges)
- property: host_id, location, price_per_night (search)

Indexes created
- See [database_index.sql](#) for the exact CREATE INDEX statements.
---
### How I measured performance

### What Improved and What to Watch
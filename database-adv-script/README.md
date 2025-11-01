# JOINs, Subqueries Practice - `database-adv-script`

This directory contains practice SQL queries to exercise different types of JOINs usign the schema defined in teh project's [database-script-0x01/schema.sql](lameckirungu/alx-airbnb-database/database-script-0x01/schema.sql).

### Files:
- `joins_queries.sql` - Contains three example queries:
    1. INNER JOIN: list all bookings with their booking user information (only bookings that have a matching user).
    2. LEFT JOIN: list all properties with their reviews, including properties that have no reviews (NULLs for review fields).
    3. FULL OUTER JOIN: list all users and bookings, returning rows even when a user has no bookings or a booking is not linked to a user.

### Notes:
- The schema uses postgres-specific features (UUID, enums, triggers). The FULL OUTER JOIN query uses Postgres syntax and is compatible with PostgreSQL.
- `FULL OUTER JOIN` is not supported by all databases such as older MySQL versions.

- `subqueries.sql` - two example queries:
    1. Non-correlated subquery to find properties with average rating > 4.0.
    2. Correlated subquery to find users who have made more than 3 bookings.

***Why Subqueries?***
- Subqueries (a SELECT inside another query) let you express logic that depends on aggregated, filtered or otherwise derived data.
- Non-correlated subqueries run independently of the outer query (they produce a result that the outer query can use).
- Correlated subqueries run once per row of the outer query because they reference columns from that outer row.

1) Non-correlated subquery - properties with avg rating > 4.0
- ***Query:***
```sql
SELECT ... FROM property p
WHERE p.property_id IN (
    SELECT r.property_id
    FROM review r
    GROUP BY r.property_id
    HAVING AVG(r.rating) > 4.0
);
```
- The inner query groups rviews by `property_id` and computes `AVG(rating)`.
- The `HAVING` clause filters groups where the avg rating is above the threshold.
- Because the inner subquery does not reference the outer table alias `p`, it is *non-correlated*: it runs once and returns a list of `property_id`'s.
- The outer query then selets properties whose id appeaers in that list.

2) Correlated subquery - users with more than 3 bookings
- ***Query:***
```sql
SELECT u.*, (
    SELECT COUNT(*) FROM booking b WHERE b.user_id = u.user_id
) AS bookings_count
FROM "user" u
WHERE (
    SELECT COUNT(*) FROM booking b WHERE b.user_id = u.user_id
) > 3;
```
  - The subquery references u.user_id from the outer query. That makes it correlated.
  - For every user row, the database executes (or logically evaluates) the subquery to count bookings for that specific user.
  - The correlated subquery returns a scalar (the count) that the outer query can compare in its WHERE clause or include in the SELECT list.
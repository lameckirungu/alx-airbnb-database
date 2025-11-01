-- SQL join practice queries for the alx-airbnb-database
-- Objective: Master SQL joins by writing complex queries using different types of joins.

-- 1) INNER JOIN
-- Retrieve all bookings and the respective users who made those bookings.
-- Only bookings that have a corresponding user will be returned.
SELECT
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    b.created_at      AS booking_created_at,
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.phone_number,
    u.role,
    u.created_at      AS user_created_at
FROM booking b
INNER JOIN "user" u
    ON b.user_id = u.user_id
ORDER BY b.created_at DESC;


-- 2) LEFT JOIN
-- Retrieve all properties and their reviews, including properties that have no reviews.
-- Properties without reviews will have NULL values for the review columns.
SELECT
    p.property_id,
    p.name           AS property_name,
    p.description,
    p.location,
    p.price_per_night,
    p.host_id,
    p.created_at     AS property_created_at,
    r.review_id,
    r.user_id        AS reviewer_user_id,
    r.rating,
    r.comment,
    r.created_at     AS review_created_at
FROM property p
LEFT JOIN review r
    ON p.property_id = r.property_id
ORDER BY p.name, r.created_at DESC;


-- 3) FULL OUTER JOIN
-- Retrieve all users and all bookings, even if the user has no booking or a booking is not linked to a user.
-- we use COALESCE to show a unified identifier when one side is NULL.
SELECT
    COALESCE(u.user_id, b.user_id)       AS user_id_or_booking_user_id,
    u.user_id                            AS user_id,
    u.first_name,
    u.last_name,
    u.email,
    b.booking_id,
    b.property_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    u.created_at                          AS user_created_at,
    b.created_at                          AS booking_created_at
FROM "user" u
FULL OUTER JOIN booking b
    ON u.user_id = b.user_id
ORDER BY COALESCE(b.created_at, u.created_at) DESC;
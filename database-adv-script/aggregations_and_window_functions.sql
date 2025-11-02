-- Aggregations and Window Functions

-- Objective: Use SQL aggregations and Window Functions to analyze data.

-- Aggregation: total number of bookings made by each user.
SELECT
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    COUNT(b.booking_id) AS bookings_count
FROM "user" u
LEFT JOIN booking b
    ON u.user_id = b.user_id
GROUP BY u.user_id, u.first_name, u.last_name, u.email;
ORDER BY bookings_count DESC, u.last_name, u.first_name;

-- Window Function: rank properties by total numbe rof bookings
SELECT
    p.property_id,
    p.name AS property_name,
	p.location,
	COALESCE(pb.bookings_count, 0) AS bookings_count,
	RANK() OVER(ORDER BY COALESCE(pb.bookings_count, 0) DESC) AS bookings_rank,
	ROW_NUMBER() OVER (ORDER BY COALESCE(pb.bookings_count, 0) DESC, p.property_id) AS bookings_row_number
FROM property p
LEFT JOIN (
	SELECT
		property_id,
		COUNT(*) AS bookigns_count
	FROM booking
	GROUP BY property_id
) pb ON p.property_id = pb.property_id
ORDER BY bookings_rank, bookings_count DESC;

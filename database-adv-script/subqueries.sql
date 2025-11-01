-- Non-correlated Subquery
SELECT
    p.property_id,
    p.name,
    p.description,
    p.location,
    p.price_per_night,
    p.host_id,
    p.created_at,
FROM property p
WHERE p.property_id IN (
	SELECT
		r.property_id
	FROM review r
	GROUP BY r.property_id
	HAVING AVG(r.rating) > 4.0
)
ORDER BY p.name;

-- Correlated Subquery
SELECT
	u.user_id,
	u.first_name,
	u.last_name,
	u.email,
	u.role,
	u.created_at,
	(
		SELECT COUNT(*)
		FROM booking b
		WHERE b.user_id = u.user_id
	) AS bookings_count
FROM "user" u
WHERE (
	SELECT COUNT(*)
	FROM booking b
	WHERE b.user_id = user.id
) > 3
ORDER BY bookings_count DESC, u.last_name, u.first_name;

TRUNCATE "user" CASCADE; -- Automatically clear dependent tables

-- Use Common Table Expressions (CTEs) to insert and capture generated UUIDs

-- Creating Users first
WITH users AS (
	INSERT INTO "user" (first_name, last_name, email, phone_number, password_hash, role)

	VALUES
		('Alice', 'Mwangi', 'alice.host@gmail.com', '25429039934', 'hash_alice_pwd', 'host'),
		('Kim', 'Kong', 'kim.both@yahoo.com' '25439032042', 'hash_both_pwd', 'guest'),
		('Okotu', 'mena', 'okotu.mena@mail.com', '254890238420', 'hash_okotu_pwd', 'host');
	
	RETURNING user_id, email, role
),

2. -- Create Properties
properties AS (
	INSERT INTO property (host_id, name, description, "location", price_per_night)
	SELECT
		user_id,
		CASE
			WHEN email = 'alice.host@gmail.com' THEN 'Cozy Cabin in the Woods'
			WHEN email = 'kim.both@yahoo.com' THEN 'Modern Urban Loft'
		END

		CASE
			WHEN email = 'alice.host@gmail.com' THEN 'A beautiful, quiet cabin perfect for a getaway. Full kitchen and fireplace.'
			WHEN email = 'kim.both@yahoo.com' THEN 'Stylish loft in teh city center, close to all attractions.'
		END,

		CASE
			WHEN email = 'alice.host@gmail.com' THEN 'Asheville, NC'
			WHEN email = 'kim.both@yahoo.com' THEN 'New York, NY'
		END,

		CASE
			WHEN email = 'alice.host@gmail.com' THEN 120.00
			WHEN email = 'kim.both@yahoo.com' THEN 250.00
		END
		FROM users
		WHERE role = 'host'
		RETURNING property_id, name, host_id
),
-- 3. Create Bookings
-- Bob (guest) will book Alice's cabin (confirmed)
-- Bob will also book Kim's loft (pending)
-- Kim (host) will book Alice's cabin (cancelled)

bookings AS (
	INSERT INTO booking(user_id, property_id, start_date, end_date, total_price, status)
	VALUES
	(
		(SELECT user_id FROM users WHERE email = 'bob.guest@example.com'),
		(SELECT property_id FROM properties WHERE name = 'Cozy Cabin in the Woods'),
		'2024-11-10', '2024-11-15', 600.00, 'confirmed'
	),
	(
		(SELECT user_id FROM users WHERE email = 'bob.guest@example.com'),
		(SELECT property_id FROM properties WHERE name = 'Modern Urban Loft'),
		'2024-11-10', '2024-11-15', 500.00, 'pending'
	),
	(
		(SELECT user_id FROM users WHERE email = 'kim.both@mail.com'),
		(SELECT property_id FROM properties WHERE name = 'Cozy Cabin in the Woods'),
		'2024-11-10', '2024-11-15', 240.00, 'cancelled'
	)

RETURNING booking_id, property_id, user_id, status, total_price
)

-- Create payments
-- Add a payment for Bob's 'confirmed' booking.

INSERT INTO payment (booking_id, amount, payment_method)
SELECT
	booking_id,
	total_price
	'credit_card'
FROM bookings
WHERE status = 'confirmed';

-- 5. Create Reviews
-- Bob leaves a review for Alice's cabin after his confirmed stay.
-- We use a sub-select to find the correct property_id and user_id
INSERT INTO review (property_id, user_id, rating, "comment")
SELECT
	property_id,
	user_id,
	5, -- rating
	'Absolutely fantastic! The cabin was clean, cozy, and exactly as described. Will definitely be back!'
FROM bookings
WHERE status = 'confirmed' AND user_id = (SELECT user_id FROM users WHERE email = 'bob.guest@example.com');

-- 6. Create Messages
-- Bob (sender) asks Alice (recipient) a question.
INSERT INTO message (sender_id, recipient_id, message_body)
VALUES
(
	(SELECT user_id FROM users WHERE email = 'bob.guest@example.com'),
	(SELECT user_id FROM users WHERE email = 'alice.host@gmail.com'),
	'Hi Alice, just confirming my booking for the next month. What is the check-in procedure?'
),
(
	(SELECT user_id FROM users WHERE email = 'alice.host@gmail.com'),
	(SELECT user_id FROM users WHERE email = 'bob.guest@example.com'),
	'Hi Bob! So glad to have you. The key will be in a lockbox, I will send you the code before the day you arrive.'
);

-- Final Check:
SELECT 'Users Created: ', COUNT(*) FROM "user";
SELECT 'Properties Created: ', COUNT(*) FROM property;
SELECT 'Bookings Created: ', COUNT(*) FROM booking;
SELECT 'Payments Created: ', COUNT(*) FROM payment;
SELECT 'Reviews Left: ', COUNT(*) FROM review;
SELECT 'Messages sent: ', COUNT(*) FROM message;


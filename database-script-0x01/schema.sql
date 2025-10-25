-- Install extension for UUID generation
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Define custom ENUM types for the schema
DO $$ BEGIN
	-- Role ENUM for the User table
	IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'user_role') THEN
		CREATE TYPE user_role AS ENUM ('guest', 'host', 'admin');
	END IF;

	-- Booking Status ENUM
	IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'booking_status') THEN
		CREATE TYPE booking_status AS ENUM('pending', 'confirmed', 'cancelled');
	END IF;
	
	-- Payment Method ENUM
	IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'payment_method') THEN
		CREATE TYPE payment_method AS ENUM('credit_card', 'paypal', 'stripe');
	END IF;
END $$;


CREATE TABLE IF NOT EXISTS "user" (
	user_id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,

	first_name VARCHAR(100) NOT NULL,
	last_name VARCHAR(100) NOT NULL,
	email VARCHAR(100) UNIQUE NOT NULL,
	phone_number VARCHAR(20),
	password_hash VARCHAR(100) NOT NULL,
	role user_role NOT NULL,
	created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP);


CREATE TABLE IF NOT EXISTS property (
	-- PK, FK
	property_id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
	host_id UUID NOT NULL REFERENCES "user"(user_id) ON DELETE CASCADE,
	-- Attributes
	name VARCHAR(100) NOT NULL,
	description TEXT NOT NULL,
	location VARCHAR(100) NOT NULL,
	price_per_night DECIMAL(10, 2) NOT NULL,

	-- Timestamps
	created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMP WITH TIME ZONE -- auto-set by a trigger
);

-- Trigger to automatically update 'updated_at' column
CREATE OR REPLACE FUNCTION set_updated_at_timestamp()
RETURNS TRIGGER AS $$
BEGIN
	NEW.updated_at = NOW(); -- Set the 'updated_at' column to the current time
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_property_updated_at
BEFORE UPDATE ON property
FOR EACH ROW
EXECUTE PROCEDURE set_updated_at_timestamp();


CREATE TABLE IF NOT EXISTS booking (
	booking_id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
	user_id UUID NOT NULL REFERENCES "user"(user_id) ON DELETE CASCADE,
	property_id UUID NOT NULL REFERENCES property(property_id) ON DELETE CASCADE,
	
	-- Attributes
	start_date DATE NOT NULL,
	end_date DATE NOT NULL,
	total_price DECIMAL(10, 2) NOT NULL,
	status booking_status NOT NULL,
	created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS payment (
	payment_id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
	booking_id UUID NOT NULL REFERENCES booking(booking_id) ON DELETE CASCADE,
	amount DECIMAL(10, 2) NOT NULL,

	-- Timestamps
	payment_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
	payment_method payment_method NOT NULL,
	updated_at TIMESTAMP WITH TIME ZONE
);

CREATE TRIGGER set_payment_updated_at
BEFORE UPDATE ON payment
FOR EACH ROW
EXECUTE PROCEDURE set_updated_at_timestamp();


CREATE TABLE IF NOT EXISTS review (
	review_id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
	property_id UUID NOT NULL REFERENCES property(property_id) ON DELETE CASCADE,
	user_id UUID NOT NULL REFERENCES "user"(user_id) ON DELETE CASCADE,
	rating INTEGER NOT NULL CHECK(rating >= 1 AND rating <= 5),
	comment TEXT NOT NULL,
	created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMP WITH TIME ZONE
);

CREATE TRIGGER set_review_updated_at
BEFORE UPDATE ON review
FOR EACH ROW
EXECUTE PROCEDURE set_updated_at_timestamp();


CREATE TABLE IF NOT EXISTS message (
	message_id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
	sender_id UUID NOT NULL REFERENCES "user"(user_id) ON DELETE CASCADE,
	recipient_id UUID NOT NULL REFERENCES "user"(user_id) ON DELETE CASCADE,
	message_body TEXT NOT NULL,
	sent_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMP WITH TIME ZONE
);
CREATE TRIGGER set_message_updated_at
BEFORE UPDATE ON message
FOR EACH ROW
EXECUTE PROCEDURE set_updated_at_timestamp();

-- Indexing
CREATE INDEX idx_user_email ON "user" (email);

-- on FKs
CREATE INDEX idx_booking_propertyid ON booking (property_id);
CREATE INDEX idx_review_userid ON review (user_id);
CREATE INDEX idx_payment_bookingid ON payment (booking_id);
CREATE INDEX idx_message_senderid ON message (sender_id);
CREATE INDEX idx_message_recipientid ON message (recipient_id);
CREATE INDEX idx_booking_userid ON booking (user_id);

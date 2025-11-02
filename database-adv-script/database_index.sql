-- user table indexes
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_user_email ON "user" (email);
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_booking_user_id ON booking (user_id);

-- booking table indexes
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_booking_property_id ON booking (property_id);
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_booking_status ON booking (status);
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_booking_start_date ON booking (start_date);
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_booking_end_date ON booking (end_date);

-- property table indexes
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_property_host_id ON property (host_id);
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_property_location ON property (location);
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_property_price_per_night ON property (price_per_night);
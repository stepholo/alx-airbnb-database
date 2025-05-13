-- Identify high-usage columns in your User, Booking, and Property tables

EXPLAIN SELECT * FROM "user" INNER JOIN property ON "user".user_id = property.user_id;

CREATE INDEX idx_property_host_id ON property (host_id);
CREATE INDEX idx_booking_property_id ON booking (property_id);
CREATE INDEX idx_booking_user_id ON booking (user_id);
CREATE INDEX idx_user_email ON "user" (email);

EXPLAIN ANALYZE SELECT * FROM "user" INNER JOIN property ON "user".user_id = property.user_id;

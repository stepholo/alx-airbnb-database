-- Sample Data

-- Install the required extention
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Insert sample data into the user table
INSERT INTO "user" (user_id, first_name, last_name, email, password_hash, phone_number, role, created_at) VALUES
    (gen_random_uuid(), 'Emma', 'Wilson', 'emma.wilson@example.com', 'hashed_password_123', '+12025550123', 'guest', '2025-01-15 10:00:00'),
    (gen_random_uuid(), 'James', 'Chen', 'james.chen@example.com', 'hashed_password_456', '+12025550124', 'host', '2025-01-20 12:00:00'),
    (gen_random_uuid(), 'Sophia', 'Martinez', 'sophia.martinez@example.com', 'hashed_password_789', '+12025550125', 'guest', '2025-02-01 09:00:00'),
    (gen_random_uuid(), 'Liam', 'Patel', 'liam.patel@example.com', 'hashed_password_101', '+12025550126', 'host', '2025-02-10 14:00:00'),
    (gen_random_uuid(), 'Olivia', 'Smith', 'olivia.smith@example.com', 'hashed_password_112', '+12025550127', 'admin', '2025-03-01 08:00:00');

-- Insert sample data into the property table
INSERT INTO property (property_id, host_id, name, description, pricepernight, created_at, updated_at) VALUES
    (gen_random_uuid(), (SELECT user_id FROM "user" WHERE email = 'james.chen@example.com'), 'Cozy Downtown Loft', 'A stylish loft in the heart of the city with modern amenities.', 120.00, '2025-02-15 11:00:00', '2025-02-15 11:00:00'),
    (gen_random_uuid(), (SELECT user_id FROM "user" WHERE email = 'liam.patel@example.com'), 'Beachfront Cottage', 'Charming cottage with stunning ocean views, perfect for a getaway.', 200.00, '2025-03-01 13:00:00', '2025-03-01 13:00:00'),
    (gen_random_uuid(), (SELECT user_id FROM "user" WHERE email = 'james.chen@example.com'), 'Mountain Cabin Retreat', 'Rustic cabin surrounded by nature, ideal for hiking enthusiasts.', 150.00, '2025-03-10 10:00:00', '2025-03-10 10:00:00');

-- Insert sample data into the location table
INSERT INTO location (location_id, property_id, street_address, county, states, created_at, updated_at) VALUES
    (gen_random_uuid(), (SELECT property_id FROM property WHERE name = 'Cozy Downtown Loft'), '123 Main St', 'Seattle', 'WA', '2025-02-15 11:00:00', '2025-02-15 11:00:00'),
    (gen_random_uuid(), (SELECT property_id FROM property WHERE name = 'Beachfront Cottage'), '456 Ocean Dr', 'Miami', 'FL', '2025-03-01 13:00:00', '2025-03-01 13:00:00'),
    (gen_random_uuid(), (SELECT property_id FROM property WHERE name = 'Mountain Cabin Retreat'), '789 Pine Rd', 'Aspen', 'CO', '2025-03-10 10:00:00', '2025-03-10 10:00:00');

-- Insert sample data into the booking table
INSERT INTO booking (booking_id, property_id, user_id, start_date, end_date, total_price, status, created_at) VALUES
    (gen_random_uuid(), (SELECT property_id FROM property WHERE name = 'Cozy Downtown Loft'), (SELECT user_id FROM "user" WHERE email = 'emma.wilson@example.com'), '2025-05-15', '2025-05-18', 360.00, 'confirmed', '2025-04-01 15:00:00'),
    (gen_random_uuid(), (SELECT property_id FROM property WHERE name = 'Beachfront Cottage'), (SELECT user_id FROM "user" WHERE email = 'sophia.martinez@example.com'), '2025-06-01', '2025-06-05', 800.00, 'pending', '2025-04-10 16:00:00'),
    (gen_random_uuid(), (SELECT property_id FROM property WHERE name = 'Mountain Cabin Retreat'), (SELECT user_id FROM "user" WHERE email = 'emma.wilson@example.com'), '2025-07-10', '2025-07-12', 300.00, 'confirmed', '2025-04-15 09:00:00'),
    (gen_random_uuid(), (SELECT property_id FROM property WHERE name = 'Cozy Downtown Loft'), (SELECT user_id FROM "user" WHERE email = 'sophia.martinez@example.com'), '2025-04-20', '2025-04-22', 240.00, 'canceled', '2025-04-05 14:00:00');

-- Insert sample data into the payment table
INSERT INTO payment (payment_id, booking_id, amount, payment_date, payment_method) VALUES
    (gen_random_uuid(), (SELECT booking_id FROM booking WHERE start_date = '2025-05-15' LIMIT 1), 360.00, '2025-04-02 10:00:00', 'credit_card'),
    (gen_random_uuid(), (SELECT booking_id FROM booking WHERE start_date = '2025-06-01' LIMIT 1), 400.00, '2025-04-11 11:00:00', 'paypal'),
    (gen_random_uuid(), (SELECT booking_id FROM booking WHERE start_date = '2025-07-10' LIMIT 1), 300.00, '2025-04-16 12:00:00', 'stripe'),
    (gen_random_uuid(), (SELECT booking_id FROM booking WHERE start_date = '2025-06-01' LIMIT 1), 400.00, '2025-04-12 09:00:00', 'credit_card');

-- Insert sample data into the review table
INSERT INTO review (review_id, property_id, user_id, rating, comment, created_at) VALUES
    (gen_random_uuid(), (SELECT property_id FROM property WHERE name = 'Cozy Downtown Loft'), (SELECT user_id FROM "user" WHERE email = 'emma.wilson@example.com'), 4, 'Great location and comfy bed, but parking was a hassle.', '2025-05-19 08:00:00'),
    (gen_random_uuid(), (SELECT property_id FROM property WHERE name = 'Beachfront Cottage'), (SELECT user_id FROM "user" WHERE email = 'sophia.martinez@example.com'), 5, 'Absolutely stunning views and a perfect stay!', '2025-06-06 10:00:00'),
    (gen_random_uuid(), (SELECT property_id FROM property WHERE name = 'Mountain Cabin Retreat'), (SELECT user_id FROM "user" WHERE email = 'emma.wilson@example.com'), 3, 'Nice cabin, but the Wi-Fi was unreliable.', '2025-07-13 09:00:00');

-- Insert sample data into the message table
INSERT INTO message (message_id, sender_id, recipient_id, message_body, sent_at) VALUES
    (gen_random_uuid(), (SELECT user_id FROM "user" WHERE email = 'emma.wilson@example.com'), (SELECT user_id FROM "user" WHERE email = 'james.chen@example.com'), 'Hi James, is the loft available for May 20-22?', '2025-04-01 17:00:00'),
    (gen_random_uuid(), (SELECT user_id FROM "user" WHERE email = 'james.chen@example.com'), (SELECT user_id FROM "user" WHERE email = 'emma.wilson@example.com'), 'Hi Emma, sorry, it’s booked then, but available May 15-18.', '2025-04-01 18:00:00'),
    (gen_random_uuid(), (SELECT user_id FROM "user" WHERE email = 'sophia.martinez@example.com'), (SELECT user_id FROM "user" WHERE email = 'liam.patel@example.com'), 'Hi Liam, does the cottage have a BBQ grill?', '2025-04-10 14:00:00'),
    (gen_random_uuid(), (SELECT user_id FROM "user" WHERE email = 'olivia.smith@example.com'), (SELECT user_id FROM "user" WHERE email = 'sophia.martinez@example.com'), 'Hi Sophia, your booking is pending payment confirmation.', '2025-04-11 15:00:00');

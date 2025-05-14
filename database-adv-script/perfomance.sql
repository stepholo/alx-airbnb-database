-- Write an initial query that retrieves all bookings along with the user details, property details, and payment details and save it on

EXPLAIN SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.status,
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    p.property_id,
    p.name AS property_name,
    p.pricepernight,
    l.street_address,
    l.county,
    l.states,
    pay.payment_id,
    pay.amount,
    pay.payment_method,
    pay.payment_date
FROM booking AS b
JOIN "user" AS u ON b.user_id = u.user_id
JOIN property AS p ON b.property_id = p.property_id
LEFT JOIN location AS l ON b.property_id = l.property_id
LEFT JOIN payment AS pay ON b.booking_id = pay.booking_id;
 

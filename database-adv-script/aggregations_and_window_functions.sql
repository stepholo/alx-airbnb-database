-- Write a query to find the total number of bookings made by each user, using the COUNT function and GROUP BY clause.

SELECT user_id, COUNT(booking_id) AS total_bookings FROM booking GROUP by user_id;

-- Use a window function (ROW_NUMBER, RANK) to rank properties based on the total number of bookings they have received.

SELECT property_id, total_bookings, RANK() OVER (ORDER BY total_bookings DESC) AS rank, ROW_NUMBER() OVER (ORDER BY total_bookings DESC) AS row_number FROM (SELECT property_id, COUNT(*) AS total_bookings FROM booking GROUP BY property_id) AS booking_counts;

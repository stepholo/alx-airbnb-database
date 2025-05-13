-- Write a query using an INNER JOIN to retrieve all bookings and the respective users who made those bookings.

SELECT * FROM "user" INNER JOIN booking ON "user".user_id = booking.user_id;

-- Write a query using a LEFT JOIN to retrieve all properties and their reviews, including properties that have no reviews.

SELECT * FROM review LEFT JOIN property ON property.property_id = review.property_id ORDER BY rating ASC;

-- Write a query using a FULL OUTER JOIN to retrieve all users and all bookings, even if the user has no booking or a booking is not linked to a user.

SELECT * FROM "user" FULL OUTER JOIN booking ON "user".user_id = booking.user_id;

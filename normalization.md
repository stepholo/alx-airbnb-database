# Schema Recap
Entities: User, Property, Booking, Payment, Review, Message

Each entity has a primary key (UUID), foreign keys, and constraints as specified. 
The relationships are well-defined (e.g., one-to-many between User and Property, Booking and Payment).

## Normalization Analysis

# First Normal Form (1NF)
 - 1NF Requirements:

All attributes must be atomic (no multi-valued or composite attributes).
Each table must have a primary key.
No repeating groups.

  - Analysis:

	- Atomicity: All attributes are atomic:
	- User: email, first_name, role (ENUM), etc., are single-valued.
	- Property: description (TEXT) and location (VARCHAR) are single values.
	- Booking: start_date, end_date, status (ENUM), etc., are atomic.
	- Payment: payment_method (ENUM) and amount are atomic.
	- Review: rating (INTEGER) and comment (TEXT) are atomic.
	- Message: message_body (TEXT) is a single value.
	- ENUMs (role, status, payment_method) are acceptable as they represent a single, constrained value.
	- Primary Keys: Each table has a unique primary key (user_id, property_id, etc.).
	- Repeating Groups: No repeating groups are present (e.g., no lists or arrays within a single column).

Conclusion: The schema satisfies 1NF.

# Second Normal Form (2NF)
  - 2NF Requirements:

Must be in 1NF.
All non-key attributes must be fully functionally dependent on the entire primary key (no partial dependencies).
This applies to tables with composite keys.

  - Analysis:

	- Primary Keys: All tables have single-column primary keys (UUIDs: user_id, property_id, etc.), so there are no composite keys.
	- Partial Dependencies: Since there are no composite keys, partial dependencies are not possible. 
	  All non-key attributes in each table depend fully on their respective primary key:
	     - In User, attributes like first_name, email, role depend on user_id.
	     - In Property, name, description, host_id depend on property_id.
	     - In Booking, start_date, end_date, total_price depend on booking_id.
	     - Similarly for Payment, Review, and Message.

Conclusion: The schema satisfies 2NF, as there are no composite keys or partial dependencies.

# Third Normal Form (3NF)
  - 3NF Requirements:

Must be in 2NF.
No transitive dependencies (non-key attributes must not depend on other non-key attributes).

  - Analysis:
For each table, we check if any non-key attribute depends on another non-key attribute instead of the primary key.

- User:
  - Non-key attributes: first_name, last_name, email, password_hash, phone_number, role, created_at.
  - Dependencies: All depend directly on user_id. No non-key attribute (e.g., first_name) determines another (e.g., email).
  - No transitive dependencies.

- Property:
  - Non-key attributes: host_id, name, description, location, pricepernight, created_at, updated_at.
  - Dependencies: All depend on property_id. For example, location or pricepernight does not determine description.
  - Potential Concern: host_id is a foreign key referencing User. Could attributes like name or location depend on host_id (e.g., a host’s details)? No, because host_id is just an identifier, and properties are unique to their property_id. The host’s details (e.g., email) are stored in User, not duplicated here.
No transitive dependencies.

- Booking:
  - Non-key attributes: property_id, user_id, start_date, end_date, total_price, status, created_at.
  - Potential Redundancy: total_price might depend on start_date, end_date, and Property.pricepernight (via property_id). If total_price is calculated as pricepernight * (end_date - start_date), storing it introduces a potential redundancy, as it can be derived.
  - Normalization Issue: This is a transitive dependency because total_price depends on non-key attributes (start_date, end_date) and an external table (Property.pricepernight). To achieve 3NF, total_price could be removed from Booking and calculated dynamically in queries (e.g., SELECT (end_date - start_date) * pricepernight AS total_price by joining Booking and Property).
  - Practical Consideration: Storing total_price is common in booking systems for performance (avoiding repeated calculations) or to lock in a price at booking time (if pricepernight changes). If stored, it’s a deliberate denormalization, but it risks inconsistency if pricepernight, start_date, or end_date is updated without updating total_price.
Other attributes (status, created_at) depend directly on booking_id.
  - Transitive Dependency: total_price is a concern.

- Payment:
  - Non-key attributes: booking_id, amount, payment_date, payment_method.
  - Potential Redundancy: amount might relate to Booking.total_price. If amount is meant to equal total_price (for a single payment) or a portion of it (for multiple payments), there’s a risk of redundancy or inconsistency.
  - Normalization Issue: If amount duplicates total_price or is derived from it, it could be a transitive dependency. Ideally, amount should be validated against Booking.total_price (e.g., sum of Payment.amount for a booking_id ≤ total_price), but this is a business rule, not a normalization violation unless amount is fully determined by total_price.
  - Practical Consideration: Storing amount is justified, as payments may be partial or use different methods, and amount reflects the actual transaction. No clear transitive dependency unless amount is always equal to total_price.
  - Other attributes (payment_date, payment_method) depend on payment_id.
  - No clear transitive dependencies.

- Review:
  - Non-key attributes: property_id, user_id, rating, comment, created_at.
  - Dependencies: All depend on review_id. No non-key attribute (e.g., rating) determines comment.
  - No transitive dependencies.

- Message:
  - Non-key attributes: sender_id, recipient_id, message_body, sent_at.
  - Dependencies: All depend on message_id. No non-key attribute (e.g., sender_id) determines message_body.
  - No transitive dependencies.

## Conclusion:

The schema is mostly in 3NF, except for a potential issue in Booking:
  - Transitive Dependency: Booking.total_price may depend on start_date, end_date, and Property.pricepernight, violating 3NF.
  - Recommendation: To achieve 3NF, remove total_price from Booking and calculate it dynamically in queries. Alternatively, keep total_price for performance but enforce consistency via triggers or application logic (denormalization tradeoff).
Payment.amount is not a clear violation but requires business rules to ensure consistency with Booking.total_price.

## Summary of Findings
- Normalization Violations:
3NF Violation: Booking.total_price introduces a transitive dependency, as it depends on start_date, end_date, and Property.pricepernight.
Other tables satisfy 1NF, 2NF, 3NF, and BCNF.

- Redundancies:
Booking.total_price: Redundant if derivable; risks inconsistency.
Payment.amount: Potential redundancy if it duplicates total_price, but justified for partial payments.

- Recommendations:
For Booking.total_price:
Option 1 (Normalized): Remove total_price and calculate it dynamically (SELECT (end_date - start_date) * Property.pricepernight).
Option 2 (Denormalized): Keep total_price but add a booked_pricepernight attribute to Booking to store the price at booking time. 
Use triggers or application logic to ensure total_price = booked_pricepernight * (end_date - start_date).

For Payment.amount:
Retain amount but enforce business rules (e.g., sum of Payment.amount for a booking_id matches or is less than Booking.total_price).

General:
Ensure all updates to start_date, end_date, or Property.pricepernight trigger revalidation of total_price if stored.
Document any denormalization (e.g., total_price) to clarify its purpose (performance, price locking).

## Final Answer
The schema is in 1NF and 2NF but has a 3NF violation due to Booking.total_price, which depends on start_date, end_date, and Property.pricepernight, introducing a transitive dependency and potential redundancy. Additionally, Payment.amount risks inconsistency if not validated against total_price, though it’s not a strict normalization violation. To resolve:

Remove total_price and compute it dynamically, or store booked_pricepernight in Booking and enforce consistency.
Validate Payment.amount via business rules. No other redundancies or violations were found. 
The schema is otherwise well-structured with proper constraints and indexing.

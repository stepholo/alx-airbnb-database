
# Query’s Performance Report

## Query

```SQL
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
```

## Analysis Report

```SQL
                                       QUERY PLAN                                         
-------------------------------------------------------------------------------------------
 Hash Left Join  (cost=66.55..104.84 rows=920 width=1444)
   Hash Cond: (b.property_id = l.property_id)
   ->  Hash Join  (cost=52.50..79.06 rows=920 width=1106)
         Hash Cond: (b.property_id = p.property_id)
         ->  Hash Join  (cost=37.33..61.42 rows=920 width=856)
               Hash Cond: (b.user_id = u.user_id)
               ->  Hash Right Join  (cost=26.20..47.83 rows=920 width=104)
                     Hash Cond: (pay.booking_id = b.booking_id)
                     ->  Seq Scan on payment pay  (cost=0.00..19.20 rows=920 width=60)
                     ->  Hash  (cost=17.20..17.20 rows=720 width=60)
                           ->  Seq Scan on booking b  (cost=0.00..17.20 rows=720 width=60)
               ->  Hash  (cost=10.50..10.50 rows=50 width=768)
                     ->  Seq Scan on "user" u  (cost=0.00..10.50 rows=50 width=768)
         ->  Hash  (cost=12.30..12.30 rows=230 width=250)
               ->  Seq Scan on property p  (cost=0.00..12.30 rows=230 width=250)
   ->  Hash  (cost=11.80..11.80 rows=180 width=370)
         ->  Seq Scan on location l  (cost=0.00..11.80 rows=180 width=37)
```

# 🔍 Query Plan Analysis

```sql

EXPLAIN SELECT ...
```

## 🔸 Top-Level Operation: Hash Left Join
- Join Type: LEFT JOIN

- Tables Involved: booking (alias b) and location (alias l)

- Join Condition: b.property_id = l.property_id

- Cost Estimate: 66.55..104.84

- Purpose: This is the final join, ensuring all bookings are kept, even if no location match.

## 🔸 Inner Join: booking ↔ property
- Join Type: Hash Join

- Join Condition: b.property_id = p.property_id

- Cost Estimate: 52.50..79.06

## Nested Join: booking ↔ user
- Join Type: Hash Join

- Join Condition: b.user_id = u.user_id

- User Scan: Sequential Scan on "user"

- Cost: 0.00..10.50

- Rows: 50

##🔸 Join: payment ↔ booking
- Join Type: Hash Right Join

- Join Condition: pay.booking_id = b.booking_id

- Explanation: Booking is preserved; results will include bookings without a matching payment.

- Scan Details:

- payment: Seq Scan (0.00..19.20, rows=920)

- booking: Seq Scan (0.00..17.20, rows=720)

## 📊 Table Scan Summary
|Table	|Scan Type	|Estimated Rows|	Notes|
|-------|---------------|---------------|-------------|
|payment|	Seq Scan|	920	|Full scan|
|booking|	Seq Scan|	720	|Full scan|
|"user"|	Seq Scan|	50	|Light scan|
|property|	Seq Scan|	230	|Moderate load|
|location|	Seq Scan|	180	|Light scan|

## Performance Observations
- All tables are being fully scanned

- Indicates no WHERE clause or lack of indexes.

- Hash joins are efficient here

- PostgreSQL can handle small tables in memory.

- Hash Right Join is less common

- Can be rewritten as a LEFT JOIN for clarity.


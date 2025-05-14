# Partitioning Perfomance analysis

```SQL
-- Step 1: Rename the original table (for backup or reference)
ALTER TABLE booking RENAME TO booking_old;

-- Step 2: Create the partitioned parent table
CREATE TABLE booking (
    booking_id UUID PRIMARY KEY,
    user_id UUID NOT NULL,
    property_id UUID NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status VARCHAR(50),
    total_price NUMERIC,
    CHECK (start_date IS NOT NULL)
) PARTITION BY RANGE (start_date);

-- Step 3: Create partitions (e.g., by year or quarter)
CREATE TABLE booking_2023 PARTITION OF booking
    FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');

CREATE TABLE booking_2024 PARTITION OF booking
    FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');

CREATE TABLE booking_2025 PARTITION OF booking
    FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');

-- Step 4: (Optional) Reinsert data from the old table if needed
INSERT INTO booking
SELECT * FROM booking_old;

-- Step 5: (Optional) Drop old table after verifying
-- DROP TABLE booking_old;

-- Step 6: Indexes (optional but highly recommended)
CREATE INDEX idx_booking_2023_user_id ON booking_2023(user_id);
CREATE INDEX idx_booking_2024_user_id ON booking_2024(user_id);
CREATE INDEX idx_booking_2025_user_id ON booking_2025(user_id);
```

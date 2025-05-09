-- Schema for Database Entities

-- Create ENUM types for role, status, and payment_method
CREATE TYPE user_role AS ENUM ('guest', 'host', 'admin');
CREATE TYPE booking_status AS ENUM ('pending', 'confirmed', 'canceled');
CREATE TYPE payment_method AS ENUM ('credit_card', 'paypal', 'stripe');

-- Create User table
CREATE TABLE "user" (
    user_id UUID PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(255) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    phone_number VARCHAR(20),
    role user_role NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_email UNIQUE (email)
);

-- Create index on email
CREATE INDEX idx_user_email ON "user" (email);

-- Create Property table
CREATE TABLE property (
    property_id UUID PRIMARY KEY,
    host_id UUID NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    location VARCHAR(255) NOT NULL,
    pricepernight DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_host FOREIGN KEY (host_id) REFERENCES "user" (user_id) ON DELETE RESTRICT
);

-- Create index on property_id (primary key is already indexed)
CREATE INDEX idx_property_host_id ON property (host_id);

-- Create Booking table
CREATE TABLE booking (
    booking_id UUID PRIMARY KEY,
    property_id UUID NOT NULL,
    user_id UUID NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    status booking_status NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_property FOREIGN KEY (property_id) REFERENCES property (property_id) ON DELETE RESTRICT,
    CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES "user" (user_id) ON DELETE RESTRICT,
    CONSTRAINT check_dates CHECK (end_date >= start_date)
);

-- Create index on property_id and user_id
CREATE INDEX idx_booking_property_id ON booking (property_id);
CREATE INDEX idx_booking_user_id ON booking (user_id);

-- Create Payment table
CREATE TABLE payment (
    payment_id UUID PRIMARY KEY,
    booking_id UUID NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method payment_method NOT NULL,
    CONSTRAINT fk_booking FOREIGN KEY (booking_id) REFERENCES booking (booking_id) ON DELETE RESTRICT
);

-- Create Review table
CREATE TABLE review (
    review_id UUID PRIMARY KEY,
    property_id UUID NOT NULL,
    user_id UUID NOT NULL,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_review_property FOREIGN KEY (property_id) REFERENCES property (property_id) ON DELETE RESTRICT,
    CONSTRAINT fk_review_user FOREIGN KEY (user_id) REFERENCES "user" (user_id) ON DELETE RESTRICT
);

-- Create indexes for performance
CREATE INDEX idx_review_property_id ON review (property_id);
CREATE INDEX idx_review_user_id ON review (user_id);

-- Create Message table
CREATE TABLE message (
    message_id UUID PRIMARY KEY,
    sender_id UUID NOT NULL,
    recipient_id UUID NOT NULL,
    message_body TEXT NOT NULL,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_message_sender FOREIGN KEY (sender_id) REFERENCES "user" (user_id) ON DELETE RESTRICT,
    CONSTRAINT fk_message_recipient FOREIGN KEY (recipient_id) REFERENCES "user" (user_id) ON DELETE RESTRICT
);

-- Create indexes for performance
CREATE INDEX idx_message_sender_id ON message (sender_id);
CREATE INDEX idx_message_recipient_id ON message (recipient_id);

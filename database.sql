-- Smart Parcel Management System Database Schema

CREATE TABLE IF NOT EXISTS parcels (
    id INT AUTO_INCREMENT PRIMARY KEY,
    parcel_number VARCHAR(50) UNIQUE NOT NULL,
    parcel_date DATE NOT NULL,
    student_name VARCHAR(100) NOT NULL,
    phone_number VARCHAR(15) NOT NULL,
    source VARCHAR(50) NOT NULL,
    delivery_person_name VARCHAR(100) NOT NULL,
    delivery_person_phone VARCHAR(15) NOT NULL,
    status ENUM('Arrived', 'Delivered') DEFAULT 'Arrived',
    arrival_date DATE NOT NULL,
    delivery_date DATE NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Index for faster queries
CREATE INDEX idx_phone ON parcels(phone_number);
CREATE INDEX idx_parcel_date ON parcels(parcel_date);
CREATE INDEX idx_status ON parcels(status);
CREATE INDEX idx_parcel_number ON parcels(parcel_number);

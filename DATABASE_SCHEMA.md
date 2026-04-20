# Database Schema - Smart Parcel Management System

## Overview
Relational database with 4 interconnected tables using MySQL. Foreign key relationships ensure data integrity with automatic cleanup via CASCADE rules.

---

## Tables

### 1. students
Stores student registration information.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | INT | PRIMARY KEY, AUTO_INCREMENT | Unique student ID |
| name | VARCHAR(100) | NOT NULL | Student full name |
| sap_id | VARCHAR(11) | NOT NULL, UNIQUE | 11-digit SAP ID |
| email | VARCHAR(100) | NOT NULL, UNIQUE | Student email address |
| phone | VARCHAR(15) | NOT NULL, UNIQUE | 10-digit phone number |
| password_hash | VARCHAR(255) | NOT NULL | Bcrypt hashed password |
| created_at | DATETIME | DEFAULT CURRENT_TIMESTAMP | Registration timestamp |
| updated_at | DATETIME | DEFAULT CURRENT_TIMESTAMP ON UPDATE | Last update timestamp |

**Indexes:**
- PRIMARY KEY (id)
- UNIQUE KEY (sap_id)
- UNIQUE KEY (email)
- UNIQUE KEY (phone)

---

### 2. admins
Stores admin and delivery personnel credentials.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | INT | PRIMARY KEY, AUTO_INCREMENT | Unique admin ID |
| username | VARCHAR(50) | NOT NULL, UNIQUE | Admin username |
| password_hash | VARCHAR(255) | NOT NULL | Bcrypt hashed password |
| role | ENUM | DEFAULT 'watchman' | Role: admin, watchman, staff |
| created_at | DATETIME | DEFAULT CURRENT_TIMESTAMP | Creation timestamp |
| updated_at | DATETIME | DEFAULT CURRENT_TIMESTAMP ON UPDATE | Last update timestamp |

**Indexes:**
- PRIMARY KEY (id)
- UNIQUE KEY (username)

**Default Admin Credentials:**
- Username: `admin`
- Password: `admin123`
- Role: `admin`

---

### 3. parcels
Stores parcel information and delivery status.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | INT | PRIMARY KEY, AUTO_INCREMENT | Unique parcel record ID |
| parcel_id | VARCHAR(20) | NOT NULL, UNIQUE | Sequential parcel number (1, 2, 3...) |
| student_id | INT | NOT NULL, FOREIGN KEY | Reference to students.id |
| student_name | VARCHAR(100) | NOT NULL | Student name (denormalized) |
| phone | VARCHAR(15) | NOT NULL | Student phone (denormalized) |
| sap_id | VARCHAR(11) | NOT NULL | Student SAP ID (denormalized) |
| email | VARCHAR(100) | NOT NULL | Student email (denormalized) |
| source | VARCHAR(100) | NOT NULL | Parcel source (Amazon, Flipkart, etc.) |
| delivery_person | VARCHAR(100) | | Name of delivery person |
| delivery_phone | VARCHAR(15) | | Phone of delivery person |
| status | ENUM | DEFAULT 'Arrived' | Arrived / Delivered |
| arrival_date | DATE | DEFAULT CURDATE() | Date parcel arrived |
| delivery_date | DATE | NULL | Date parcel was delivered |
| created_at | DATETIME | DEFAULT CURRENT_TIMESTAMP | Record creation timestamp |
| updated_at | DATETIME | DEFAULT CURRENT_TIMESTAMP ON UPDATE | Last update timestamp |

**Indexes:**
- PRIMARY KEY (id)
- UNIQUE KEY (parcel_id)
- FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE

---

### 4. parcel_otps
Stores OTP codes for parcel verification.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | INT | PRIMARY KEY, AUTO_INCREMENT | Unique OTP record ID |
| parcel_id | VARCHAR(20) | NOT NULL | Reference to parcels.parcel_id |
| student_id | INT | NOT NULL | Reference to students.id |
| otp_code | VARCHAR(6) | NOT NULL | 6-digit OTP code |
| status | ENUM | DEFAULT 'Active' | Active / Used / Expired |
| created_at | DATETIME | DEFAULT CURRENT_TIMESTAMP | OTP generation timestamp |
| expires_at | DATETIME | NULL | OTP expiry (set to 2099 for no expiry) |
| used_at | DATETIME | NULL | When OTP was used |

**Indexes:**
- PRIMARY KEY (id)
- FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE

---

## Entity Relationship Diagram

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│     students    │     │     parcels     │     │   parcel_otps   │
├─────────────────┤     ├─────────────────┤     ├─────────────────┤
│ PK id           │◄────┤ FK student_id   │     │ FK student_id   │
│    name         │     │ PK id           │     │    parcel_id    │
│    sap_id (UQ)  │     │ UQ parcel_id    │◄────┤    otp_code     │
│    email (UQ)   │     │    student_name │     │    status       │
│    phone (UQ)   │     │    phone        │     │    expires_at   │
│    password_hash│     │    sap_id       │     └─────────────────┘
│    created_at   │     │    email        │
│    updated_at   │     │    source       │
└─────────────────┘     │    status       │
                        │    arrival_date │
                        │    delivery_date│
                        └─────────────────┘

┌─────────────────┐
│     admins      │
├─────────────────┤
│ PK id           │
│ UQ username     │
│    password_hash│
│    role         │
│    created_at   │
└─────────────────┘
```

---

## Relationships

| Relationship | Type | Description |
|--------------|------|-------------|
| students → parcels | 1:N | One student can have many parcels |
| students → parcel_otps | 1:N | One student can have many OTP records |
| parcels → parcel_otps | 1:N | One parcel can have multiple OTPs (regenerated) |

---

## Data Integrity Rules

1. **CASCADE DELETE**: When a student is deleted, all their parcels and OTPs are automatically deleted
2. **UNIQUE Constraints**: SAP ID, email, phone must be unique across students
3. **NOT NULL**: Required fields cannot be empty
4. **ENUM Validation**: Status fields only accept defined values

---

## Sample Data

### Students
| id | name | sap_id | email | phone |
|----|------|--------|-------|-------|
| 1 | Rahul Sharma | 12345678901 | rahul@nmims.edu | 9876543210 |
| 2 | Priya Mehta | 12345678902 | priya@nmims.edu | 9876543211 |

### Parcels
| parcel_id | student_id | student_name | source | status | arrival_date |
|-----------|------------|--------------|--------|--------|--------------|
| 1 | 1 | Rahul Sharma | Amazon | Arrived | 2026-04-15 |
| 2 | 2 | Priya Mehta | Flipkart | Arrived | 2026-04-15 |

---

## SQL Schema Creation

```sql
-- Students Table
CREATE TABLE students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    sap_id VARCHAR(11) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(15) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Admins Table
CREATE TABLE admins (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('admin', 'watchman', 'staff') NOT NULL DEFAULT 'watchman',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Parcels Table
CREATE TABLE parcels (
    id INT AUTO_INCREMENT PRIMARY KEY,
    parcel_id VARCHAR(20) NOT NULL UNIQUE,
    student_id INT NOT NULL,
    student_name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) NOT NULL,
    sap_id VARCHAR(11) NOT NULL,
    email VARCHAR(100) NOT NULL,
    source VARCHAR(100) NOT NULL,
    delivery_person VARCHAR(100),
    delivery_phone VARCHAR(15),
    status ENUM('Arrived', 'Delivered') NOT NULL DEFAULT 'Arrived',
    arrival_date DATE NOT NULL DEFAULT (CURDATE()),
    delivery_date DATE DEFAULT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE
);

-- Parcel OTPs Table
CREATE TABLE parcel_otps (
    id INT AUTO_INCREMENT PRIMARY KEY,
    parcel_id VARCHAR(20) NOT NULL,
    student_id INT NOT NULL,
    otp_code VARCHAR(6) NOT NULL,
    status ENUM('Active', 'Used', 'Expired') NOT NULL DEFAULT 'Active',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    expires_at DATETIME NULL,
    used_at DATETIME DEFAULT NULL,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE
);
```

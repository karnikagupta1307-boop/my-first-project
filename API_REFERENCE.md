# RESTful API Reference - Smart Parcel Management System

## Base URL
```
http://localhost:3000
```

---

## Authentication APIs

### 1. Student Registration
**POST** `/api/register`

Register a new student in the system.

**Request Body:**
```json
{
  "name": "Rahul Sharma",
  "sap_id": "12345678901",
  "phone": "9876543210",
  "email": "rahul.sharma@nmims.edu",
  "password": "student123"
}
```

**Response:**
```json
{
  "message": "Registration successful",
  "studentId": 87
}
```

---

### 2. Student Login
**POST** `/api/login`

Authenticate student and create session.

**Request Body:**
```json
{
  "sap_id": "12345678901",
  "password": "student123"
}
```

**Response:**
```json
{
  "success": true,
  "role": "student",
  "student": {
    "id": 87,
    "name": "Rahul Sharma",
    "sap_id": "12345678901",
    "email": "rahul.sharma@nmims.edu"
  }
}
```

---

### 3. Admin Login
**POST** `/api/admin/login`

Authenticate admin user.

**Request Body:**
```json
{
  "username": "admin",
  "password": "admin123"
}
```

**Response:**
```json
{
  "success": true,
  "role": "admin",
  "message": "Login successful"
}
```

---

### 4. Logout
**POST** `/api/logout`

Clear user session.

**Response:**
```json
{
  "success": true,
  "message": "Logged out successfully"
}
```

---

## Parcel Management APIs

### 5. Get All Parcels
**GET** `/api/parcels`

Retrieve all parcels (Admin/Delivery Person only).

**Response:**
```json
[
  {
    "id": 92,
    "parcel_id": "1",
    "student_id": 87,
    "student_name": "Rahul Sharma",
    "sap_id": "12345678901",
    "phone": "9876543210",
    "email": "rahul.sharma@nmims.edu",
    "source": "Amazon",
    "delivery_person": "John Doe",
    "delivery_phone": "9876543211",
    "status": "Arrived",
    "arrival_date": "2026-04-15T18:30:00.000Z",
    "delivery_date": null,
    "created_at": "2026-04-15T18:30:00.000Z"
  }
]
```

---

### 6. Get Student Parcels
**GET** `/api/student/parcels?sap_id=12345678901`

Retrieve parcels for a specific student.

**Query Parameters:**
- `sap_id` (optional): Student SAP ID
- `phone` (optional): Student phone number

**Response:**
```json
[
  {
    "id": 92,
    "parcel_id": "1",
    "student_name": "Rahul Sharma",
    "sap_id": "12345678901",
    "source": "Amazon",
    "status": "Arrived",
    "arrival_date": "2026-04-15T18:30:00.000Z"
  }
]
```

---

### 7. Add New Parcel
**POST** `/api/parcels`

Add a new parcel to the system.

**Request Body:**
```json
{
  "student_name": "Rahul Sharma",
  "sap_id": "12345678901",
  "phone": "9876543210",
  "email": "rahul.sharma@nmims.edu",
  "source": "Amazon",
  "delivery_person": "John Doe",
  "delivery_phone": "9876543211"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Parcel added successfully",
  "parcelId": "25"
}
```

---

### 8. Search Parcels
**GET** `/api/parcels/search?query=rahul`

Search parcels by student name, SAP ID, phone, email, or source.

**Query Parameters:**
- `query` (required): Search term

**Response:**
```json
[
  {
    "id": 92,
    "parcel_id": "1",
    "student_name": "Rahul Sharma",
    "sap_id": "12345678901",
    "source": "Amazon",
    "status": "Arrived"
  }
]
```

---

## OTP APIs

### 9. Generate OTP
**POST** `/api/otp/generate`

Generate OTP for parcel handover.

**Request Body:**
```json
{
  "parcel_id": "1",
  "email": "rahul.sharma@nmims.edu"
}
```

**Response:**
```json
{
  "success": true,
  "message": "OTP generated and sent to email",
  "otp": "123456"
}
```

---

### 10. Verify OTP
**POST** `/api/otp/verify`

Verify OTP and complete parcel handover.

**Request Body:**
```json
{
  "parcel_id": "1",
  "otp": "123456"
}
```

**Response (Success):**
```json
{
  "success": true,
  "message": "OTP verified successfully",
  "parcel": {
    "id": 92,
    "parcel_id": "1",
    "status": "Delivered",
    "delivery_date": "2026-04-16T10:30:00.000Z"
  }
}
```

**Response (Invalid OTP):**
```json
{
  "success": false,
  "message": "Invalid OTP"
}
```

**Response (Expired OTP):**
```json
{
  "success": false,
  "message": "OTP has expired"
}
```

---

### 11. Resend OTP
**POST** `/api/otp/resend`

Resend OTP to student's email.

**Request Body:**
```json
{
  "parcel_id": "1"
}
```

**Response:**
```json
{
  "success": true,
  "message": "OTP resent successfully",
  "otp": "654321"
}
```

---

## Student APIs

### 12. Get Student by Phone
**GET** `/api/student/lookup?phone=9876543210`

Lookup student details by phone number.

**Response:**
```json
{
  "success": true,
  "student": {
    "id": 87,
    "name": "Rahul Sharma",
    "sap_id": "12345678901",
    "phone": "9876543210",
    "email": "rahul.sharma@nmims.edu"
  }
}
```

---

### 13. Get Student by Name and Phone
**GET** `/api/student/lookup?name=Rahul&phone=9876543210`

Lookup student by name and phone for verification.

**Response:**
```json
{
  "success": true,
  "student": {
    "id": 87,
    "name": "Rahul Sharma",
    "sap_id": "12345678901",
    "email": "rahul.sharma@nmims.edu"
  }
}
```

---

## Dashboard APIs

### 14. Get Dashboard Stats
**GET** `/api/dashboard/stats`

Get system statistics for admin dashboard.

**Response:**
```json
{
  "total_parcels": 150,
  "arrived_parcels": 45,
  "delivered_parcels": 105,
  "today_parcels": 8,
  "pending_otp": 12
}
```

---

## Error Responses

All APIs return consistent error responses:

### 400 Bad Request
```json
{
  "error": "Missing required fields",
  "details": ["student_name", "sap_id"]
}
```

### 401 Unauthorized
```json
{
  "error": "Authentication required"
}
```

### 403 Forbidden
```json
{
  "error": "Insufficient permissions"
}
```

### 404 Not Found
```json
{
  "error": "Parcel not found"
}
```

### 500 Internal Server Error
```json
{
  "error": "Internal server error",
  "message": "Database connection failed"
}
```

---

## HTTP Status Codes

| Code | Meaning |
|------|---------|
| 200 | OK - Request successful |
| 201 | Created - Resource created successfully |
| 400 | Bad Request - Invalid input data |
| 401 | Unauthorized - Authentication required |
| 403 | Forbidden - Insufficient permissions |
| 404 | Not Found - Resource not found |
| 500 | Internal Server Error - Server error |

---

## Authentication & Security

- All APIs (except login/register) require session authentication
- Sessions are managed via HTTP cookies
- Passwords are hashed using bcrypt
- OTPs are 6-digit codes sent via email
- OTPs remain valid until parcel is collected (no time expiry)

---

## Data Types

| Field | Type | Description |
|-------|------|-------------|
| `parcel_id` | String | Sequential parcel number (1, 2, 3...) |
| `sap_id` | String | 11-digit student SAP ID |
| `phone` | String | 10-digit phone number |
| `status` | Enum | `Arrived` or `Delivered` |
| `arrival_date` | ISO Date | UTC timestamp when parcel arrived |
| `delivery_date` | ISO Date | UTC timestamp when parcel was delivered |
| `otp` | String | 6-digit verification code |

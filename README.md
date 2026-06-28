# Expense Tracker

A Java web application combining user authentication with personal expense tracking, built using Servlets, JSP, and PostgreSQL (hosted on AWS RDS).

## Overview

This project lets users register, log in, and manage their personal expenses through a simple dashboard. The backend is built with Java Servlets handling JSON-based requests, with a DAO layer abstracting database operations against PostgreSQL.

## Features

- **User Authentication**
  - Signup with username/password
  - Login with session-based auth
  - Logout endpoint that invalidates the session
- **Expense Management**
  - Add new transactions (type, amount, category, description, date)
  - Retrieve transaction/dashboard data per logged-in user
- **JSON API responses** for all auth and transaction operations

## Tech Stack

- **Language:** Java
- **Web Layer:** Jakarta Servlets, JSP
- **Database:** PostgreSQL (AWS RDS)
- **Build Tool:** Maven
- **Server:** Apache Tomcat 10
- **Deployment:** Tested locally (IntelliJ + Smart Tomcat) and on AWS EC2

## Project Structure
<img width="458" height="321" alt="Screenshot 2026-06-28 at 3 21 12 PM" src="https://github.com/user-attachments/assets/3c398a03-555c-4396-9aee-e6d4e79a73bf" />
## API Endpoints

### `POST /auth`
Handles login, signup, and logout based on the `action` parameter.

| Action     | Parameters                  | Description                          |
|------------|------------------------------|---------------------------------------|
| `login`    | `username`, `password`       | Authenticates user, starts session    |
| `signup`   | `username`, `password`       | Creates a new user account            |
| `logout`   | —                             | Invalidates current session           |

**Example responses:**
```json
{"status":"success","message":"Login successful"}
{"status":"error","message":"Invalid credentials"}
{"status":"error","message":"Username already taken"}
```

### `GET /transaction?action=list`
Returns dashboard data for the currently logged-in user (requires active session).

### `POST /transaction`
Adds a new expense transaction for the logged-in user.

| Parameter     | Type   | Description                       |
|---------------|--------|------------------------------------|
| `type`        | String | Transaction type (e.g. income/expense) |
| `amount`      | double | Transaction amount                |
| `category`    | String | Expense category                  |
| `description` | String | Optional note                     |
| `date`        | String | Date (defaults to current date if omitted) |

## Prerequisites

- Java JDK 11+
- Maven
- PostgreSQL database (local or AWS RDS)
- Apache Tomcat 10

## Setup & Installation

1. **Clone the repository**
```bash
   git clone https://github.com/maharsaad/expense-tracker.git
   cd expense-tracker
```

2. **Configure the database connection**
   Set the following environment variables (do not hardcode credentials in source):
```bash
   export DB_URL="jdbc:postgresql://<your-db-host>:5432/<your-db-name>"
   export DB_USER="<your-db-username>"
   export DB_PASSWORD="<your-db-password>"
```

3. **Build the project**
```bash
   ./mvnw clean package
```

4. **Deploy**
   - Deploy the generated `.war` from `target/` to your Tomcat `webapps` directory, or
   - Run directly via IntelliJ using the Smart Tomcat plugin
## Database Schema (expected tables)

- **users**: `id`, `username`, `password`
- **transactions**: `username`, `type`, `amount`, `category`, `description`, `date`

## Usage

1. Open the app and sign up for a new account, or log in with existing credentials
2. On successful login, you're redirected to the dashboard
3. Add expense/income transactions with category and description
4. View your transaction history on the dashboard

## Security Notes

- Passwords are currently stored and compared in plaintext — **not production-safe**. Recommend hashing with BCrypt before any real deployment.
- Database credentials must be supplied via environment variables, never committed to source control.

- ## Deployment

This project is deployed on **AWS EC2** (ap-south-1 region) running Apache Tomcat 10, with the database hosted on AWS RDS (PostgreSQL).

- **Live URL:** http://13.235.0.85:8080/expense-tracker
- **Server:** AWS EC2 instance
- **Database:** AWS RDS (PostgreSQL)
- **Reverse Proxy:** Apache2 (for cleaner URL routing)

> Note: This is a personal/academic project; the deployment may not always be live.

## Future Improvements

- Password hashing (BCrypt/Argon2)
- Expense filtering and categorization views
- Charts/graphs for spending trends
- REST API refactor for frontend/mobile integration
- Pagination for transaction history
- ## Screenshots

### Login Page
<img width="1432" height="766" alt="Screenshot 2026-06-28 at 3 26 01 PM" src="https://github.com/user-attachments/assets/6d2092ae-7a85-4619-b763-95b74f13ea6d" />

### Signup Page
<img width="1434" height="777" alt="Screenshot 2026-06-28 at 3 27 04 PM" src="https://github.com/user-attachments/assets/c6002d3a-4a9a-40f2-b47b-2ea75f5842cd" />


### Dashboard
<img width="1440" height="900" alt="Screenshot 2026-06-28 at 3 27 32 PM" src="https://github.com/user-attachments/assets/47cd9350-57f4-4e9f-819c-4df501fb8e63" />



## Author

**Mahar Saad**
GitHub: [@maharsaad](https://github.com/maharsaad)

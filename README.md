# Bookist: Bookstore Management System

## Overview

Bookist is a comprehensive bookstore management system designed to streamline the entire book-selling lifecycle. It caters to three distinct user roles—Customers, Managers, and Delivery Agents—enabling browsing, purchasing, order fulfillment, inventory management, and analytics under one unified platform.

## Table of Contents

1. [Features](#features)
2. [Installation](#installation)
3. [Usage](#usage)
4. [Project Structure](#project-structure)
5. [Contributing](#contributing)
6. [License](#license)
7. [Contact](#contact)

## Features

Bookist supports three main roles, each with dedicated functionality:

### 1. Customer

* **Account Management**

  * Login with username & password
  * Update profile (address, contact, payment info)
* **Readlists**

  * Create and manage lists (Want to Read, Liked, Disliked)
* **Browsing & Purchasing**

  * Browse books by genre, author, popularity
  * Search by title, author, or keyword
  * Add books to cart & secure checkout
  * Order tracking from placement to delivery
* **Reviews & Ratings**

  * Write/read book reviews
  * Rate stores and share shopping experience

### 2. Manager

* **Store & Inventory Management**

  * Add, edit, remove books
  * Track stock levels & set reordering
* **Order Management**

  * View, process, and ship orders
  * Handle returns & refunds as per policy
* **Staff & Delivery Oversight**

  * Assign tasks to delivery agents
  * Monitor performance metrics
* **Reporting & Analytics**

  * Generate sales reports (top sellers, revenue breakdown)
  * Inventory reports (fast-moving items, low-stock alerts)

### 3. Delivery Agent

* **Delivery Management**

  * Accept or reject assigned orders
  * Built‑in navigation to customer addresses
  * Confirm delivery & collect feedback

## Installation

Follow these steps to get Bookist running locally:

1. **Prerequisites**

   * Node.js (v14 or above)
   * npm or yarn
   * MySQL

2. **Clone the repository**

   ```bash
   git clone https://github.com/Tejusmadan/BookistDB
   cd bookist
   ```

3. **Install dependencies**

   ```bash
   npm install       # or yarn install
   ```

4. **Configure your environment**

   * Copy `.env.example` to `.env`
   * Set your database URL, port, and secret keys

5. **Database setup**

   ```bash
   npm run db:migrate   # run migrations
   npm run db:seed      # optional seed data
   ```

## Usage

* **Start in development mode**

  ```bash
  npm run dev
  ```

* **Start in production mode**

  ```bash
  npm start
  ```

Visit `http://localhost:3000` in your browser to access the application.

## Project Structure

```
bookist/
├── server/          # Backend (Express, DB models, controllers)
├── client/          # Frontend (React, components, pages)
├── migrations/      # Database migration scripts
├── seeds/           # Seed data scripts
├── .env.example     # Example env variables
├── package.json     # Scripts & dependencies
└── README.md        # This file
```

## License

This project is licensed under the [MIT License](LICENSE).

## Contact

For questions or feedback, please reach out to:

* **Project Maintainer**: [tejus22540@iiitd.ac.in](mailto:tejus22540@iiitd.ac.in)

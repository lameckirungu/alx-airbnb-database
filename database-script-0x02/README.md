# Database Seeding (Sample Data)
This directory contains the **SQL script** required to populate the database with sample data for development and testing.
---

## Objective
The primary goal of the script is `seed.sql` is to:
1. **Populate all tables** with interconnected, realistic sample data.
2. **Demonstrate real-world scenarios**, including confirmed bookings with paymnets, pendingi bookings, user reviews and messages.
3. **Be re-runnable** by automatically clearing old data before inserting new data.

## 2. Sample Data Highlights
The script creates a small ecosystem of users and interactions:
* **3 Users:** 2 hosts (one of whom is also a guest) and 1 dedicated guest.
* **2 Properties:** One "Cozy Cabin" and one "Urban Loft," listed by the two hosts.
* **3 Bookings:** One `confirmed`, one `pending`, and one `cancelled`.
* **1 Payment:** Linked to the `confirmed` booking.
* **1 Review:** Left by a guest for a completed (confirmed) stay.
* **2 Messages:** A sample conversation between a guest and a host.

---

## 3. Usage
To run this script and populate your `airbnb_clone` database, use the `psql` command-line tool.

**Prerequisite:** You must have already run the `schema.sql` script from the `database-script-0x01` directory.

```bash
# Run this command from the root of the 'alx-airbnb-database' directory
psql -h localhost -U admin -d airbnb_clone -f database-script-0x02/seed.sql
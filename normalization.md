# Database Normalization
The objective of this process is to ensure database schema for the Airbnb Clone Project meets the requirements of the Third Normal Form (3NF), minimizing data redundancy and ensuring data integrity.

## 1. First Normal Form (1NF) Justification
**Rule:** A table is in 1NF if every column contains only atomic (single, indivisible) values, and there are no repeating groups.

***Compliance:*** All tables in the schema (User, Property, Booking, Payment, Review, Message) satisfy 1NF.

* ***Atomicity:*** Each attribute, such as `email`, `start_date`, and `pricepernight`, holds a single, non-repeating value. No field contains comma-separated lists or arrays of data.
* ***Repeating Groups:*** There are no colums like `phone_number_1`, `phone_number_2`. For instance, the `phone_number` field in the User table is designed to hold only a single value.

---
## 2. Second Normal Form (2NF) Justification
**Rule:** A table is in 2NF if it is in 1NF, and no non-key attribute is dependent on only *part* of a composite Primary Key.

**Compliance:** All tables in the schema satisfy 2NF.

* ***Key Structure:*** Every table uses a **single-column PK** (`UUID`) to uniquely identify its rows. (eg. `user_ID`, `property_ID`, `booking_ID`).
* ***Result:*** Since no composite (multi-column) PKs are used, it is impossibel for a non-key attribute to exhibit a partial dependency on the key. Every non-key column is automatically fully dependent on the entire PK.
---

## 3. Third Normal Form (3NF) Justification
**Rule:** A table is in 3NF is it is in 2NF, and no non-key attribute is transitively dependent on the PK. That is, no non-key column depends on another non-key column.

**Compliance:** All tables in the schema satisfy 3NF.

| Table | Primary Key (PK) | Non-Key Attribute Check | Conclusion |
| :--- | :--- | :--- | :--- |
| **USER**|`user_ID`| All attributes (`first_name`, `email`, `role`, etc) depend directly on `user_id`. No non-key attribute determines another non-key attribute.| ***Therefore, Passes 3NF***|
| **PROPERTY**|`property_ID`| All attributes (`name`, `location`, `pricepernight`) depend directly on `property_ID`. The FK, (`host_ID`) is essential for the property and does not determine any other non-key attribute in this table. | ***Passes 3NF***|
| **BOOKING**|`booking_ID`| Attributes like `start_date`, `end_date`, and `total_price` depend solely on the `booking_ID`. | ***Passes 3NF***|

**Final Conclusion:** The database design effectively minimizes redudancy and maintains data integrity, confirmming compliance with the Third Normal Form (3NF).

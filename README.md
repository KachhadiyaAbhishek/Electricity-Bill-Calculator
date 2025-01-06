# Electricity Bill Calculator and analysis

This project is an implementation of an Electricity Billing System using PostgreSQL. It includes creating tables, inserting records, calculating bills, updating records, and querying customer and billing information.

## Features

1. **Customer Management**
   - Create a `Customer` table to store customer details.
   - Insert customer records.
   - Update customer readings.

2. **Bill Calculation**
   - Create an `Electric_bill` table to store billing details.
   - Calculate electricity bills based on units consumed and supply type.
   - Automatically compute energy charges, fixed charges, government duty, and total amount.

3. **Procedures**
   - Insert customer details.
   - Calculate electricity bills.
   - Update customer readings.

4. **Queries**
   - Display all customers.
   - Display all billing records.
   - Identify customers who have not paid their last bill.

## Database Structure

### `Customer` Table

| Column Name       | Data Type      | Description                    |
|-------------------|----------------|--------------------------------|
| `customer_id`     | `int`          | Primary key.                   |
| `customer_Name`   | `varchar(50)`  | Customer's name.               |
| `address`         | `varchar(50)`  | Customer's address.            |
| `contact_no`      | `numeric(20)`  | Customer's contact number.     |
| `meter_no`        | `numeric(20)`  | Customer's meter number.       |
| `supply_type`     | `varchar(20)`  | Supply type (`Single`/`Three`).|
| `billing_month`   | `varchar(20)`  | Billing month.                 |
| `reading_date`    | `date`         | Reading date.                  |
| `previous_reading`| `numeric(20)`  | Previous meter reading.        |
| `current_reading` | `numeric(20)`  | Current meter reading.         |
| `last_bill_payment` | `varchar(10)` | Whether the last bill was paid.|

### `Electric_bill` Table

| Column Name       | Data Type      | Description                    |
|-------------------|----------------|--------------------------------|
| `meter_no`        | `numeric(20)`  | Primary key. Links to `Customer`.|
| `customer_id`     | `int`          | Links to `Customer.customer_id`.|
| `units`           | `numeric(20)`  | Total units consumed.          |
| `Energy_charges`  | `numeric(20)`  | Energy charges based on units. |
| `Fixed_charges`   | `int`          | Fixed charges based on type.   |
| `Govt_duty`       | `numeric(20)`  | Government duty (15%).         |
| `Total_Amount`    | `numeric(20)`  | Total bill amount.             |

## Procedures and Queries

### 1. Insert Customer Details
**Procedure:** `insert_customer_details`

This procedure inserts a new record into the `Customer` table.

```sql
CALL insert_customer_details(
    customer_id, customer_Name, address, contact_no, meter_no,
    supply_type, billing_month, reading_date, previous_reading,
    current_reading, last_bill_payment
);
```

### 2. Calculate Electricity Bill
**Procedure:** `calculate_bill`

This procedure calculates the electricity bill for a customer based on units consumed and inserts the data into the `Electric_bill` table.

```sql
CALL calculate_bill(customer_id);
```

### 3. Update Customer Readings
**Procedure:** `update_reading`

This procedure updates the previous and current readings for a specific customer.

```sql
CALL update_reading(customer_id, previous_reading, current_reading);
```

### 4. Identify Unpaid Bills
This query retrieves customers who have not paid their last bill.

```sql
DO $$
DECLARE
    select_customer Customer%rowtype;
pay_cursor CURSOR FOR SELECT * FROM Customer WHERE last_bill_payment = 'NO';
BEGIN
    OPEN pay_cursor;
    LOOP
        FETCH pay_cursor INTO select_customer;
        EXIT WHEN NOT FOUND;
        RAISE NOTICE 'Customer ID: %, Name: %, Address: %, Contact: %, Meter No: %, Billing Month: %',
                    select_customer.customer_id, select_customer.customer_Name, select_customer.address,
                    select_customer.contact_no, select_customer.meter_no, select_customer.billing_month;
    END LOOP;
    CLOSE pay_cursor;
END;
$$;
```

### 5. View All Records
- View all customers:

```sql
SELECT * FROM Customer;
```

- View all bills:

```sql
SELECT * FROM Electric_bill;
```

## Usage Instructions

1. Set up a PostgreSQL database.
2. Create the `Customer` and `Electric_bill` tables using the provided SQL scripts.
3. Insert initial customer data.
4. Use the procedures to calculate bills, insert data, and update records as required.
5. Run queries to retrieve and analyze data.

## Notes
- Ensure that the `Customer` table is populated before running the `calculate_bill` procedure.
- Fixed charges are based on the supply type:
  - `Single Phase`: ₹25
  - `Three Phase`: ₹65
- Energy charges are calculated as follows:
  - First 50 units: ₹3.20/unit
  - Next 200 units: ₹3.95/unit
  - Units above 250: ₹5.00/unit

## Example Data
### Sample `Customer` Table
| customer_id | customer_Name | address       | contact_no | meter_no | supply_type  | billing_month | reading_date | previous_reading | current_reading | last_bill_payment |
|-------------|---------------|---------------|------------|----------|--------------|---------------|--------------|------------------|-----------------|-------------------|
| 1           | Abhishek K.   | Memnagar      | 8849253814 | 111      | Single Phase | July 2023     | 01/07/2023   | 230              | 400             | YES               |

### Sample `Electric_bill` Table
| meter_no | customer_id | units | Energy_charges | Fixed_charges | Govt_duty | Total_Amount |
|----------|-------------|-------|----------------|---------------|-----------|--------------|
| 111      | 1           | 170   | ₹748.50        | ₹25           | ₹116.78   | ₹890.28      |

## License
This project is open-source and free to use for educational purposes.

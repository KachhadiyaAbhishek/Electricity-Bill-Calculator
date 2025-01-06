----------------------------------------------------------------
------------------Electricity Billing System--------------------
----------------------------------------------------------------

--------------------Create Customer Table-----------------------

/*create table Customer(
	customer_id int primary key,
	customer_Name varchar(50) not null,
	address varchar(50) not null,
	contact_no numeric(20) not null,
	meter_no numeric(20) not null,  
	supply_type varchar(20),
	billing_month varchar(20),
	reading_date date,
	previous_reading numeric(20),
	current_reading numeric(20),
	last_bill_payment varchar(10));*/
	
/*insert into Customer values
		(1,'ABHISHEK KACHHADIYA','MEMNAGAR',8845698814,111,'Single Phase','July 2023','01/07/2023',230,400,'YES'),
		(2,'KESHAV PATEL','SCIENCE CITY',8956267845,112,'Single Phase','July 2023','01/07/2023',500,950,'YES'),
		(3,'PUJA SHAH','BOPAL',9965865231,123,'Single Phase','July 2023','01/07/2023',405,852,'NO'),
		(4,'MUKESH DOSHI','PALDI',8956234578,126,'Three Phase','July 2023','02/07/2023',601,1000,'YES'),
		(5,'RAJESH SHARMA','BOPAL',9563254152,128,'Three Phase','July 2023','02/07/2023',650,1056,'NO');*/

--select * from Customer;

--------------------Create Electric Bill Table-------------------

/*create table Electric_bill(
	meter_no numeric(20) primary key,
	customer_id int,
	units numeric(20),
	Energy_charges numeric(20),
	Fixed_charges int,
	Govt_duty numeric(20),
	Total_Amount numeric(20),
	foreign key (customer_id) references Customer (customer_id));*/

--select * from Electric_bill;

-----------------------------------------------------------------
-----calculate bill and insert data into Electric_bill table-----

/*create or replace procedure calculate_bill(ID int)
as $$
declare
	customerID Customer.customer_id%type;
	meterNo Customer.meter_no%type;
	supplyType Customer.supply_type%type;
	previousReading Customer.previous_reading%type;
	currentReading Customer.current_reading%type;
	unit Electric_bill.units%type;
	energyCharges Electric_bill.Energy_charges%type;
	fixedCharges Electric_bill.Fixed_charges%type;
	govtDuty Electric_bill.Govt_duty%type;
	totalAmount Electric_bill.Total_Amount%type;
	totalUnit numeric := 0;
bill_cursor cursor for select customer_id, meter_no, supply_type, previous_reading, current_reading from Customer where customer_id=ID;
begin
 open bill_cursor;
 loop
 	fetch bill_cursor into customerID,meterNo,supplyType,previousReading,currentReading;
	Exit when not found;
	unit := currentReading - previousReading;
	totalUnit := unit;
	if unit>51 then
		energyCharges := 50*3.20;
		unit := unit - 50;
		if unit>201 then
			energyCharges := energyCharges+(200*3.95);
			unit := unit - 200;
			if unit>0 then
				energyCharges := energyCharges+(unit*5);
			 end if;
		else
			energyCharges := energyCharges+(unit*3.95);
			end if;
	else 
		energyCharges := unit*3.20;
	end if;
	
	if supplyType='Single Phase' then
		fixedCharges := 25;
	else
	 	fixedCharges := 65;
	end if;
	 
	totalAmount := energyCharges+fixedCharges;
	govtDuty := totalAmount*0.15;
	totalAmount := totalAmount+govtDuty;
	
	insert into Electric_bill values(meterNo,customerID,totalUnit,energyCharges,fixedCharges,govtDuty,totalAmount);
	if found then
		raise notice 'inserted successfully...';
	else
		raise notice 'failed insert...';
	end if;
    end loop;
close bill_cursor;
End;
$$
language plpgsql;*/

--call calculate_bill(1);
--select * from Electric_bill;

-----------------------------------------------------------------
---------------Procedure to insert customer details--------------

/*create or replace procedure insert_customer_details(
	customer_id int,
	customer_Name varchar(50),
	address varchar(50),
	contact_no numeric(20),
	meter_no numeric(20),  
	supply_type varchar(20),
	billing_month varchar(20),
	reading_date date,
	previous_reading numeric(20),
	current_reading numeric(20),
	last_bill_payment varchar(10))
as $$
Declare
Begin
	insert into Customer Values(customer_id, customer_Name, address, contact_no, meter_no, supply_type, 
						 billing_month, reading_date, previous_reading, current_reading, last_bill_payment);
	if found then
		raise notice 'coustomer inserted successfully...';
	else
		raise notice 'failed insert...';
	end if;
End;
$$
language plpgsql;*/

--call insert_customer_details(6,'RAJESH JOSHI','VASTRAPUR',9865257859,128,'Single Phase','July 2023','03/07/2023',920,1280,'YES');
--select * from Customer;

-----------------------------------------------------------------
----------------------last bill not pay--------------------------

/*Do $$
declare
    select_customer Customer%rowtype;
pay_cursor cursor for select * from Customer where last_bill_payment = 'NO';
begin
	open pay_cursor;
	loop
	fetch pay_cursor into select_customer;
	exit when not found;	
	   	raise notice 'customer id: %, 
					 customer name: %, 
					 Address: %, 
					 contact no: %, 
					 meter no: %, 
					 billing month: %',
					 select_customer.customer_id, select_customer.customer_Name, select_customer.address, select_customer.contact_no,
					 select_customer.meter_no,select_customer.billing_month;
	 end loop;
	 close pay_cursor;
End;
$$*/

-----------------------------------------------------------------
----------------Update customer Reading by id------------------

/*create or replace procedure update_reading(
	ID int,
	previous_reading2 numeric(20),
	current_reading2 numeric(20))
as $$
begin
	update Customer set previous_reading = previous_reading2, current_reading = current_reading2 where Customer_id = ID;
	if found then
	raise notice 'update successfully...';
	else
	raise notice 'update failed...';
	end if;
End;
$$
language plpgsql;*/

--call update_reading(3,506,956);
--select * from Customer;

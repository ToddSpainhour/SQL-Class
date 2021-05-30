
-- practice question: Write a query that returns the business name, city, state, and website for each dealership. Use an alias for the Dealerships table.

	select 
		d.business_name,
		d.city,
		d.state,
		d.website
	from dealerships d 




-- practice question: Write a query that returns the first name, last name, and email address of every customer. Use an alias for the Customers table.

	select
		c.first_name,
		c.last_name,
		c.email
	from customers c 




----- Book 2 Chapter 2 Filtering Data -----

	select
		last_name, first_name, city, state
	from
		customers 
	where
		state = 'TX';	
	
	-----
	
	select
		last_name, first_name, city, state
	from
		customers 
	where
		city = 'Houston' and state = 'TX';
	
	-----
	
	select
		last_name, first_name, city, state
	from
		customers 
	where
		state = 'TX' or state = 'TN';	
	
	-----
	
	SELECT
		last_name, first_name, city, state
	FROM
		customers
	WHERE
		state IN ('TX', 'TN', 'CA');	





--Practice Question - Get a list of sales records where the sale was a lease.

	select *
	from sales s 
	where sales_type_id = 2



	
--Practice Question - Get a list of sales where the purchase date is within the last two years.
	
	select *
	from sales s 
	where purchase_date > '2019-05-29'
	order by purchase_date 
	



--Practice Question - Get a list of sales where the deposit was above 5000 or the customer payed with American Express.

select *
from sales s 
where s.deposit > 5000 OR s.payment_method = 'americanexpress'




--Practice Question - Get a list of employees whose first names start with "M" or ends with "E".  STOPPED HERE ---

select *
from employees e 
where e.first_name like 'M%'
or e.first_name like '%E' 





-------------group project stuff

select *
from vehicletypes v 

--create the new tables (vehiclebodytype, vehiclemodel, vehiclemake)

create table VehicleBodyType (
	vehicle_body_type_id INT primary key generated always as identity,
	name VARCHAR(20)
);

create table VehicleModel (
	vehicle_model_id INT primary key generated always as identity,
	name VARCHAR(20)
);

create table VehicleMake (
	vehicle_make_id INT primary key generated always as identity,
	name VARCHAR(20)
);


select *
from vehiclebodytype v 


select *
from vehicleModel


select *
from vehiclemake v 


select *
from vehicletypes v 


--- data migration --

-- A data migration will need to take place for Carnival where we will convert text to integers. 
-- Since that is not a learning requirment at this point we are providing the SQL script for you to conduct this.
-- The result of the script will change all the text words to id integers. 
-- The important thing to note is that the data migration script does not change the datatype of these fields.
-- You will be respnonsible for changing the datatype in the next practice below.


-- the data migration code... you still need to create a body_type table
-- do the data migration before the alter table

-- to enforce capitalization in table names surround them in double quotes when creating the table

select *
from vehicleTypes
	
	



----- Book 2 Chapter 3 JOINING DATA -----

--Practice Question - Get a list of the sales that were made for each sales type.

select *
from sales s 
inner join salestypes st
on s.sales_type_id = st.sales_type_id 




--Practice Question - Get a list of sales with the VIN of the vehicle, 
--the first name and last name of the customer, 
--first name and last name of the employee who made the sale 
--and the name, city and state of the dealership.

select 
	vin, 
	c.first_name as "customer first name", 
	c.last_name as "customer last name", 
	e.first_name as "employee first name", 
	e.last_name  as "employee last name",
	d.business_name,
	d.city as "dealership city",
	d.state as "dealership state"
from sales s 
join vehicles v 
on s.vehicle_id = v.vehicle_id 
join customers c 
on s.customer_id = c.customer_id 
join employees e 
on s.employee_id = e.employee_id 
join dealerships d 
on s.dealership_id = d.dealership_id 




--Practice Question - Get a list of all the dealerships and the employees, if any, working at each one.

select 
	d.business_name as "dealership name",
	e.first_name as "employee first name",
	e.last_name as "employee last name"
from dealerships d 
join dealershipemployees de 
on d.dealership_id = de.dealership_id 
join employees e 
on de.dealership_employee_id = e.employee_id 
order by business_name 



--Practice Question - Get a list of vehicles with the names of the body type, make, model and color.
 






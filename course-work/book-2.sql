
-- Book 2 - Basic Query

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

--Practice Question - Get a list of sales records where the sale was a lease.

	select *
	from sales s 
	where sales_type_id = 2
	
	-- since some databases don't match, this would be safer...
	
	select *
	from sales s 
	join salestypes st 
	on s.sales_type_id = st.sales_type_id 
	where name = 'Lease'



--Practice Question - Get a list of sales where the purchase date is within the last two years.
	
	select *
	from sales s 
	where purchase_date > '2019-05-29'
	order by purchase_date 
	
	-- even better would be...
	
	select count(sale_id)
	from sales s 
	where purchase_date >= now() - interval '2years'
	--where purchase_date between >= current_date - interval'2years'
	



--Practice Question - Get a list of sales where the deposit was above 5000 or the customer payed with American Express.

select *
from sales s 
where s.deposit > 5000 OR s.payment_method = 'americanexpress'

--operator 

select *
from sales s 
where s.deposit > 5000 OR s.payment_method ilike 'american%'




--Practice Question - Get a list of employees whose first names start with "M" or ends with "E".  STOPPED HERE ---

select *
from employees e 
where e.first_name like 'M%'
or e.first_name like '%E' 


-- or... ilike ignores casing

select *
from employees e 
where e.first_name ilike 'M%'
or e.first_name ilike '%E' 




--Practice Question - Get a list of employees whose phone numbers have the 604 area code.

select *
from employees e 
where e.phone like '604%'




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
	v.vin, 
	c.first_name as "customer first name", 
	c.last_name as "customer last name", 
	e.first_name as "employee first name", 
	e.last_name  as "employee last name",
	d.business_name,
	d.city as "dealership city",
	d.state as "dealership state"
from sales s 
join vehicles v on s.vehicle_id = v.vehicle_id 
join customers c on s.customer_id = c.customer_id 
join employees e on s.employee_id = e.employee_id 
join dealerships d on s.dealership_id = d.dealership_id 



--Practice Question - Get a list of all the dealerships and the employees, if any, working at each one.

select 
	d.business_name as "dealership name",
	e.first_name as "employee first name",
	e.last_name as "employee last name"
from dealerships d 
join dealershipemployees de on d.dealership_id = de.dealership_id 
join employees e on de.dealership_employee_id = e.employee_id 
order by business_name 


--Practice Question - Get a list of vehicles with the names of the body type, make, model and color.
 
select 
	vbt.name as "Body Type",
	vm.name as "Make",
	vmod.name as "Model",
	v.exterior_color as "Color"
from vehicletypes vt
	join vehiclebodytype vbt 
		on vbt.vehicle_body_type_id  = vt.body_type::int
	join vehiclemake vm 
		on vm.vehicle_make_id = vt.make::int
	join vehiclemodel vmod 
		on vmod.vehicle_model_id = vt.model::int
	join vehicles v 
		on v.vehicle_type_id = vt.vehicle_type_id 



----- Book 2 Chapter 4 COMPLEX JOINS -----


--Practice Question - Produce a report that lists every dealership, the number of purchases done by each, and the number of leases done by each.

select *
from dealerships d
--dealership_id, business_name

select *
from sales s
-- has dealership_id, sales_type_id

select *
from salestypes st 
-- sales_type-id, name


-- only show dealership once
-- count of purchases
-- count of leases

--STOPPED HERE
select 
	distinct d.dealership_id as "dealership id",
	d.business_name
from dealerships d 
left join sales s 
on s.dealership_id = d.dealership_id 
order by d.dealership_id 


-- go into sales and count how many leases each dealership id has






--Practice Question - Produce a report that determines the most popular vehicle model that is leased.

select * from sales s 
select * from vehicletypes v

-- get all leases from sales, join with vehicletypes on vehicle-type-id, find the most repeated number in the model column

select 
	s.sales_type_id,
	s.vehicle_id,
	vt.model
from sales s 
join vehicletypes vt 
on s.vehicle_id = vt.vehicle_type_id 
where s.sales_type_id = 2
order by vt.model 


order vt.model 


join vehiclemodel vm 
s.vehicle_id = vm.

select *
from vehiclemodel vm 

--need sales
-- find largest reoccuring vehicle model
--need salestypes








--Practice Question - What is the most popular vehicle make in terms of number of sales?




--Practice Question - Which employee type sold the most of that make?





-- Chapter 8 -- Carnival Sales Practice Questions

-- Write a query that shows the total purchase sales income per dealership.

select d.business_name, sum(s.price) as total_purchase_sales
from dealerships d 
join sales s on s.dealership_id = d.dealership_id 
group by d.business_name 
order by total_purchase_sales desc


-- Write a query that shows the purchase sales income per dealership for the current year.

select d.business_name, sum(s.price) as total_purchase_sales from dealerships d 	
join sales s on s.dealership_id = d.dealership_id 
where s.purchase_date > now() - interval '1 month'
group by d.business_name 
order by total_purchase_sales desc;


-- Write a query that shows the lease income per dealership for the current year. 

select * from sales





-- Book 3 - Carnival Real-Time Transactions


-- Chapter 1 - SQL Updates 


-- Practice Question: Kristopher Blumfield an employee of Carnival has asked to be transferred to a different dealership location. 
					-- She is currently at dealership 9. She would like to work at dealership 20. Update her record to reflect her transfer.

update dealershipemployees 
set dealership_id = 20
where employee_id  = 
(select e.employee_id from employees e where e.first_name = 'Kristopher' and e.last_name = 'Blumfield')





-- Practice Question: A Sales associate needs to update a sales record because her customer want to pay with a Mastercard instead of JCB. 
-- Update Customer, Ernestus Abeau Sales record which has an invoice number of 9086714242.

update sales 
set payment_method = 'mastercard'
where invoice_number = '9086714242'






-- Chapter 2 - SQL Delete



-- Practice Question
-- A sales employee at carnival creates a new sales record for a sale they are trying to close. The customer, last minute decided not to purchase the vehicle. 
-- Help delete the Sales record with an invoice number of '2436217483'.

delete from sales 
where invoice_number = '2436217483'






-- Practice Question: 
-- An employee was recently fired so we must delete them from our database. Delete the employee with employee_id of 35. What problems might you run into when deleting? 
-- How would you recommend fixing it?

select * from employees e 


select * from dealerships d 



-- Chapter 3 - Stored Procedures Introduction

/*
stored procedures are predefined statements for executing SQL
stored procedures do not use the return statement to return a value, but a return statement can halt a procedure
it's common to use stored procedures all all procedures except SELECT (use User Defined Functions for SELECT since it has return statements)
the big difference betwwen stored procedures and user defined functions is UDFs can be used like an expression in regular statements while stored procedures must be invoked using the CALL statement
defining a procedure requires a name, parameters, language used, and embeded SQL statements


Example:

	CREATE PROCEDURE insert_data(IN a varchar, INOUT b varchar)
	LANGUAGE plpgsql
	AS $$
	BEGIN
	
	INSERT INTO tbl(col) VALUES (a);
	INSERT INTO tbl(col) VALUES (b);
	
	END
	$$;


To execute the stored procedure we use the CALL statement.

	CALL insert_data(1, 2);
*/



-- Chapter 4 - Stored Procedures Practice

-- test all the small parts to your stored procedure before wrapping it and calling it 


/*
Practice Question
Carnival would like to create a stored procedure that handles the case of updating their vehicle inventory when a sale occurs. 
They plan to do this by flagging the vehicle as is_sold which is a field on the Vehicles table. 
When set to True this flag will indicate that the vehicle is no longer available in the inventory. 
Why not delete this vehicle? We don't want to delete it because it is attached to a sales record.
*/



create procedure changeVehicleStatusToIsSold (in vehicle_id_param int)
language plpgsql
as $$
begin 
	
update vehicles v 
set is_sold = true
where v.vehicle_id = vehicle_id_param; 

end 
$$;


--call the stored procedure and pass in the vehicle_id that's being sold

call changeVehicleStatusToIsSold(1);





-- team answer

/*
CREATE PROCEDURE car_sold(vehicle int)
LANGUAGE plpgsql
AS $$
BEGIN
	--mark car as being as beind sold	
	update vehicles 
	set is_sold = true 
	where vehicle_id = vehicle;
	commit;
end;$$
*/




-- Practice Question
-- Carnival would also like to handle the case for when a car gets returned by a customer. 
-- When this occurs they must add the car back to the inventory and mark the original sales record as sale_returned = TRUE.
-- Carnival staff are required to do an oil change on the returned car before putting it back on the sales floor. 
-- In our stored procedure, we must also log the oil change within the OilChangeLogs table.


-- start of stored procedure
create or replace procedure vehicle_returned(in vehicle_id_param int)
language plpgsql
as $$
begin
	
	-- change is_returned to true in sales table
	update sales 
	set sale_returned = true
	where vehicle_id = vehicle_id_param;
	
	-- change is_sold and is_new to false in vehicles
	update vehicles 
	set is_sold = false,
		is_new = false
	where vehicle_id = vehicle_id_param;
	
	-- create new entry in OilChageLogs
	insert into oilchangelogs (date_occured, vehicle_id)
	values (now(), vehicle_id_param);

end
$$;


-- run the stored procedure by passing in the vehicle id
call vehicle_returned(1);


-- helper queries for the above practice question
select * from sales where vehicle_id = 1 -- has sales_returned column
select * from vehicles where vehicle_id = 1 -- is_sold, is_new
select * from oilchangelogs 

-- delete
delete from oilchangelogs 
where oil_change_log_id = 1

--change values back after running vehicle_returned stored procedure for testing
update sales 
set sale_returned = false 
where vehicle_id = 1

update vehicles 
set is_sold = true,
	is_new = true 
where vehicle_id = 1


-- team answer
/*
CREATE or replace procedure car_return(vehicle int, is_used bool)
LANGUAGE plpgsql
AS $$
BEGIN
	--mark car as being returned
	update sales 
	set sale_returned = true 
	where vehicle_id = vehicle;
	--mark vehicle as not sold and determine whether it is new
	update vehicles 
	set is_sold = false,
	is_new = is_used
	where vehicle_id = vehicle;
	insert into oilchangelogs (date_occured, vehicle_id)
	values (NOW(), vehicle);
	commit;
end;$$
*/







-- Chapter 5 - Triggers Introduction

/*
A trigger is a user defined function that is executed when a specific action occurs. 
Once the trigger is defined, it is put into action automatically when the approprate event takes place
Triggers must always be assosciated with a table
You can define a trigger for the following statements insert, update, delete, truncate
Trigers can be row level or statement level; row level mean once for every row; statement level is invoked only once per event
A trigger can be defined to run before or after the event

In order to create a trigger, you must do two things

1. Define a trigger function with 'Create Function' 
	

	CREATE FUNCTION set_pickup_date() 
	RETURNS TRIGGER 
	LANGUAGE PlPGSQL
	AS $$
	BEGIN
	  -- trigger function logic
	  UPDATE sales
	  SET pickup_date = NEW.purchase_date + integer '7'
	  WHERE sales.sale_id = NEW.sale_id;
	  
	  RETURN NULL;
	END;
	$$
	
	
2. Bind the function you created to a table with 'Create Trigger'
	
	CREATE TRIGGER new_sale_made
	AFTER INSERT
	ON sales
	FOR EACH ROW
	EXECUTE PROCEDURE set_pickup_date();
	
	
**/



-- Practice Question
-- Create a trigger for when a new Sales record is added, set the purchase date to 3 days from the current date.


create function addThreeDaysToPurchaseDate()
	returns trigger
	language plpgsql
as $$
begin
	--sql logic goes here
	update sales 
	set purchase_date = new.purchase_date + integer '3'
	where sales.sale_id = new.sale_id;
	
	return null;
end;
$$


create trigger afterNewSaleAddThreeDaysToPurchaseDate
	after insert 
	on sales
	for each row 
	execute procedure addThreeDaysToPurchaseDate();



--helper queries
	select * from sales
	order by sale_id desc
	
	delete from sales 
	where sale_id = 5004
	
	drop trigger afterNewSaleAddThreeDaysToPurchaseDate on sales
	
	drop function addThreeDaysToPurchaseDate 
	
	INSERT INTO public.sales
	(sales_type_id, vehicle_id, employee_id, customer_id, dealership_id, price, deposit, purchase_date, pickup_date, invoice_number, payment_method, sale_returned)
	VALUES(1, 1001, 2, 22, 7, 12345, 123, now(), now(), null, 'fancy credit card', false);




-- team answer
/*
select * from sales
order by sale_id desc 

insert into sales
values (1, null, 12, 7, 1, 234.56, 123, now(), null, null, 'credit card', false);



create function setPurchaseDateThreeDaysFromToday()
returns trigger
language PlPGSQL
as $$
begin
	update sales 
	set purchase_date = new.purchase_date + integer '3'
end;
$$
*/



-- Practice Question
-- Create a trigger for updates to the Sales table. If the pickup date is on or before the purchase date, set the pickup date to 7 days after the purchase date. 
-- If the pickup date is after the purchase date but less than 7 days out from the purchase date, add 4 additional days to the pickup date.


create function adjustPickupDate()
	returns trigger
	language pipgsql
as $$
begin

	
	
end;
$$












--helper queries
	select * from sales
	order by sale_id desc
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	


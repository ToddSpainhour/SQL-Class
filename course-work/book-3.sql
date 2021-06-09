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



-- Practice Question: A sales employee at carnival creates a new sales record for a sale they are trying to close. The customer, last minute decided not to purchase the vehicle. 
--Help delete the Sales record with an invoice number of '2436217483'.






-- Practice Question: An employee was recently fired so we must delete them from our database. Delete the employee with employee_id of 35. What problems might you run into when deleting? 
--How would you recommend fixing it?








-- Chapter 3 - Stored Procedures Introduction


-- Chapter 4 - Stored Procedures Practice

-- test all the small parts to your stored procedure before wrapping it and calling it 


-- Practice Question
-- Carnival would like to create a stored procedure that handles the case of updating their vehicle inventory when a sale occurs. 
-- They plan to do this by flagging the vehicle as is_sold which is a field on the Vehicles table. 
-- When set to True this flag will indicate that the vehicle is no longer available in the inventory. 
-- Why not delete this vehicle? We don't want to delete it because it is attached to a sales record.


CREATE or replace procedure car_return(vehicle int, is_used bool)
LANGUAGE plpgsql
AS $$
BEGIN
	--mark car as being as beind returned
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




-- Practice Question
-- Carnival would also like to handle the case for when a car gets returned by a customer. 
-- When this occurs they must add the car back to the inventory and mark the original sales record as sale_returned = TRUE.
-- Carnival staff are required to do an oil change on the returned car before putting it back on the sales floor. 
-- In our stored procedure, we must also log the oil change within the OilChangeLogs table.


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



-------------group work

select *
from vehicletypes v 

-- DONE create the new tables (vehiclebodytype, vehiclemodel, vehiclemake)

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



-- DONE change all strings to ints in vehicletypes
--- data migration --
-- A data migration will need to take place for Carnival where we will convert text to integers. 
-- Since that is not a learning requirment at this point we are providing the SQL script for you to conduct this.
-- The result of the script will change all the text words to id integers. 
-- The important thing to note is that the data migration script does not change the datatype of these fields.
-- You will be respnonsible for changing the datatype in the next practice below.
-- the data migration code... you still need to create a body_type table
-- do the data migration before the alter table
-- to enforce capitalization in table names surround them in double quotes when creating the table

UPDATE vehicleTypes 
SET body_type =  CASE  
					WHEN body_type = 'Car' THEN '1' 
					WHEN body_type = 'Truck' THEN '2'
					WHEN body_type = 'Van' THEN '3'
					WHEN body_type = 'SUV' THEN '4'
                 END ;
				 
UPDATE vehicleTypes 				 
SET      make = CASE  
					WHEN make = 'Chevrolet' THEN '1' 
					WHEN make = 'Mazda' THEN '2'
					WHEN make = 'Nissan' THEN '3'
					WHEN make = 'Ford' THEN '4'
					WHEN make = 'Volkswagen' THEN '5'
				  END ;
				  
UPDATE vehicleTypes 
SET     model =  CASE  
					WHEN model = 'Corvette' THEN '1' 
					WHEN model = 'Blazer' THEN '2'
					WHEN model = 'Silverado' THEN '3'
					WHEN model = 'MX-5 Miata' THEN '4'
					WHEN model = 'CX-5' THEN '5'
					WHEN model = 'CX-9' THEN '6' 
					WHEN model = 'Maxima' THEN '7'
					WHEN model = 'Altima' THEN '8'
					WHEN model = 'Titan' THEN '9'
					WHEN model = 'Fusion' THEN '10'
					WHEN model = 'EcoSport' THEN '11'
					WHEN model = 'F-250' THEN '12'
					WHEN model = 'Beetle' THEN '13'
					WHEN model = 'Passat' THEN '14'
					WHEN model = 'Atlas' THEN '15'
					WHEN model = 'Transit-150 Cargo' THEN '16'
				 END ;




select *
from vehicletypes v 
-- the data from this table will be distributed into other new tables


select *
from vehiclebodytype v 
--data imported

select *
from vehicleModel
--data imported


select *
from vehiclemake v 
--data imported


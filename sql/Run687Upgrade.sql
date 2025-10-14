create or replace function     upgrade()
returns int 
as
'
	declare
		RC1 int := 1;
		RC0 int := 0;
        begin

		-- Disable triggers
		UPDATE pg_class SET reltriggers = 0 WHERE relname = ''nc_correlation_set_item'';

		INSERT INTO nc_correlation_set_item (correlation_set_id,correlation_attribute_id,weight) VALUES (1,1,0.0);
		INSERT INTO nc_correlation_set_item (correlation_set_id,correlation_attribute_id,weight) VALUES (1,2,0.0);
		INSERT INTO nc_correlation_set_item (correlation_set_id,correlation_attribute_id,weight) VALUES (1,3,0.0);
		INSERT INTO nc_correlation_set_item (correlation_set_id,correlation_attribute_id,weight) VALUES (1,4,100.0);
		INSERT INTO nc_correlation_set_item (correlation_set_id,correlation_attribute_id,weight) VALUES (1,5,0.0);
		INSERT INTO nc_correlation_set_item (correlation_set_id,correlation_attribute_id,weight) VALUES (1,6,0.0);
		INSERT INTO nc_correlation_set_item (correlation_set_id,correlation_attribute_id,weight) VALUES (1,7,0.0);

		INSERT INTO nc_correlation_set_item (correlation_set_id,correlation_attribute_id,weight) VALUES (2,1,0.0);
		INSERT INTO nc_correlation_set_item (correlation_set_id,correlation_attribute_id,weight) VALUES (2,2,38.8);
		INSERT INTO nc_correlation_set_item (correlation_set_id,correlation_attribute_id,weight) VALUES (2,3,20.4);
		INSERT INTO nc_correlation_set_item (correlation_set_id,correlation_attribute_id,weight) VALUES (2,4,40.8);
		INSERT INTO nc_correlation_set_item (correlation_set_id,correlation_attribute_id,weight) VALUES (2,5,20.4);
		INSERT INTO nc_correlation_set_item (correlation_set_id,correlation_attribute_id,weight) VALUES (2,6,0.0);
		INSERT INTO nc_correlation_set_item (correlation_set_id,correlation_attribute_id,weight) VALUES (2,7,0.0);

		INSERT INTO nc_correlation_set_item (correlation_set_id,correlation_attribute_id,weight) VALUES (3,1,38.8);
		INSERT INTO nc_correlation_set_item (correlation_set_id,correlation_attribute_id,weight) VALUES (3,2,20.4);
		INSERT INTO nc_correlation_set_item (correlation_set_id,correlation_attribute_id,weight) VALUES (3,3,20.4);
		INSERT INTO nc_correlation_set_item (correlation_set_id,correlation_attribute_id,weight) VALUES (3,4,20.4);
		INSERT INTO nc_correlation_set_item (correlation_set_id,correlation_attribute_id,weight) VALUES (3,5,20.4);
		INSERT INTO nc_correlation_set_item (correlation_set_id,correlation_attribute_id,weight) VALUES (3,6,0.0);
		INSERT INTO nc_correlation_set_item (correlation_set_id,correlation_attribute_id,weight) VALUES (3,7,0.0);

		-- Enable triggers
		UPDATE pg_class SET reltriggers = (SELECT count(*) FROM pg_trigger where pg_class.oid = tgrelid) WHERE relname = ''nc_correlation_set_item'';


                raise info ''[ INFO ]  Upgrade to 6.8.7 successful'';
                RETURN RC0 ; 
        EXCEPTION WHEN OTHERS THEN
                raise info ''[ ERROR ] Upgrade to 6.8.7 failed'';
                RETURN RC1 ;
        end;
'
language 'plpgsql';

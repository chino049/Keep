CREATE FUNCTION get_customer_id (text,text) RETURNS integer AS '
  DECLARE
    
    -- Declare aliases for user input.
    l_name ALIAS FOR $1;
    f_name ALIAS FOR $2;
    
    -- Declare a variable to hold the customer ID number.
    customer_id INTEGER;
  
  BEGIN
    
    -- Retrieve the customer ID number of the customer whose first and last
    --  name match the values supplied as function arguments.
    SELECT INTO customer_id id FROM customers
      WHERE last_name = l_name AND first_name = f_name;
    
    -- Return the ID number.
    RETURN customer_id;
  END;
' LANGUAGE 'plpgsql';

SELECT cust_name, cust_main_phone_number,
       TRANSLATE(cust_main_phone_number, '0123456789', 'abcdefghij') AS encoded_phone
  FROM customers;

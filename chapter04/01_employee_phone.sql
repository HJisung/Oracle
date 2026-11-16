SELECT employee_id, phone_number,
       '(02)' || SUBSTR(phone_number, 5) AS seoul_phone
  FROM employees
 ORDER BY employee_id;

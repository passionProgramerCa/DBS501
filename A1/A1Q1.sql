SET LINESIZE 130;
SET PAGESIZE 130;
SET SERVEROUTPUT ON
SET VERIFY OFF 

ACCEPT city PROMPT 'Please provide the valid city without department: ';

/* page 195
departments and locations */
 
 


DECLARE

v_city locations.city%TYPE := '&city';
v_max_dept_id departments.department_id%TYPE;
v_rec departments.department_id%TYPE;
v_dept_id NUMBER;
v_manager_id VARCHAR(100);
v_location NUMBER;
v_locID NUMBER;
v_view departments%ROWTYPE;


BEGIN

/* Highest value of all id + 50 */
SELECT MAX(department_id) + 50 into v_dept_id
FROM departments;


/* SELECT COUNT(d.Manager_id) into v_manager_id
FROM departments d
RIGHT JOIN employees e
ON d.manager_id = e.manager_id
GROUP BY e.Manager_id
ORDER BY COUNT(e.Manager_id) DESC
FETCH NEXT 1 ROWS ONLY; */


/* ID that has most people under supervision */
Select e.manager_id into v_manager_id
from employees e
join departments d
on e.manager_id = d.manager_id
group by e.manager_id
order by Count(*) desc
FETCH NEXT 1 ROWS ONLY;


/* Returns number of locations*/
SELECT COUNT(location_id) into v_location
FROM locations
WHERE city = v_city;

/* Returns location ID */
SELECT location_id into v_locID
FROM locations
WHERE city = v_city;

/* Returns if they have a department  */
/* SELECT department_id, department_name, manager_id, location_id INTO v_rec
FROM departments
WHERE location_id in (SELECT location_id FROM locations WHERE city = v_city ); */

/* Returns count of department  */
SELECT COUNT(department_id) INTO v_rec
FROM departments
WHERE location_id in (SELECT location_id FROM locations WHERE city = v_city );


IF(v_rec = 0) THEN

	INSERT INTO DEPARTMENTS VALUES (v_dept_id, 'testing', v_manager_id, v_locID); 
	Select * into v_view
	From Departments
	Where location_id = v_locID;
	

	ROLLBACK;

ELSIF v_rec = 1 THEN
	DBMS_OUTPUT.PUT_LINE('This city already contains department: ' || v_city);

ELSIF(v_rec) > (1)THEN
	DBMS_OUTPUT.PUT_LINE('This city has MORE THAN ONE department: ' || v_city);


END IF;
EXCEPTION 
	WHEN NO_DATA_FOUND THEN
	DBMS_OUTPUT.PUT_LINE('This city is NOT listed:  ' || v_city);

END;
/


/* Select all of departments into variable where location id is related to inputed city by user */
/* SELECT department_id, department_name, manager_id, location_id INTO v_rec
FROM departments
WHERE location_id in (SELECT location_id FROM locations WHERE v_city = city);

IF (NOT EXISTS(SELECT department)
INSERT INTO v_rec VALUES */


SET LINESIZE 130;
SET PAGESIZE 130;
SET SERVEROUTPUT ON;
SET VERIFY OFF;

ACCEPT locID PROMPT 'Enter valid Location Id: ';

DECLARE

v_locID departments.location_id%TYPE := &locID;
v_deptCount NUMBER;
v_empCount NUMBER;
v_count1 NUMBER;
v_count2 NUMBER;

BEGIN

UPDATE Departments
SET location_id = 1400
WHERE department_id IN (40, 70);

Select COUNT(department_id) INTO v_deptCount
From Departments 
Where v_locID = location_id;

Select COUNT(employee_id) INTO v_empCount
From employees
Where department_id in (Select department_id From departments Where v_locID = location_id);

FOR v_count1 in 1..v_deptCount LOOP
	DBMS_OUTPUT.PUT_LINE('Outer Loop: Department #'|| v_count1);
	
	For v_count2 in 1..v_empCount LOOP
		DBMS_OUTPUT.PUT_LINE('* Inner Loop: Department #'|| v_count2);
		
	END LOOP;

END LOOP;

END;

/

ROLLBACK;


						
						


				
						
						
		

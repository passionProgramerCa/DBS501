SET LINESIZE 130;
SET PAGESIZE 130;
SET SERVEROUTPUT ON;
SET VERIFY OFF;

ACCEPT id PROMPT 'Please enter the Instructor Id: ';

DECLARE
v_id NUMBER := '&id';
v_name INSTRUCTOR.FIRST_NAME%TYPE;
v_section_count NUMBER;
v_message VARCHAR(100);

BEGIN

Select first_name || ' ' || last_name INTO v_name
From instructor
Where v_id = instructor_id;

Select COUNT(SECTION_ID) into v_section_count
From section
where v_id= instructor_id;

DBMS_OUTPUT.PUT_LINE('Instructor ' || v_name || ' , teaches ' || v_section_count || ' section(s)');

v_message := CASE 
	WHEN v_section_count > 9 THEN 'This instructor needs to rest in the next term.'
	WHEN v_section_count = 9 THEN 'This instructor teaches enough sections.'
	ELSE 'This instructor may teach more sections.'
	
	END;
	
	DBMS_OUTPUT.PUT_LINE(v_message);
	
	EXCEPTION
	
	WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('This is not a valid instructor');
	
END;

/

	


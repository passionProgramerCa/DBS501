SET LINESIZE 130;
SET PAGESIZE 130;
SET SERVEROUTPUT ON
SET AUTOPRINT ON
SET VERIFY OFF 


CREATE OR REPLACE function instruct_status(
v_first instructor.first_name%TYPE,
v_last instructor.last_name%TYPE
) 
RETURN VARCHAR2
IS

v_instructor_id instructor.instructor_id%TYPE;
v_sections NUMBER;
V_message varchar2(100);


BEGIN
	SELECT instructor_id into v_instructor_id from instructor
	where first_name = v_first
	and last_name = v_last;
	
	SELECT COUNT(*) into v_sections from section
	where instructor_id = v_instructor_id;
	
	IF (v_sections > 9) THEN
	v_message := 'This Instructor will teach 10 course and needs a vacation';
	ELSIF (v_sections > 0 AND v_sections <= 9) THEN
	v_message := 'This Instructor will teach ' || v_sections || ' courses';
	ELSE
	v_message := 'This Instructor is NOT scheduled to teach ';
	
	END IF;
	
	RETURN v_message;
	

	EXCEPTION
	WHEN NO_DATA_FOUND THEN
	v_message := 'There is NO such instructor'; 
	RETURN v_message;
	WHEN OTHERS THEN
	v_message := 'Error';
	RETURN v_message;

END instruct_status;
/

VARIABLE message VARCHAR2(100);

SELECT last_name, INSTRUCT_STATUS(FIRST_NAME, LAST_NAME) "Instructor_Status"
FROM INSTRUCTOR
ORDER by LAST_NAME;

EXECUTE :message := instruct_status('Peter', 'Pan');
EXECUTE :message := instruct_status('Irene', 'Willig');
 


	

	


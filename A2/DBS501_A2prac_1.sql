SET LINESIZE 130;
SET PAGESIZE 130;
SET SERVEROUTPUT ON
SET AUTOPRINT ON
SET VERIFY OFF 

CREATE OR REPLACE PROCEDURE find_stud (
v_stud IN student.student_id%TYPE,
v_lastName OUT student.last_name%type,
v_phone OUT student.phone%type,
v_zip OUT student.zip%type

)IS

BEGIN

select last_name,phone,zip into v_lastName, v_phone, v_zip
From STUDENT
where student_id = v_stud;

DBMS_OUTPUT.PUT_LINE('Student with the Id of: '|| v_stud || ' is ' || v_lastName 
|| ' with the phone# ' || v_phone || ' and who belongs to zip code ' || v_zip  );

EXCEPTION 
	WHEN NO_DATA_FOUND THEN
		dbms_output.put_line('There is NO Student with the Id of : ' || v_stud);

END find_stud;
/
VARIABLE LNAME VARCHAR2(20)
VARIABLE PHONE VARCHAR2(20)
VARIABLE ZIP VARCHAR2(20)

Execute find_stud('110', :LNAME, :PHONE, :ZIP);
Execute find_stud('99', :LNAME, :PHONE, :ZIP);

/




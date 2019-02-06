SET LINESIZE 130;
SET PAGESIZE 130;
SET SERVEROUTPUT ON
SET AUTOPRINT ON
SET VERIFY OFF 

CREATE OR REPLACE PROCEDURE find_stud(
v_stud_id IN STUDENT.STUDENT_ID%TYPE,
v_last_name OUT STUDENT.LAST_NAME%TYPE,
v_pnum OUT STUDENT.PHONE%TYPE,
v_zip OUT STUDENT.ZIP%TYPE
)IS


BEGIN

SELECT last_name into v_last_name from student
where v_stud_id = student_id;

SELECT phone into v_pnum from student
where v_stud_id = student_id;

SELECT zip into v_zip from student
where v_stud_id = student_id;



DBMS_OUTPUT.PUT_LINE('Student with the ID of: ' || v_stud_id || ' is ' || v_last_name || 'with the phone# '
					|| v_pnum || 'and who belongs to zip code ' || v_zip);
					
EXCEPTION
	WHEN NO_DATA_FOUND THEN
	DBMS_OUTPUT.PUT_LINE('There is NO Student with the ID of: ' || v_stud_id );
END find_stud;
/

VARIABLE LNAME VARCHAR2(20)
VARIABLE PHONE VARCHAR2(20)
VARIABLE ZIP VARCHAR2(20)

EXECUTE find_stud('110', :LNAME, :PHONE, :ZIP);


EXECUTE find_stud('99', :LNAME, :PHONE, :ZIP);

                                                                           
                                       
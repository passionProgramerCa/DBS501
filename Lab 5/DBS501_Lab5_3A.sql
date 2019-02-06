SET LINESIZE 130;
SET PAGESIZE 130;
SET SERVEROUTPUT ON
SET AUTOPRINT ON
SET VERIFY OFF 

CREATE OR REPLACE PACKAGE BODY Lab5 
IS
 
PROCEDURE show_bizdays(
  p_start_date DATE := SYSDATE,
  p_day_num NUMBER := 30
)
IS
  v_index NUMBER := 1;
  v_day NUMBER := 1;
  
BEGIN
  WHILE TRUE LOOP
    IF v_index <= p_day_num THEN
      IF TO_CHAR(p_start_date+v_day, 'd') IN ('6', '7') THEN
        v_day := v_day + 1;
      ELSE
        DBMS_OUTPUT.PUT_LINE('The index is : ' || v_index || ' and the table value is: ' || TO_CHAR(p_start_date+v_day));
        v_index := v_index + 1;
        v_day := v_day + 1;
      END IF;
    ELSE
      EXIT;
    END IF;
  END LOOP;
END show_bizdays;



FUNCTION Get_Descr(
v_sectionID IN SECTION.SECTION_ID%TYPE
)
RETURN VARCHAR2
IS

v_desc COURSE.DESCRIPTION%TYPE;

BEGIN

Select c.description into v_desc from course c
join section s 
on c.course_no = s.course_no
where s.section_id = v_sectionID;

RETURN 'Course Description for Section Id ' || v_sectionID || ' is ' || v_desc;		

EXCEPTION
 WHEN NO_DATA_FOUND THEN			
	RETURN 'There is NO such Section id: ' || v_sectionID;	
 
END Get_Descr;

END Lab5;
/
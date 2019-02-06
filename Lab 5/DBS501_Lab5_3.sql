SET LINESIZE 130;
SET PAGESIZE 130;
SET SERVEROUTPUT ON
SET AUTOPRINT ON
SET VERIFY OFF 

-- 3a
CREATE OR REPLACE PACKAGE Lab5 
IS
 
PROCEDURE show_bizdays(v_start_date DATE := sysdate, v_days NUMBER :=30);

FUNCTION Get_Descr(v_sectionID Section.section_id%TYPE)
RETURN VARCHAR2;
END Lab5;
/

-- 3b
CREATE OR REPLACE PACKAGE BODY Lab5 
IS
 
PROCEDURE show_bizdays(
  v_start_date DATE := SYSDATE,
  v_days NUMBER := 30
)
IS
  v_idx NUMBER := 1;
  v_day NUMBER := 1;
  
BEGIN
  WHILE TRUE LOOP
    IF v_idx <= v_days THEN
      IF TO_CHAR(v_start_date+v_day, 'd') IN ('6', '7') THEN
        v_day := v_day + 1;
      ELSE
        DBMS_OUTPUT.PUT_LINE('The index is : ' || v_idx || ' and the table value is: ' || TO_CHAR(v_start_date+v_day));
        v_idx := v_idx + 1;
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

-- 3c
Execute Lab5.show_bizdays;
Execute Lab5.show_bizdays(sysdate+7, 10);

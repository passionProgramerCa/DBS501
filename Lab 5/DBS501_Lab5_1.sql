SET LINESIZE 130;
SET PAGESIZE 130;
SET SERVEROUTPUT ON
SET AUTOPRINT ON
SET VERIFY OFF 

CREATE OR REPLACE FUNCTION Get_Descr(
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
/


VARIABLE description varchar2(100)

EXECUTE :description := Get_Descr('150');
EXECUTE :description := Get_Descr('999');
		



					
					
					

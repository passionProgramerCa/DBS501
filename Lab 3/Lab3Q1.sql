SET LINESIZE 130;
SET PAGESIZE 130;
SET SERVEROUTPUT ON
SET VERIFY OFF 

DECLARE	
TYPE course_table_type IS TABLE OF
COURSE.DESCRIPTION%TYPE INDEX BY PLS_INTEGER;
course_table course_table_type;
v_count NUMBER(5) := 1;

CURSOR c_course_cursor IS Select DESCRIPTION from course where PREREQUISITE IS NULL ORDER BY DESCRIPTION;

BEGIN
OPEN c_course_cursor;
LOOP
FETCH c_course_cursor INTO course_table(v_count);
EXIT WHEN c_course_cursor%NOTFOUND;
DBMS_OUTPUT.PUT_LINE('Course Description : ' || v_count || ':' || course_table(v_count));
v_count := v_count + 1;
END LOOP;
v_count := v_count - 1;
DBMS_OUTPUT.PUT_LINE('************************************');
DBMS_OUTPUT.PUT_LINE('Total # of Courses' || ' without the Prerequisite is: ' || v_count);
CLOSE c_course_cursor;
END;
/
SET LINESIZE 130;
SET PAGESIZE 130;
SET SERVEROUTPUT ON
SET VERIFY OFF 

ACCEPT zip PROMPT 'Enter first 3 digit of zip code: ';

DECLARE
type t_rec is RECORD
( 
v_zip NUMBER,
v_num_stud NUMBER
);

v_total NUMBER := 0;
v_total_students NUMBER;
t_course t_rec;

CURSOR c_zip IS Select ZIP, COUNT(STUDENT_ID) 
FROM (SELECT DISTINCT s.zip, s.student_id from Student s
LEFT JOIN enrollment e
ON s.student_id = e.student_id 
WHERE s.zip LIKE '&zip' || '%')
GROUP BY zip
ORDER BY zip;

BEGIN
SELECT COUNT(*) INTO v_total_students FROM student where zip LIKE '&zip'|| '%';

IF(v_total_students > 0) THEN
OPEN c_zip;
LOOP
FETCH c_zip INTO t_course;
EXIT WHEN c_zip%NOTFOUND;
DBMS_OUTPUT.PUT_LINE('Zip code: ' || t_course.v_zip || ' has exactly ' || t_course.v_num_stud || ' students enrolled.');
v_total := v_total + 1;
END LOOP;
DBMS_OUTPUT.PUT_LINE('************************************');
DBMS_OUTPUT.PUT_LINE('Total # of zip codes under ' || '&zip' || ' is ' || v_total);
DBMS_OUTPUT.PUT_LINE('Total # of Students under zip code ' || '&zip' || ' is ' || v_total_students);
CLOSE c_zip;
ELSE
DBMS_OUTPUT.PUT_LINE('No students found under this zip code');
END IF;
END;
/





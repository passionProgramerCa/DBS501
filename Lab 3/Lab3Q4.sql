SET LINESIZE 130;
SET PAGESIZE 130;
SET SERVEROUTPUT ON
SET VERIFY OFF 

ACCEPT zip PROMPT 'Enter first 3 digit of zip code: ';

DECLARE

CURSOR c_zip IS Select ZIP, COUNT(STUDENT_ID) AS stud_total
FROM (SELECT DISTINCT s.zip, s.student_id from Student s
LEFT JOIN enrollment e
ON s.student_id = e.student_id 
WHERE s.zip LIKE '&zip' || '%')
GROUP BY zip
ORDER BY zip;

c_stud c_zip%ROWTYPE;

TYPE zip_table_type IS TABLE OF
c_stud%TYPE INDEX BY PLS_INTEGER;

zip_table zip_table_type;
v_total NUMBER := 0;
v_total_students NUMBER;




BEGIN
SELECT COUNT(*) INTO v_total_students FROM student where zip LIKE '&zip'|| '%';

IF(v_total_students > 0) THEN

FOR i in c_zip
LOOP
DBMS_OUTPUT.PUT_LINE('Zip code: ' || i.zip || ' has exactly ' || i.stud_total || ' students enrolled.');
v_total := v_total + 1;
END LOOP;
DBMS_OUTPUT.PUT_LINE('************************************');
DBMS_OUTPUT.PUT_LINE('Total # of zip codes under ' || '&zip' || ' is ' || v_total);
DBMS_OUTPUT.PUT_LINE('Total # of Students under zip code ' || '&zip' || ' is ' || v_total_students);
ELSE
DBMS_OUTPUT.PUT_LINE('No students found under this zip code');
END IF;
END;
/





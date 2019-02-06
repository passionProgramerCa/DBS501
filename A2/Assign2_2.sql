SET AUTOCOMMIT OFF
SET SERVEROUTPUT ON
CREATE  OR  REPLACE PROCEDURE  drop_stud    (
    v_student_id IN student.STUDENT_ID%TYPE,
    v_flag IN VARCHAR2 := 'R'
)   IS
 v_course_count NUMBER(5);
 v_check NUMBER(5);
BEGIN
    SELECT STUDENT_ID INTO v_check FROM STUDENT WHERE STUDENT_ID = v_student_id;
    SELECT count(*) into v_course_count FROM ENROLLMENT WHERE STUDENT_ID=v_student_id;    
    if UPPER(v_flag) != 'R' AND UPPER(v_flag) != 'C' THEN
        DBMS_OUTPUT.PUT_LINE('Invalid removal option, please enter R or C');    
    elsif v_course_count != 0 AND UPPER(v_flag) != 'C' THEN
        DBMS_OUTPUT.PUT_LINE('Student with the Id of: ' || v_student_id || ' is enrolled in one or more courses and his/her removal is denied.');
    elsif UPPER(v_flag) = 'R' THEN
        DBMS_OUTPUT.PUT_LINE('Student with the Id of : ' || v_student_id ||' is removed. He/she was NOT enrolled in any courses.');
        DELETE FROM STUDENT WHERE STUDENT_ID = v_student_id;
    elsif UPPER(v_flag) = 'C' THEN
        SELECT SUM(c) into v_check FROM (
            SELECT COUNT(*) AS c FROM GRADE WHERE STUDENT_ID = 110
            UNION ALL
            SELECT COUNT(*) FROM ENROLLMENT WHERE STUDENT_ID = 110
            UNION ALL
            SELECT COUNT(*) FROM STUDENT WHERE STUDENT_ID = 110);
        DELETE FROM GRADE WHERE STUDENT_ID = v_student_id;
        DELETE FROM ENROLLMENT WHERE STUDENT_ID = v_student_id;
        DELETE FROM STUDENT WHERE STUDENT_ID = v_student_id;
        DBMS_OUTPUT.PUT_LINE('Student with the Id of : ' || v_student_id ||' is removed. Total # of rows deleted is: ' || v_check);
    end if;
EXCEPTION 
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Student with the Id of : ' || v_student_id || ' does NOT exist. Try again');
END  drop_stud;
/


--Case 01
EXECUTE drop_stud(210,'R');
SELECT SECTION_ID, FINAL_GRADE FROM ENROLLMENT WHERE STUDENT_ID=210;
SELECT FIRST_NAME,LAST_NAME FROM STUDENT WHERE STUDENT_ID=210;

-- Student with the Id of: 210 is enrolled in one or more courses and his/her      
-- removal is denied.                                                              

-- PL/SQL procedure successfully completed.

-- SECTION_ID FINAL_GRADE                                                          
-- ---------- -----------                                                          
--        147                                                                      


-- FIRST_NAME                LAST_NAME                                             
-- ------------------------- -------------------------                             
-- David                     Thares                                                



--Case 02
EXECUTE drop_stud(410,'R');


-- Student with the Id of : 410 does NOT exist. Try again                          

-- PL/SQL procedure successfully completed.


--Case 03
EXECUTE drop_stud(310,'R');

SELECT FIRST_NAME,LAST_NAME FROM STUDENT WHERE STUDENT_ID=310;
ROLLBACK;
SELECT FIRST_NAME,LAST_NAME FROM STUDENT WHERE STUDENT_ID=310;

-- Student with the Id of : 310 is removed. He/she was NOT enrolled in any courses.

-- PL/SQL procedure successfully completed.

-- no rows selected


-- Rollback complete.


-- FIRST_NAME                LAST_NAME                                             
-- ------------------------- -------------------------                             
-- Joseph                    Jimenes                                               



--Case 04
EXECUTE drop_stud(110,'C');

SELECT FIRST_NAME,LAST_NAME FROM STUDENT WHERE STUDENT_ID=110;
ROLLBACK;
SELECT FIRST_NAME,LAST_NAME FROM STUDENT WHERE STUDENT_ID=110;


-- Student with the Id of : 110 is removed. Total # of rows deleted is: 24         

-- PL/SQL procedure successfully completed.


-- no rows selected


-- Rollback complete.


-- FIRST_NAME                LAST_NAME                                             
-- ------------------------- -------------------------                             
-- Maria                     Martin                                                

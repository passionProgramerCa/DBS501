--Question 01
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

-- Student with the ID of: 110 is Martinwith the phone# 718-555-5555and who belongs to zip code 11385                                

-- PL/SQL procedure successfully completed.


-- ZIP                                                                                                                               
-- --------------------------------                                                                                                  
-- 11385                                                                                                                             


-- PHONE                                                                                                                             
-- --------------------------------                                                                                                  
-- 718-555-5555                                                                                                                      


-- LNAME                                                                                                                             
-- --------------------------------                                                                                                  
-- Martin                                                                                                                            

EXECUTE find_stud('99', :LNAME, :PHONE, :ZIP);

-- There is NO Student with the ID of: 99                                                                                            

-- PL/SQL procedure successfully completed.


-- ZIP                                                                                                                               
-- --------------------------------                                                                                                  
                                                                                                                                  


-- PHONE                                                                                                                             
-- --------------------------------                                                                                                  
                                                                                                                                  


-- LNAME                                                                                                                             
-- --------------------------------                                                                                                  
                                       





--Question 02


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











--Question 03


SET AUTOCOMMIT OFF
SET SERVEROUTPUT ON
SET AUTOPRINT ON
SET VERIFY OFF 
SET LINESIZE 130;
SET PAGESIZE 130;

CREATE OR REPLACE PACKAGE manage_stud  IS


PROCEDURE  find_stud(
        v_stud_id IN STUDENT.STUDENT_ID%TYPE,
        v_last_name OUT STUDENT.LAST_NAME%TYPE,
        v_pnum OUT STUDENT.PHONE%TYPE,
        v_zip OUT STUDENT.ZIP%TYPE);

PROCEDURE  drop_stud(
     v_student_id IN student.STUDENT_ID%TYPE,
        v_flag IN VARCHAR2 := 'R');
END manage_stud;


/



CREATE OR REPLACE PACKAGE BODY manage_stud  IS

    PROCEDURE find_stud(
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
    

  PROCEDURE  drop_stud    (
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

END manage_stud;

/
--Q1 Case 01
VARIABLE LNAME VARCHAR2(20)
VARIABLE PHONE VARCHAR2(20)
VARIABLE ZIP VARCHAR2(20)

EXECUTE manage_stud.find_stud('110', :LNAME, :PHONE, :ZIP);

-- Student with the ID of: 110 is Martinwith the phone# 718-555-5555and who belongs to zip code 11385                                

-- PL/SQL procedure successfully completed.


-- ZIP                                                                                                                               
-- --------------------------------                                                                                                  
-- 11385                                                                                                                             


-- PHONE                                                                                                                             
-- --------------------------------                                                                                                  
-- 718-555-5555                                                                                                                      


-- LNAME                                                                                                                             
-- --------------------------------                                                                                                  
-- Martin                        

--Q2 Case 03
EXECUTE manage_stud.drop_stud(310,'R');

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



--Q2 Case 04
EXECUTE manage_stud.drop_stud(110,'C');

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







--Question 04

Create or Replace Function valid_stud(studID number) return VARCHAR2 IS
    v_found char(1);
Begin
    Select 'Y' into v_found
    from Student
    where student_id = studID;    
    return 'true';
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        return 'false';
END;
/

VARIABLE  output1  VARCHAR2(5)
EXECUTE :output1 := valid_stud(110)

-- OUTPUT1                                                                         
-- --------------------------------------------------------------------------------
-- true


VARIABLE output2 VARCHAR2(5)
EXECUTE :output2 := valid_stud(410)

-- OUTPUT2                                                                         
-- --------------------------------------------------------------------------------
-- false








--Question 05



--ALTER TABLE countries ADD FLAG VARCHAR2(7);
Accept rID prompt 'Provide a Region_ID:';

DECLARE
    v_rID countries.region_id%TYPE := '&rID';
    cursor country_cursor IS Select *
                             From Countries c
                             left outer join Locations l
                             on c.COUNTRY_ID = l.COUNTRY_ID
                             where l.city is null
                             order by c.Country_name;
    cursor region_cursor IS  Select *
                             From Countries c
                             left outer join Locations l
                             on c.COUNTRY_ID = l.COUNTRY_ID
                             where l.city is null
                             and c.region_id = v_rID
                             order by c.Country_name;
                             
    TYPE country_type IS TABLE OF countries.country_name%TYPE
    INDEX BY PLS_INTEGER;
    
    region_rec region_cursor%rowtype;
    country_table country_type;
    v_index number := 1;
    v_count number := 0;
    v_rCount number := 0;
    
BEGIN
    
    open region_cursor;
    fetch region_cursor into region_rec;
    
    IF region_cursor%NOTFOUND THEN
        close region_cursor;
        dbms_output.put_line('This region ID does NOT exist: ' || v_rID);
    ELSE
        close region_cursor;
        For it in country_cursor loop
            Update Countries
            set FLAG = 'Empty_'||it.region_id
            where countries.country_name = it.country_name;
        
            country_table(v_index) := it.country_name;
            dbms_output.put_line('Index Table Key: '|| v_index || ' has a value of ' || it.country_name);
            v_index := v_index +5;
            v_count := v_count + 1;
        END Loop;
        dbms_output.put_line('======================================================================');
        dbms_output.put_line('Total number of elements in the Index Table or Number of countries with NO cities listed is: ' || v_count);                                                            
        dbms_output.put_line('Second element (Country) in the Index Table is: ' || country_table(6));                         
        dbms_output.put_line('Before the last element (Country) in the Index Table is: ' || country_table(v_index - 10));
        dbms_output.put_line('======================================================================');
        For ind in region_cursor loop
            dbms_output.put_line('In the region ' ||v_rID || ' there is country ' || ind.country_name || ' with NO city.');
            v_rCount := v_rCount + 1;
        End loop;    
        dbms_output.put_line('======================================================================');
        dbms_output.put_line('Total Number of countries with NO cities listed in the Region ' || v_rID || ' is: ' || v_rCount);
    END IF;
END;
/
Select *
From Countries c
left outer join Locations l
on c.COUNTRY_ID = l.COUNTRY_ID
where c.FLAG is not null
order by FLAG, c.Country_name;
Rollback;
    

--Case 01:
-- Enter value for region: 5
-- This region ID does NOT exist: 5                                                

-- PL/SQL procedure successfully completed.

-- no rows selected

-- Rollback complete.

--Case 02
-- Enter value for region: 1
-- Index Table Key: 1 has a value of Argentina                                     
-- Index Table Key: 6 has a value of Belgium                                       
-- Index Table Key: 11 has a value of Denmark                                      
-- Index Table Key: 16 has a value of Egypt                                        
-- Index Table Key: 21 has a value of France                                       
-- Index Table Key: 26 has a value of HongKong                                     
-- Index Table Key: 31 has a value of Israel                                       
-- Index Table Key: 36 has a value of Kuwait                                       
-- Index Table Key: 41 has a value of Nigeria                                      
-- Index Table Key: 46 has a value of Zambia                                       
-- Index Table Key: 51 has a value of Zimbabwe 
-- ======================================================================                                
-- Total number of elements in the Index Table or Number of countries with NO cities listed is: 11                                                            
-- Second element (Country) in the Index Table is: Belgium                         
-- Before the last element (Country) in the Index Table is: Zambia 
-- ======================================================================             
-- In the region 1 there is country Belgium with NO city.                          
-- In the region 1 there is country Denmark with NO city.                          
-- In the region 1 there is country France with NO city.
-- ======================================================================                          
-- Total Number of countries with NO cities listed in the Region 1 is: 3           

-- PL/SQL procedure successfully completed.

-- CO COUNTRY_NAME                              REGION_ID FLAG                     
-- -- ---------------------------------------- ---------- -------                  
-- BE Belgium                                           1 Empty_1                  
-- DK Denmark                                           1 Empty_1                  
-- FR France                                            1 Empty_1                  
-- AR Argentina                                         2 Empty_2                  
-- HK HongKong                                          3 Empty_3                  
-- EG Egypt                                             4 Empty_4                  
-- IL Israel                                            4 Empty_4                  
-- KW Kuwait                                            4 Empty_4                  
-- NG Nigeria                                           4 Empty_4                  
-- ZM Zambia                                            4 Empty_4                  
-- ZW Zimbabwe                                          4 Empty_4                  

-- 11 rows selected.

-- Rollback complete.


--Case 03

-- Enter value for region: 2
-- Index Table Key: 1 has a value of Argentina                                     
-- Index Table Key: 6 has a value of Belgium                                       
-- Index Table Key: 11 has a value of Denmark                                      
-- Index Table Key: 16 has a value of Egypt                                        
-- Index Table Key: 21 has a value of France                                       
-- Index Table Key: 26 has a value of HongKong                                     
-- Index Table Key: 31 has a value of Israel                                       
-- Index Table Key: 36 has a value of Kuwait                                       
-- Index Table Key: 41 has a value of Nigeria                                      
-- Index Table Key: 46 has a value of Zambia                                       
-- Index Table Key: 51 has a value of Zimbabwe
-- ======================================================================                                     
-- Total number of elements in the Index Table or Number of countries with NO cities listed is: 11                                                            
-- Second element (Country) in the Index Table is: Belgium                         
-- Before the last element (Country) in the Index Table is: Zambia
-- ======================================================================              
-- In the region 2 there is country Argentina with NO city.  
-- ======================================================================                      
-- Total Number of countries with NO cities listed in the Region 2 is: 1           

-- PL/SQL procedure successfully completed.

-- CO COUNTRY_NAME                              REGION_ID FLAG                     
-- -- ---------------------------------------- ---------- -------                  
-- BE Belgium                                           1 Empty_1                  
-- DK Denmark                                           1 Empty_1                  
-- FR France                                            1 Empty_1                  
-- AR Argentina                                         2 Empty_2                  
-- HK HongKong                                          3 Empty_3                  
-- EG Egypt                                             4 Empty_4                  
-- IL Israel                                            4 Empty_4                  
-- KW Kuwait                                            4 Empty_4                  
-- NG Nigeria                                           4 Empty_4                  
-- ZM Zambia                                            4 Empty_4                  
-- ZW Zimbabwe                                          4 Empty_4                  

-- 11 rows selected.
-- Rollback complete.
--Assignment 01
--NAME: Sanjit Pushpaseelan, Johann Aleman, Colin Mcmanus, Sean Le
--PROF: NEBOJSA CONKIC
--Course: DBS501A
--Student Number: 119-827-152(Sanjit Pushpaseelan), 129-910-162(Colin Mcmanus), 018-928-127(Sean Le)
--Date: 2018/10/22


--Question 01

Accept loc PROMPT 'Please provide the valid city without department:';

DECLARE

    v_loc locations.city%TYPE := '&loc';
    
    v_depId departments.department_id%TYPE;
    
    v_depName departments.department_name%TYPE;
    
    v_manId employees.manager_id%TYPE;
    
    v_locId locations.location_id%TYPE;
        
    v_numDepts number;
    
BEGIN

    Select location_id into v_locId
    from locations
    where city = v_loc;
    
    Select count(*) into v_numDepts
    from departments
    where location_id = v_locId;
        
    if v_numDepts = 0 then
    
        Select manager_id into v_manId
        from employees
        group by manager_id
        having count(*) = (Select max(count(*))
                           from employees
                           group by manager_id);
    
        select max(department_id) + 50 into v_depId
        from departments;
    
        v_depName := 'Testing';
    
        insert into departments values (v_depId, v_depName, v_manId, v_locId);
    
    ELSIF v_numDepts > 1 THEN
        dbms_output.put_line('This city has MORE THAN ONE department: '||v_loc);
        
    ELSIF v_numDepts = 1 THEN
        dbms_output.put_line('This city already contains department: '||v_loc);
    END IF;
        
EXCEPTION
    WHEN NO_DATA_FOUND THEN 
        dbms_output.put_line('This city is NOT listed: '||v_loc);
END;
/
Select * from departments where department_id = 320;

ROLLBACK;



-- Please provide the valid city without department:Venice
-- PL/SQL procedure successfully completed.
-- DEPARTMENT_ID DEPARTMENT_NAME                MANAGER_ID LOCATION_ID             
-- ------------- ------------------------------ ---------- -----------             
--           320 Testing                               100        1100             

-- Rollback complete.



-- Please provide the valid city without department:Toronto
-- This city already contains department: Toronto                                  

-- PL/SQL procedure successfully completed.
-- no rows selected
-- Rollback complete.



-- Please provide the valid city without department:Seattle
-- This city has MORE THAN ONE department: Seattle                                 

-- PL/SQL procedure successfully completed.
-- no rows selected
-- Rollback complete.



-- Please provide the valid city without department:Belgrade
-- This city is NOT listed: Belgrade                                               

-- PL/SQL procedure successfully completed.
-- no rows selected
-- Rollback complete.










--Question 02
--Assignment 01
--NAME: Sanjit Pushpaseelan, Johann Aleman, Colin Mcmanus, Sean Le
--PROF: NEBOJSA CONKIC
--Course: DBS501A
--Student Number: 119-827-152(Sanjit Pushpaseelan), 129-910-162(Colin Mcmanus), 018-928-127(Sean Le)
--Date: 2018/10/22

Accept cDesc PROMPT 'Enter the beginning of the Course Description in UPPER case: ';

DECLARE

    v_usrDesc course.description%TYPE := '&cDesc';
    cursor section_cursor is Select s.section_id
                             from section s
                             join course c
                             on s.course_no = c.course_no
                             where c.prerequisite in (select course_no
                                                      from course
                                                      where REGEXP_LIKE(UPPER(description), '^'||v_usrDesc||'*.'))
                             order by 1;                        
    v_enrTtl number;
    sec_rec section_cursor%ROWTYPE;
    too_many EXCEPTION;
    v_flag char(1);
    
BEGIN

    Select DISTINCT 'y' into v_flag
    from course
    where UPPER(description) like v_usrDesc || '%';
    
    open section_cursor;
    fetch section_cursor into sec_rec;
    
    IF section_cursor%FOUND THEN
        close section_cursor;
        FOR it IN section_cursor LOOP
            BEGIN
                sec_rec := it;
                Select count(*) into v_enrTtl
                from enrollment
                where section_id = sec_rec.section_id
                group by section_id;
                IF v_enrTtl >= 7 THEN
                    RAISE too_many;
                ELSE
                    dbms_output.put_line('There are ' || v_enrTtl 
                                          || ' students for section ID ' || sec_rec.section_id);
                END IF;
            EXCEPTION
                 WHEN too_many THEN
                    dbms_output.put_line('There are too many students for section ID ' || sec_rec.section_id);
                    dbms_output.put_line('^^^^^^^^^^^^^^^^^^^^^^^^^^');
                    CONTINUE;
                 WHEN NO_DATA_FOUND THEN
                    dbms_output.put_line('There are 0 students for section ID ' || sec_rec.section_id);
                    CONTINUE;
            END;
        END LOOP;
    ELSE
        close section_cursor;
        dbms_output.put_line('There is NO PREREQUISITE course that starts on: ' 
                                  || v_usrDesc || '. Try again.');
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('There is NO VALID course that starts on: ' 
                              || v_usrDesc || '. Try again.');
END;




-- Enter the beginning of the Course Description in UPPER case: STRUCTURED

-- There are 5 students for section ID 85                                          
-- There are 6 students for section ID 86                                          
-- There are too many students for section ID 87                                   
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^                                                      
-- There are 5 students for section ID 88                                          
-- There are too many students for section ID 89                                   
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^                                                      
-- There are 4 students for section ID 90                                          
-- There are 2 students for section ID 91                                          
-- There are 4 students for section ID 92                                          
-- There are 0 students for section ID 93                                          
-- There are 0 students for section ID 98                                          
-- There are 4 students for section ID 146                                         
-- There are too many students for section ID 147                                  
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^                                                      
-- There are 5 students for section ID 148                                         
-- There are 1 students for section ID 149                                         
-- There are 3 students for section ID 150                                         
-- There are 2 students for section ID 151                                         

-- PL/SQL procedure successfully completed.




-- Enter the beginning of the Course Description in UPPER case: UNIX
-- There is NO PREREQUISITE course that starts on: UNIX. Try again.  
-- PL/SQL procedure successfully completed.



-- Enter the beginning of the Course Description in UPPER case: SPORT
-- There is NO VALID course that starts on: SPORT. Try again.
-- PL/SQL procedure successfully completed.







--Question 03

ACCEPT description PROMPT "Enter the beginning of the Course description in UPPER case: ";

DECLARE
CURSOR c1 IS SELECT * FROM COURSE WHERE PREREQUISITE IS NOT NULL AND UPPER(DESCRIPTION) LIKE UPPER('&description%');

TYPE Prereqcourse IS RECORD(PreCourseno NUMBER, Predescription VARCHAR2(50), Precost NUMBER);

TYPE coursereq IS RECORD(Courseno NUMBER, description VARCHAR2(50), cost NUMBER, Precourse Prereqcourse);

v_course coursereq;

Pre_count_check NUMBER(5);
count_check NUMBER(5);

BEGIN

    SELECT count(*) INTO Pre_count_check FROM COURSE WHERE PREREQUISITE IS NOT NULL AND UPPER(DESCRIPTION) LIKE UPPER('&description%');
    SELECT count(*) INTO count_check FROM COURSE WHERE UPPER(DESCRIPTION) LIKE UPPER('&description%');    
    IF count_check > 0 THEN
        IF Pre_count_check > 0 THEN
            FOR cur_course in c1 
                LOOP
                    SELECT COURSE_NO, DESCRIPTION, COST INTO v_course.Courseno, v_course.description, v_course.cost
                    FROM COURSE WHERE COURSE_NO LIKE cur_course.COURSE_NO;
                    
                    SELECT COURSE_NO, DESCRIPTION, COST INTO v_course.Precourse.PreCourseno, v_course.Precourse.Predescription, v_course.Precourse.Precost
                    FROM COURSE WHERE COURSE_NO LIKE cur_course.PREREQUISITE;
                    
                    DBMS_OUTPUT.PUT_LINE('Course: ' || v_course.Courseno || ' - ' || v_course.description);
                    
                    DBMS_OUTPUT.PUT_LINE('Cost: ' || v_course.cost);

                    DBMS_OUTPUT.PUT_LINE('Prerequisite Course: ' || v_course.Precourse.PreCourseno || ' - ' || v_course.Precourse.Predescription);
                    
                    DBMS_OUTPUT.PUT_LINE('Prerequisite Cost: ' || v_course.Precourse.Precost);
                    
                    DBMS_OUTPUT.PUT_LINE('======================================== ');
                END LOOP;
            ELSE
                DBMS_OUTPUT.PUT_LINE('There is NO prerequisite course that starts on &description. Try again.');
            END IF;
    ELSE
        DBMS_OUTPUT.PUT_LINE('There is NO VALID course that starts on: &description. Try again.');
    END IF;
END;


-- Enter the beginning of the Course description in UPPER case: DATABASE

-- Course: 144 - Database Design                                                   
-- Cost: 1195                                                                      
-- Prerequisite Course: 420 - Database System Principles                           
-- Prerequisite Cost: 1195                                                         
-- ========================================                                        
-- Course: 420 - Database System Principles                                        
-- Cost: 1195                                                                      
-- Prerequisite Course: 25 - Intro to Programming                                  
-- Prerequisite Cost: 1195                                                         
-- ========================================                                        



-- Enter the beginning of the Course description in UPPER case: OPERATING
-- There is NO prerequisite course that starts on OPERATING Try again.             



-- Enter the beginning of the Course description in UPPER case: SPORT
-- There is NO VALID course that starts on: SPORT Try again.       










--Question 04



ACCEPT  v_k1   PROMPT  'Enter the first keyword for the Course: '
ACCEPT  v_k2   PROMPT  'Enter the second keyword for the Course: '

DECLARE

    v_key1 varchar2(25) := '&v_k1';
    v_key2 varchar2(25) := '&v_k2';
       
    cursor course_cursor IS select course_no, description 
                            from course
                            where upper(description) like '%'||upper(v_key1)||'%'
                            and upper(description) like '%'||upper(v_key2)||'%'
                            order by 1;
    
    cursor enrollment_cursor(course_num number) IS select se.section_no, count(e.section_id) as enr
                                                from section se
                                                left outer join enrollment e
                                                on se.section_id = e.section_id
                                                where se.course_no = course_num
                                                group by se.section_no;
    
    v_flag char(1);
    
    enrl_rec enrollment_cursor%ROWTYPE;
                                                
BEGIN

    Select distinct 'y' into v_flag
    from course
    where upper(description) like '%'||upper(v_key1)||'%'
    and upper(description) like '%'||upper(v_key2)||'%';
    
    
    
    
    FOR it IN course_cursor loop
        dbms_output.put_line(it.course_no || ' ' || it.description);
        dbms_output.put_line('**************************************');
        
        open enrollment_cursor(it.course_no);
        fetch enrollment_cursor into enrl_rec;
        
        IF enrollment_cursor%FOUND THEN
            close enrollment_cursor;
            FOR itr IN enrollment_cursor(it.course_no) loop
                dbms_output.put_line('Section: ' || itr.section_no || ' has an enrollment of: ' || itr.enr);
            END loop;
        ELSE
            close enrollment_cursor;
            dbms_output.put_line('This course has no assigned sections.');
        END IF;
    END loop;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('There is NO course containing these 2 words. Try again.');
END; 





-- Enter the first keyword for the Course: JAVA
-- Enter the second keyword for the Course: PROGRAM
-- 120 Intro to Java Programming                                                   
-- **************************************                                          
-- Section: 1 has an enrollment of: 4                                              
-- Section: 2 has an enrollment of: 8                                              
-- Section: 5 has an enrollment of: 3                                              
-- Section: 4 has an enrollment of: 1                                              
-- Section: 3 has an enrollment of: 5                                              
-- Section: 7 has an enrollment of: 2                                              
-- 122 Intermediate Java Programming                                               
-- **************************************                                          
-- Section: 1 has an enrollment of: 4                                              
-- Section: 2 has an enrollment of: 3                                              
-- Section: 4 has an enrollment of: 5                                              
-- Section: 5 has an enrollment of: 8                                              
-- Section: 3 has an enrollment of: 4                                              
-- 124 Advanced Java Programming                                                   
-- **************************************                                          
-- Section: 1 has an enrollment of: 5                                              
-- Section: 2 has an enrollment of: 1                                              
-- Section: 4 has an enrollment of: 0                                              
-- Section: 3 has an enrollment of: 2                                              
-- 146 Java for C/C++ Programmers                                                  
-- **************************************                                          
-- Section: 1 has an enrollment of: 1                                              
-- Section: 2 has an enrollment of: 2                                              
-- 450 DB Programming in Java                                                      
-- **************************************                                          
-- Section: 1 has an enrollment of: 1 
-- PL/SQL procedure successfully completed.



-- Enter the first keyword for the Course: INTRO
-- Enter the second keyword for the Course: C
-- 20 Intro to Computers                                                           
-- **************************************                                          
-- Section: 2 has an enrollment of: 3                                              
-- Section: 4 has an enrollment of: 2                                              
-- Section: 8 has an enrollment of: 2                                              
-- Section: 7 has an enrollment of: 2                                              
-- 240 Intro to the Basic Language                                                 
-- **************************************                                          
-- Section: 1 has an enrollment of: 12                                             
-- Section: 2 has an enrollment of: 1 
-- PL/SQL procedure successfully completed.




-- Enter the first keyword for the Course: INTRO
-- Enter the second keyword for the Course: SOCCER
-- There is NO course containing these 2 words. Try again.         
-- PL/SQL procedure successfully completed.

SET LINESIZE 130;
SET PAGESIZE 130;
SET SERVEROUTPUT ON
SET AUTOPRINT ON
SET VERIFY OFF 

CREATE OR REPLACE PROCEDURE drop_stud (
v_studID student.student_id%TYPE,
v_flag varchar2 := 'R'


)IS
v_count NUMBER(5);
v_check NUMBER(5);



BEGIN
	-- select s.first_name, s.last_name , e.section_id, e.final_grade into v_first, v_last, v_finalGrade, v_sectionID 
	-- from student s
	-- join enrollment e
	-- on s.student_id = e.student_id;
	-- where s.student_id = v_studID;
	
	select student_id into v_check from student where student_id = v_studID;
	select COUNT(*) into v_count from enrollment
	where student_id = v_studID;

	If UPPER(v_flag) != 'R' AND UPPER(v_flag) != 'C' THEN
		DBMS_OUTPUT.PUT_LINE('Please enter R or C');

    elsif UPPER(v_flag) = 'R' AND v_count != 0 THEN
		DBMS_OUTPUT.PUT_LINE('Student with the Id of : ' || v_studID || ' is enrolled in or more courses and his/her removal is denied.');
	
	elsif  UPPER(v_flag) = 'R' AND v_count = 0  THEN
		DBMS_OUTPUT.PUT_LINE('Student with the Id of : ' || v_studID || ' He/she was NOT enrolled in any courses. ');
		DELETE FROM student where student_id = v_studID;
		
	elsif UPPER(v_flag) = 'C' THEN
			select SUM(C) into v_check from( 
			
			select count(*) AS C from grade where student_id = v_studID
			union all
			select count(*) from enrollment where student_id = v_studID
			union all
			select count(*)  from student where student_id = v_studID
			);
			
			
			DELETE FROM grade where student_id = v_studID;
			DELETE FROM enrollment where student_id = v_studID;
			DELETE FROM student where student_id = v_studID;
			
	
			
			DBMS_OUTPUT.PUT_LINE('Student with the Id of : '|| v_studID || ' is removed. Total # of rows deleted is: ' || v_check );
	
	END IF;
	
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
		DBMS_OUTPUT.PUT_LINE('Student with the Id of : ' || v_studID || ' does NOT exist. Try again. ' );

END drop_stud;
/



EXECUTE drop_stud(110,'C');

SELECT FIRST_NAME,LAST_NAME FROM STUDENT WHERE STUDENT_ID=110;
ROLLBACK;
SELECT FIRST_NAME,LAST_NAME FROM STUDENT WHERE STUDENT_ID=110;

/
		
	
		
		
		
	
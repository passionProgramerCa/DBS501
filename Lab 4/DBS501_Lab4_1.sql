SET LINESIZE 130;
SET PAGESIZE 130;
SET SERVEROUTPUT ON
SET VERIFY OFF 

CREATE OR REPLACE PROCEDURE mine(
p_visa_exp varchar2,
p_case_char char
) IS
v_count NUMBER;
e_invalid_input EXCEPTION;
BEGIN
	DBMS_OUTPUT.PUT_LINE('Last day of the month ' || p_visa_exp || ' is ' || TO_CHAR(last_day(to_date(p_visa_exp,'MM/YY')),'day'));
	
	IF (UPPER(p_case_char) NOT LIKE 'P' AND UPPER(p_case_char) NOT LIKE 'F' and UPPER(p_case_char) NOT LIKE 'B') 
	THEN 
	RAISE e_invalid_input;
	
	ELSIF (UPPER(p_case_char) = 'P') THEN
	SELECT COUNT(*) INTO v_count FROM user_objects
	WHERE object_type = 'PROCEDURE';
	DBMS_OUTPUT.PUT_LINE('Number of stored objects of type ' || p_case_char || ' is ' || v_count);
	
	ELSIF (UPPER(p_case_char) = 'F') THEN
	SELECT COUNT(*) INTO v_count FROM user_objects
	WHERE object_type = 'FUNCTION';
	DBMS_OUTPUT.PUT_LINE('Number of stored objects of type ' || p_case_char || ' is ' || v_count);
	
	ELSIF (UPPER(p_case_char) = 'B') THEN
	SELECT COUNT(*) INTO v_count FROM user_objects
	WHERE object_type = 'PACKAGE';
	
	DBMS_OUTPUT.PUT_LINE('Number of stored objects of type ' || p_case_char || ' is ' || v_count);
	END IF;
	
	EXCEPTION
	WHEN e_invalid_input THEN
	DBMS_OUTPUT.PUT_LINE('You have entered an Invalid letter for the stored object. Try P, F or B.');
	WHEN OTHERS THEN
	DBMS_OUTPUT.PUT_LINE('You have entered an Invalid FORMAT for the MONTH and YEAR. Try MM/YY');
	
END mine;
/

 EXECUTE MINE('11/09','P');
 EXECUTE MINE('12/09','f');
 EXECUTE MINE('01/10','T');
 EXECUTE MINE('13/09','P');	

	


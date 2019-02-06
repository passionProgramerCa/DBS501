SET LINESIZE 130;
SET PAGESIZE 130;
SET SERVEROUTPUT ON
SET AUTOPRINT ON
SET VERIFY OFF 


CREATE OR REPLACE function exist_zip(
v_zip zipcode.zip%TYPE
) 
RETURN BOOLEAN
IS

V_INPUT NUMBER;
BEGIN
	SELECT count(*) INTO V_INPUT from ZIPCODE
	where ZIP = v_zip;
	
	IF V_INPUT > 0 THEN
		RETURN TRUE;
	ELSE
		RETURN FALSE;
	
	END IF;

	EXCEPTION
	WHEN OTHERS THEN
	RETURN FALSE;

END exist_zip;
/

CREATE OR REPLACE PROCEDURE add_zip2(
  p_zip zipcode.zip%TYPE,
  p_city zipcode.city%TYPE,
  p_state zipcode.state%TYPE,
  p_rows OUT NUMBER,
  p_success OUT VARCHAR2)
IS
  v_zip zipcode.zip%TYPE;
  FALSE_DATA EXCEPTION;
BEGIN
 
   
   IF exist_zip(p_zip) THEN
    p_success := 'FAILURE';
   ELSE
    RAISE FALSE_DATA;
   
   END IF;   
	

  DBMS_OUTPUT.PUT_LINE('This ZIPCODE ' || p_zip ||' is already in the Database. Try again.');
  SELECT COUNT(*) INTO p_rows FROM zipcode 
  WHERE state = p_state;
EXCEPTION
  WHEN FALSE_DATA THEN
    p_success := 'SUCCESS';
    INSERT INTO zipcode
    VALUES (p_zip, p_city, p_state, USER, SYSDATE, USER, SYSDATE);
    SELECT COUNT(*) INTO p_rows FROM zipcode
    WHERE state = p_state;
END add_zip2;
/

VARIABLE flag VARCHAR2(10)
VARIABLE zipnum NUMBER

EXECUTE add_zip2('18104', 'Chicago', 'MI', :zipnum, :flag)
SELECT  * FROM zipcode WHERE  state = 'MI';
ROLLBACK;

EXECUTE add_zip2('48104', 'Ann Arbor', 'MI', :zipnum, :flag)
SELECT  * FROM zipcode WHERE  state = 'MI';
ROLLBACK;


	

	


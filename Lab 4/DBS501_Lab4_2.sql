SET LINESIZE 130;
SET PAGESIZE 130;
SET SERVEROUTPUT ON
SET VERIFY OFF 
SET AUTOPRINT ON

CREATE OR REPLACE PROCEDURE add_zip(
  p_zip zipcode.zip%TYPE,
  p_city zipcode.city%TYPE,
  p_state zipcode.state%TYPE,
  p_rows OUT NUMBER,
  p_success OUT VARCHAR2)
IS
  v_zip zipcode.zip%TYPE;
BEGIN
  SELECT zip INTO v_zip FROM zipcode
  WHERE zip = p_zip;
  p_success := 'FAILURE';
  DBMS_OUTPUT.PUT_LINE('This ZIPCODE ' || p_zip ||' is already in the Database. Try again.');
  SELECT COUNT(*) INTO p_rows FROM zipcode 
  WHERE state = p_state;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    p_success := 'SUCCESS';
    INSERT INTO zipcode
    VALUES (p_zip, p_city, p_state, USER, SYSDATE, USER, SYSDATE);
    SELECT COUNT(*) INTO p_rows FROM zipcode
    WHERE state = p_state;
END add_zip;
/

VARIABLE flag VARCHAR2(10)
VARIABLE zipnum NUMBER

EXECUTE add_zip('18104', 'Chicago', 'MI', :zipnum, :flag)
SELECT  * FROM zipcode WHERE  state = 'MI';
ROLLBACK;

EXECUTE add_zip('48104', 'Ann Arbor', 'MI', :zipnum, :flag)
SELECT  * FROM zipcode WHERE  state = 'MI';
ROLLBACK;

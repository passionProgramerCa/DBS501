SET LINESIZE 130;
SET PAGESIZE 130;
SET SERVEROUTPUT ON
SET VERIFY OFF 

ACCEPT scale PROMPT 'Enter your input scale (C or F) for temperature: ';
ACCEPT temp PROMPT 'Enter your temperature value to be converted: ';

DECLARE
v_scale CHAR(1) := '&scale';
v_temp NUMBER(5,1) := '&temp';

BEGIN

IF UPPER(v_scale) = ('F') THEN
   v_temp := (v_temp - 32) * 5/9;
   DBMS_OUTPUT.PUT_LINE ('You converted temperature in C is exactly ' || TO_CHAR(v_temp));

ELSIF UPPER(v_scale) = ('C') THEN
   v_temp := (v_temp * 9/5) + 32;
   DBMS_OUTPUT.PUT_LINE ('You converted temperature in F is exactly ' || TO_CHAR(v_temp));

ELSE
   DBMS_OUTPUT.PUT_LINE ('This is NOT a valid scale. Must be C or F.');

END IF;

END;

/
SET LINESIZE 130;
SET PAGESIZE 130;
SET SERVEROUTPUT ON;
SET VERIFY OFF;

ACCEPT num PROMPT 'Please enter a Positive Integer: ';

DECLARE
   v_num NUMBER(6) := &num;
   v_count NUMBER (6);
   v_add NUMBER (9) := 0;
   v_message CHAR(5);
   
 BEGIN
 
 IF v_num < 0 THEN 
	DBMS_OUTPUT.PUT_LINE('Error, not a positive integer!');
	
 ELSE
	
	IF MOD(v_num , 2) = 0 THEN
		v_message := 'Even';
		v_count := v_num;
		
		WHILE v_count > 0 LOOP
		v_add := v_add + v_count;
		v_count := v_count - 2;
		END LOOP;
		
	ELSE	
		v_message := 'Odd';
		v_count := v_num;
		
		WHILE v_count > 0 LOOP
		v_add := v_add + v_count;
		v_count := v_count -2;
		END LOOP;
		
	END IF;

	DBMS_OUTPUT.PUT_LINE('The sum of ' || v_message || ' integers between 1 and ' || v_num || ' is ' || v_add );
	
END IF;

END;

/
		
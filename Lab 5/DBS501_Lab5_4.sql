SET LINESIZE 130;
SET PAGESIZE 130;
SET SERVEROUTPUT ON
SET AUTOPRINT ON
SET VERIFY OFF 

CREATE OR REPLACE PACKAGE Lab5 
IS
PROCEDURE show_bizdays (v_start_date DATE := sysdate, v_days NUMBER := 30);
PROCEDURE show_bizdays (v_start_date DATE := sysdate);

FUNCTION Get_Descr(v_sectionID Section.section_id%TYPE)
RETURN VARCHAR2;
END Lab5;
/

CREATE OR REPLACE PACKAGE BODY Lab5
IS

PROCEDURE show_bizdays(
  v_start_date DATE := SYSDATE,
  v_days NUMBER := 30;
)
IS
  v_idx NUMBER := 1;
  v_day NUMBER := 1;
  
BEGIN
  WHILE TRUE LOOP
    IF v_idx <= v_days THEN
      IF TO_CHAR(v_start_date+v_day, 'd') IN ('6', '7') THEN
        v_day := v_day + 1;
      ELSE
        DBMS_OUTPUT.PUT_LINE('The index is : ' || v_idx || ' and the table value is: ' || TO_CHAR(v_start_date+v_day));
        v_idx := v_idx + 1;
        v_day := v_day + 1;
      END IF;
    ELSE
      EXIT;
    END IF;
  END LOOP;
END show_bizdays;

CREATE OR REPLACE PACKAGE BODY Lab5
IS

BEGIN
ACCEPT v_days NUMBER PROMPT 'Enter number of days';
PROCEDURE show_bizdays(
  v_start_date DATE := SYSDATE,
)
IS
  v_idx NUMBER := 1;
  v_day NUMBER := 1;

  
BEGIN
  WHILE TRUE LOOP
    IF v_idx <= v_days THEN
      IF TO_CHAR(v_start_date+v_day, 'd') IN ('6', '7') THEN
        v_day := v_day + 1;
      ELSE
        DBMS_OUTPUT.PUT_LINE('The index is : ' || v_idx || ' and the table value is: ' || TO_CHAR(v_start_date+v_day));
        v_idx := v_idx + 1;
        v_day := v_day + 1;
      END IF;
    ELSE
      EXIT;
    END IF;
  END LOOP;
END show_bizdays;



End Lab5;
/



Execute Lab5.show_bizdays;
Execute Lab5.show_bizdays(sysdate+7, 10);
Execute Lab5.show_bizdays(20);





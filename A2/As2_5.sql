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
    
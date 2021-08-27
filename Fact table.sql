----------------------------------------
CREATE TABLE dim_category (    /*Created dimension table for Category*/
    c_id            NUMBER
    , category_id     NUMBER
    , category_name   VARCHAR(50)
);

SELECT   /* Checking the table created */
    *
FROM
    dim_category

create sequence Dim_id
    
-----------------------------------------------  
    
CREATE TABLE dim_raiting (    /* Create dimension table for Raiting */
    r_id         NUMBER
    , raiting_id   NUMBER
    , raiting      VARCHAR(5)
);

SELECT   /* Checking the table created */
    *
FROM
    dim_Raiting
    
---------------------------------------------------    
CREATE TABLE dim_movie_yr ( /* Created dimension table for Movie_YR */
    m_id         NUMBER,
    movie_YRID NUMBER
    , movie_year   NUMBER
);

SELECT /* Checking the table created */
    *
FROM
    dim_movie_yr
    
---------------------------------------------------    
    
INSERT INTO dim_category    /* Inserted data from the tables created in part B to dimension table */
    SELECT
        dim_id.NEXTVAL
        , category_id
        , category_name
    FROM
        movie_category;

COMMIT;

SELECT  /* Checking all data if inserted correctly */
    *
FROM
    dim_category
    
---------------------------------------------------------------------

drop sequence Dim_id     /* Dropped the sequence */

CREATE SEQUENCE Dim_id    /* restarted the sequence */

INSERT INTO dim_raiting
    SELECT
        dim_id.NEXTVAL
        , raiting_id
        , raiting
    FROM
        raiting;

COMMIT;

SELECT   /* Checking all data if inserted correctly */
    *
FROM
    dim_Raiting
------------------------------------------------------------  

drop sequence Dim_id   /* Dropped the sequence */

CREATE SEQUENCE Dim_id  /* restarted the sequence */

INSERT INTO dim_movie_yr  /* Inserted data from the tables created in part B to dimension table */
    SELECT
        dim_id.NEXTVAL
        , movie_year, movie_YRID
    FROM
        dvd_1;

COMMIT;

SELECT  /* Checking all data if inserted correctly */
    *
FROM
    dim_movie_yr

----------------------------------------------------------

CREATE TABLE fact_dvd (  /* Created the fact table from the dimension table */
    c_id         NUMBER
    , m_id         NUMBER
    , r_id         NUMBER
    , movie_cost   NUMBER(10, 2)
);

SELECT  /* Checking all data if correctly created */
    *
FROM
    fact_dvd

-------------------------------------------------------------
DECLARE     /* Start to transfer data from dimension table, tables from part B into fact table using cursor */
    TYPE arr_dvd IS
        TABLE OF fact_dvd%rowtype;
    dvd arr_dvd;
    CURSOR cr IS
    SELECT
        c_id
        , m_id
        , r_id
        , SUM(movie_cost)
    FROM
        dvd_1          e
        INNER JOIN dim_category   c ON e.category_id = c.category_id
        INNER JOIN dim_raiting    r ON e.raiting_id = r.raiting_id
        INNER JOIN dim_movie_yr   m ON e.movie_yrid = m.movie_yrid
    GROUP BY
        c_id
        , m_id
        , r_id;

BEGIN
    OPEN cr;
    FETCH cr BULK COLLECT INTO DVD;
    CLOSE cr;
    FORALL i IN 1..DVD.last
        INSERT INTO fact_dvd VALUES (
            dvd(i).c_id
            , dvd(i).r_id
            , dvd(i).m_id
            , dvd(i).movie_cost
        );

END;
/

COMMIT;

SELECT
    *
FROM
    fact_dvd
    


CREATE TABLE movie_category ( --Creating the movie_category table
    category_id     INT NOT NULL PRIMARY KEY -- Primary Key
    , category_name   VARCHAR(50) --Category name
);

CREATE TABLE customer_list ( --Creating the customer list table
    customer_id         INT NOT NULL PRIMARY KEY -- Primary Key
    , customer_initials   VARCHAR(2)-- Customer Initials
    , first_name          VARCHAR(50) -- First Name
    , last_name           VARCHAR(50) -- Last Name
    , phone_number        VARCHAR(50) -- Phone Number
    , birth_date          DATE --Birth Date
    , driver_linces       VARCHAR(50) -- Driver Linces 
    , status              VARCHAR(50) --Status
);

CREATE TABLE dvd ( --Creating DVD Table
    tape_id            INT NOT NULL PRIMARY KEY-- Primary Key
    , title              VARCHAR(50) -- Title
    , movie_year         VARCHAR(50) -- Movie Year
    , movie_cost         VARCHAR(50) -- Movie Cost
    , category_id        INT NOT NULL -- Category ID
    , rented_out         VARCHAR(3) -- Rented Out
    , raiting            VARCHAR(50) -- Raiting 
    , action_on_return   VARCHAR(50) -- Action On Return
    , FOREIGN KEY ( category_id ) -- Foreign Key
        REFERENCES movie_category ( category_id ) -- References Movie Category Table
);

CREATE TABLE dvd_rental ( -- Creating DVD Rental Table
    rental_id     INT NOT NULL PRIMARY KEY -- Primary Key
    , rental_date   DATE -- Rental Date
    , customer_id   INT NOT NULL -- Customer ID
    , tape_id       INT NOT NULL -- Tape ID
    , FOREIGN KEY ( customer_id ) -- Foreign Key
        REFERENCES customer_list ( customer_id ) -- References Customer List Table
    , FOREIGN KEY ( tape_id ) -- Foreign Key
        REFERENCES dvd ( tape_id ) -- References DVD Table
);

-----------------------------------------------------------------------------------

ACCEPT p_category_id PROMPT 'Please enter the Category ID'; -- Asking the user to enter Category ID

ACCEPT p_category_name PROMPT 'Please enter the Category name'; -- Asking the user to enter Category Name

INSERT INTO movie_category VALUES ( -- Inserting Values in movie category table
    &p_category_id
    , '&p_Category_name'
);

ACCEPT p_tape_id PROMPT 'Please enter the tape id'; -- Here I ask the user all the columns in DVD table

ACCEPT p_title PROMPT 'Please enter the title';

ACCEPT p_movie_year PROMPT 'Please enter the movie year';

ACCEPT p_movie_cost PROMPT 'Please enter the movie cost';

ACCEPT p_category_id PROMPT 'Please enter the category id';

ACCEPT p_rented_out PROMPT 'Please enter if it is rented out';

ACCEPT p_raiting PROMPT 'Please enter the raiting';

ACCEPT p_action_on_return PROMPT 'Please enter if it has been returned';

INSERT INTO dvd VALUES ( -- Here I insert the dvd values
    &p_tape_id
    , '&p_Title'
    , '&p_Movie_year'
    , '&p_Movie_cost'
    , &p_category_id
    , '&p_Rented_out'
    , '&p_Raiting'
    , '&p_Action_on_return'
);

ACCEPT p_customer_id PROMPT 'Please enter the customer id'; --Here I ask all the values for Customer List to the user

ACCEPT p_customer_initials PROMPT 'Please enter the customer initials';

ACCEPT p_first_name PROMPT 'Please enter the First Name';

ACCEPT p_last_name PROMPT 'Please enter the Last Name';

ACCEPT p_phone_number PROMPT 'Please enter the Phone Number';

ACCEPT p_birth_date PROMPT 'Please enter if the birthdate';

ACCEPT p_driver_linces PROMPT 'Please enter the Driver licence';

ACCEPT p_status PROMPT 'Please enter the status';

INSERT INTO customer_list VALUES ( -- Here I insert all the values in Customer List 
    &p_customer_id
    , '&p_Customer_initials'
    , '&p_First_name'
    , '&p_Last_name'
    , '&p_Phone_number'
    , '&p_Birth_date'
    , '&p_Driver_Linces'
    , '&p_Status'
);


ACCEPT p_rental_id PROMPT 'Please enter the Rental id'; -- Here is where I ask all the info for DVD Rental Table 

ACCEPT p_rental_date PROMPT 'Please enter the Rental date';

ACCEPT p_customer_id PROMPT 'Please enter the Customer id';

ACCEPT p_tape_id PROMPT 'Please enter the Tape id';

INSERT INTO dvd_rental VALUES ( -- Here I insert all the values into DVD Rental Table
    &p_rental_id
    , '&p_rental_date'
    , &p_customer_id
    , &p_tape_id
);

----------------------------------------------------------------------------

SET SERVEROUTPUT ON

ACCEPT p_film_id PROMPT 'Please enter the Id of the movie' --Asking the user the film id

DECLARE
    v_film_id   INT; --Declaring the film id
    v_rented    VARCHAR(3); --declaring the rented output
BEGIN
    v_film_id := &p_film_id; --Put the user prompt inside the variable
    SELECT
        rented_out -- Selecting rented_out
    INTO v_rented -- And add it to the rented variable
    FROM
        dvd
    WHERE
        tape_id = v_film_id;

    CASE
        WHEN v_rented = 'No' THEN --If the rented is no then it would prompt:
            dbms_output.put_line('The movie is available');
        WHEN v_rented = 'Yes' THEN --If the rented is no then it would prompt:
            dbms_output.put_line('The movie is not available');
        ELSE --Else the movie never existed
            dbms_output.put_line('The movie is does not exist');
    END CASE;

END;

--------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE max_or_min ( --Here I created a procedure where it would look if the movie is 5.29 or 3.99
    x VARCHAR
) IS
BEGIN
    CASE
        WHEN x = '5.29' THEN
            dbms_output.put_line('The movie is one of the expensive ones $' || x);
        WHEN x = '3.99' THEN
            dbms_output.put_line('The movie is one of the cheapest ones $' || x);
        ELSE
            dbms_output.put_line('The movie does not exist');
    END CASE;
END;
/

SET SERVEROUTPUT ON

ACCEPT p_film_id PROMPT 'Please enter the Id of the movie' --Asking the user the film id

DECLARE
    v_film_id      INT;
    v_movie_cost   VARCHAR(4); 
BEGIN
    v_film_id := &p_film_id; -- Insering the user promp to the film variable 
    SELECT
        movie_cost -- Selecting the movie cost
    INTO v_movie_cost
    FROM
        dvd
    WHERE
        tape_id = v_film_id; 

    max_or_min(v_movie_cost); -- Putting the max or min procedure with the movie cost
END;

--------------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE user_info ( -- creating the procedure to collect the user info
    v_customer_id   IN    customer_list.customer_id%TYPE
    , v_cinfo         OUT   customer_list%rowtype
) AS
BEGIN
    SELECT
        *
    INTO v_cinfo
    FROM
        customer_list
    WHERE
        v_customer_id = customer_id;

END;
/

SET SERVEROUTPUT ON

SET VER OFF

ACCEPT p_customer_id PROMPT 'Please enter the Id of the customer' --Asking the user the costumer id

DECLARE
    c_id         INT;
    v_customer   customer_list%rowtype;
    v_title      dvd.title%TYPE;
BEGIN
    c_id := &p_customer_id;
    SELECT
        title
    INTO v_title
    FROM
        dvd
    WHERE
        tape_id IN (
            SELECT
                tape_id --checking the tape id 
            FROM
                dvd_rental
            WHERE
                c_id = customer_id)
        ;

    user_info(c_id, v_customer); --Prompting all the user info
    dbms_output.put_line(v_customer.customer_id
                         || ' '
                         || v_customer.customer_initials
                         || ' '
                         || v_customer.first_name
                         || ' '
                         || v_customer.last_name
                         || ' '
                         || v_customer.phone_number
                         || ' '
                         || v_customer.birth_date
                         || ' '
                         || v_customer.driver_linces
                         || ' '
                         || v_customer.status
                         || ' The customer is renting: '
                         || v_title);

END;
/

---------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION count_movies ( -- Creating the function to count the movies
    v_customer_id IN dvd_rental.customer_id%TYPE
) RETURN INT AS
    num_movies INT;
BEGIN
    SELECT
        COUNT(*)
    INTO num_movies
    FROM
        dvd_rental
    WHERE
        customer_id = v_customer_id;

    RETURN num_movies;
END;
/

SET SERVEROUTPUT ON

SET VER OFF

ACCEPT p_customer_id PROMPT 'Please enter the Id of the customer'

DECLARE
    v_num_of_movies   INT;
    v_full_name       VARCHAR(50);
    v_customer_id     INT;
BEGIN
    v_num_of_movies := count_movies(&p_customer_id); -- using the function with the costumer id
    v_customer_id := &p_customer_id;
    SELECT
        first_name --selecting the customers name
    INTO v_full_name
    FROM
        customer_list
    WHERE
        customer_id = v_customer_id;

    dbms_output.put_line(v_full_name
                         || ' is renting '
                         || v_num_of_movies
                         || ' movie or movies');
END;
/

----------------------------------------------------------------------------------

CREATE OR REPLACE TRIGGER my_tig BEFORE -- creating a trigger to the the dvd_rental table
    INSERT OR UPDATE OR DELETE ON dvd_rental
    FOR EACH ROW
BEGIN
    IF inserting THEN --inserting into custlog if insert is made
        INSERT INTO custlog VALUES (
            'INSERT'
            , user
            , SYSDATE
            , 'DVD_RENTAL'
        );

    END IF;

    IF updating THEN --inserting into custlog if update is made
        INSERT INTO custlog VALUES (
            'UPDATE'
            , user
            , SYSDATE
            , 'DVD_RENTAL'
        );

    END IF;

    IF deleting THEN --inserting into custlog if delete is made
        INSERT INTO custlog VALUES (
            'DELETE'
            , user
            , SYSDATE
            , 'DVD_RENTAL'
        );

    END IF;

END;
/

----------------------------------------------------------------------------------

CREATE OR REPLACE TRIGGER my_tig1 BEFORE -- creating a trigger to the the dvd table
    INSERT OR UPDATE OR DELETE ON dvd
    FOR EACH ROW
    WHEN ( new.title != upper(new.title)--if the new insert is lowcase it would change it to uppercase
           OR new.rented_out != upper(new.rented_out)
           OR new.raiting != upper(new.raiting)
           OR new.action_on_return != upper(new.action_on_return) )
BEGIN
    :new.rented_out := upper(:new.rented_out);
    :new.title := upper(:new.title);
    :new.raiting := upper(:new.raiting);
    :new.action_on_return := upper(:new.action_on_return);
    IF inserting THEN --inserting into custlog if insert is made
        INSERT INTO custlog VALUES (
            'INSERT'
            , user
            , SYSDATE
            , 'DVD'
        );

    END IF;

    IF updating THEN --inserting into custlog if update is made
        INSERT INTO custlog VALUES (
            'UPDATE'
            , user
            , SYSDATE
            , 'DVD'
        );

    END IF;

    IF deleting THEN --inserting into custlog if delete is made
        INSERT INTO custlog VALUES (
            'DELETE'
            , user
            , SYSDATE
            , 'DVD'
        );

    END IF;

END;
/

--------------------------------------------------------------------------------------

CREATE OR REPLACE TRIGGER my_tig2 BEFORE -- creating a trigger to the the customer_list table
    INSERT OR UPDATE OR DELETE ON customer_list
    FOR EACH ROW
    WHEN ( new.customer_initials != upper(new.customer_initials) --if the new insert is lowcase it would change it to uppercase
           OR new.first_name != upper(new.first_name)
           OR new.last_name != upper(new.last_name)
           OR new.status != upper(new.status) )
BEGIN
    :new.customer_initials := upper(:new.customer_initials);
    :new.first_name := upper(:new.first_name);
    :new.last_name := upper(:new.last_name);
    :new.status := upper(:new.status);
    IF inserting THEN --inserting into custlog if insert is made
        INSERT INTO custlog VALUES (
            'INSERT'
            , user
            , SYSDATE
            , 'CUSTOMER_LIST'
        );

    END IF;

    IF updating THEN --inserting into custlog if update is made
        INSERT INTO custlog VALUES (
            'UPDATE'
            , user
            , SYSDATE
            , 'CUSTOMER_LIST'
        );

    END IF;

    IF deleting THEN --inserting into custlog if delete is made
        INSERT INTO custlog VALUES (
            'DELETE'
            , user
            , SYSDATE
            , 'CUSTOMER_LIST'
        );

    END IF;

END;

--------------------------------------------------------------------------------

CREATE OR REPLACE TRIGGER my_tig3 BEFORE -- creating a trigger to the the customer_list table
    INSERT OR UPDATE OR DELETE ON movie_category
    FOR EACH ROW
    WHEN ( new.category_name != upper(new.category_name) ) --if the new insert is lowcase it would change it to uppercase
BEGIN
    :new.category_name := upper(:new.category_name);
    IF inserting THEN --inserting into custlog if insert is made
        INSERT INTO custlog VALUES (
            'INSERT'
            , user
            , SYSDATE
            , 'MOVIE_CATEGORY'
        );

    END IF;

    IF updating THEN --inserting into custlog if update is made
        INSERT INTO custlog VALUES (
            'UPDATE'
            , user
            , SYSDATE
            , 'MOVIE_CATEGORY'
        );

    END IF;

    IF deleting THEN --inserting into custlog if delete is made
        INSERT INTO custlog VALUES (
            'DELETE'
            , user
            , SYSDATE
            , 'MOVIE_CATEGORY'
        );

    END IF;

END;
/

------------------------------------------------------------------------------------

DROP TABLE movie_category; --Dropping all the tables.

DROP TABLE dvd;

DROP TABLE dvd_rental;

DROP TABLE customer_list;
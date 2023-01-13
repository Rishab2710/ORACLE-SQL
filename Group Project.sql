CREATE TABLE movie_category (
    category_id     INT NOT NULL PRIMARY KEY,
    category_name   VARCHAR(50)
);

CREATE TABLE customer_list (
    customer_id         INT NOT NULL PRIMARY KEY,
    customer_initials   VARCHAR(2),
    first_name          VARCHAR(50),
    last_name           VARCHAR(50),
    phone_number        VARCHAR(50),
    birth_date          DATE,
    driver_licenses     VARCHAR(50),
    status              VARCHAR(50)
);

CREATE TABLE dvd (
    tape_id            INT NOT NULL PRIMARY KEY,
    title              VARCHAR(50),
    movie_year         VARCHAR(50),
    movie_cost         VARCHAR(50),
    category_id        INT NOT NULL,
    rented_out         VARCHAR(3),
    raiting            VARCHAR(50),
    action_on_return   VARCHAR(50),
    FOREIGN KEY ( category_id )
        REFERENCES movie_category ( category_id )
);

CREATE TABLE dvd_rental (
    rental_id     INT NOT NULL PRIMARY KEY,
    rental_date   DATE,
    customer_id   INT NOT NULL,
    tape_id       INT NOT NULL,
    FOREIGN KEY ( customer_id )
        REFERENCES customer_list ( customer_id ),
    FOREIGN KEY ( tape_id )
        REFERENCES dvd ( tape_id )
);

SELECT
    *
FROM
    movie_category;

SELECT
    *
FROM
    customer_list;

SELECT
    *
FROM
    dvd_rental;

SELECT
    *
FROM
    dvd;

DROP TABLE dvd_rental;

DROP TABLE dvd;

DROP TABLE customer_list;

DROP TABLE movie_category;
CREATE DATABASE class;
\connect class;

CREATE TABLE student (_id INTEGER PRIMARY KEY, first_name TEXT, last_name TEXT );

\copy student FROM '/home/config/Data/student3.csv' DELIMITER ',' CSV HEADER;


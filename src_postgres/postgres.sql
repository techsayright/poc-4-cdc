CREATE DATABASE students;
\connect students;

CREATE TABLE admission
(student_id INTEGER, gre INTEGER, toefl INTEGER, cpga DOUBLE PRECISION, admit_chance DOUBLE PRECISION,
CONSTRAINT student_id_pk PRIMARY KEY (student_id));

\copy admission FROM '/home/config/Data/admit_1.csv' DELIMITER ',' CSV HEADER;


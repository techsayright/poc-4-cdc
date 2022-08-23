CREATE DATABASE class;
\connect class;

CREATE TABLE subjects (subject_id INTEGER PRIMARY KEY, subject_name TEXT, course_id INTEGER );

\copy subjects FROM '/home/config/Data/subject.csv' DELIMITER ',' CSV HEADER;


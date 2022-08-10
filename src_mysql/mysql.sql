
USE students;

CREATE TABLE research
(student_id INTEGER, rating INTEGER, research INTEGER,
PRIMARY KEY (student_id));


LOAD DATA INFILE '/home/config/Data/research_1.csv'
INTO TABLE research
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-- \copy admission FROM '/home/config/Data/research_1.csv' DELIMITER ',' CSV HEADER;

-- CREATE USER 'replicator' IDENTIFIED BY 'replpass';
-- CREATE USER 'debezium' IDENTIFIED BY 'dbz';
-- GRANT REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO 'replicator';
-- GRANT SELECT, RELOAD, SHOW DATABASES, REPLICATION SLAVE, REPLICATION CLIENT  ON *.* TO 'debezium';

-- CREATE DATABASE students;
-- GRANT ALL PRIVILEGES ON students.* TO 'mysql'@'%';

-- USE students;

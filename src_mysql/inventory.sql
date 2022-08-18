CREATE DATABASE students;
GRANT ALL PRIVILEGES ON students.* TO 'mysqluser'@'%';

CREATE USER 'debezium'@'localhost' IDENTIFIED BY 'debeziumpw';
GRANT SELECT, RELOAD, SHOW DATABASES, REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO 'debezium' IDENTIFIED BY 'debeziumpw';
FLUSH PRIVILEGES;
-- Switch to this database
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

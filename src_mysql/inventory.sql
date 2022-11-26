CREATE DATABASE class;
GRANT ALL PRIVILEGES ON class.* TO 'mysqluser'@'%';

CREATE USER 'debezium'@'localhost' IDENTIFIED BY 'debeziumpw';
GRANT SELECT, RELOAD, SHOW DATABASES, REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO 'debezium' IDENTIFIED BY 'debeziumpw';
FLUSH PRIVILEGES;
-- Switch to this database
USE class;

CREATE TABLE student
(_id INTEGER, first_name TEXT, last_name TEXT,
PRIMARY KEY (_id));


LOAD DATA INFILE '/home/config/Data/student2.csv'
INTO TABLE student
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

CREATE DATABASE class;
GRANT ALL PRIVILEGES ON class.* TO 'mysqluser'@'%';

CREATE USER 'debezium'@'localhost' IDENTIFIED BY 'debeziumpw';
GRANT SELECT, RELOAD, SHOW DATABASES, REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO 'debezium' IDENTIFIED BY 'debeziumpw';
FLUSH PRIVILEGES;
-- Switch to this database
USE class;

CREATE TABLE chapters
(chapter_id INTEGER, chapter_name TEXT, subject_id INTEGER,
PRIMARY KEY (chapter_id));


LOAD DATA INFILE '/home/config/Data/chapter.csv'
INTO TABLE chapters
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

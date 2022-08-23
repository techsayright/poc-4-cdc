#!/bin/sh

# echo What is Your Name?

# read name

echo =======================================
echo Hey Darshan, Welcome
echo =======================================


sleep 5

echo Time to Build Service------------------
docker-compose build

echo Starting Mongo-------------------------
docker-compose up -d mongo1 mongo2

sleep 5

echo Initiating resplica-set---------------- 
docker-compose exec mongo1 /usr/bin/mongo --eval 'rs.initiate({_id : "rs0",members:[{ _id : 0, host : "mongo1:27017", priority: 1.0 },{ _id : 1, host : "mongo2:27017", priority: 0.5 }]})'

sleep 5

echo Inserting Data into MongoDB------------
docker exec -it mongo1 /usr/local/bin/init.sh

sleep 10

echo Starting all services------------------
docker-compose up -d

echo "Running KSQL Scripts(Please Wait)-------------------"
sleep 45

docker-compose exec -T ksqldb-cli ksql http://ksqldb-server:8088 <<-EOF
    show topics;

    set 'commit.interval.ms'='2000';
    set 'cache.max.bytes.buffering'='10000000';
    set 'auto.offset.reset'='earliest';

    CREATE STREAM courses_src (course_id INTEGER, course_name STRING) WITH (KAFKA_TOPIC='demo.mydb.courses', VALUE_FORMAT='AVRO');

    CREATE STREAM courses_src_rekey WITH (PARTITIONS=1) AS \ SELECT * FROM courses_src PARTITION BY course_id;

    CREATE TABLE courses (course_id INTEGER PRIMARY KEY, course_name STRING)\ WITH (KAFKA_TOPIC='COURSES_SRC_REKEY', VALUE_FORMAT='AVRO');



    CREATE STREAM subjects_src (subject_id INTEGER, subject_name STRING, course_id INTEGER) WITH (KAFKA_TOPIC='dbserver1.public.subjects', VALUE_FORMAT='AVRO');

    CREATE STREAM subjects_src_rekey WITH (PARTITIONS=1) AS \ SELECT * FROM subjects_src PARTITION BY subject_id;

    CREATE TABLE subjects (subject_id INTEGER PRIMARY KEY, subject_name STRING, course_id INTEGER)\ WITH (KAFKA_TOPIC='SUBJECTS_SRC_REKEY', VALUE_FORMAT='AVRO');


    
    CREATE STREAM chapters_src (chapter_id INTEGER, chapter_name STRING, subject_id INTEGER) WITH (KAFKA_TOPIC='local.class.chapters', VALUE_FORMAT='AVRO');

    CREATE STREAM chapters_src_rekey WITH (PARTITIONS=1) AS \ SELECT * FROM chapters_src PARTITION BY chapter_id;

    CREATE TABLE chapters (chapter_id INTEGER PRIMARY KEY, chapter_name STRING, subject_id INTEGER)\ WITH (KAFKA_TOPIC='CHAPTERS_SRC_REKEY', VALUE_FORMAT='AVRO');

   
   
    CREATE STREAM subchapters_src (subchapter_id INTEGER, subchapter_name STRING, chapter_id INTEGER) WITH (KAFKA_TOPIC='file.subchap', VALUE_FORMAT='AVRO');

    CREATE STREAM subchapters_src_rekey WITH (PARTITIONS=1) AS \ SELECT * FROM subchapters_src PARTITION BY subchapter_id;

    CREATE TABLE subchapters (subchapter_id INTEGER PRIMARY KEY, subchapter_name STRING, chapter_id INTEGER)\ WITH (KAFKA_TOPIC='SUBCHAPTERS_SRC_REKEY', VALUE_FORMAT='AVRO');


    CREATE TABLE class_boost AS \
        SELECT courses.course_name, \
            subjects.subject_name, \
            chapters.chapter_name, \
            subchapters.subchapter_name \
        FROM courses \
        LEFT JOIN subjects ON courses.course_id = subjects.subject_id
        LEFT JOIN chapters ON subjects.subject_id = chapters.chapter_id
        LEFT JOIN subchapters ON chapters.chapter_id = subchapters.subchapter_id emit changes;

EOF

echo completed process
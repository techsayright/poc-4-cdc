docker-compose exec -T ksqldb-cli ksql http://ksqldb-server:8088 <<-EOF
    show topics;

    set 'commit.interval.ms'='2000';
    set 'cache.max.bytes.buffering'='10000000';
    set 'auto.offset.reset'='earliest';

    CREATE STREAM courses_src (course_id INTEGER, course_name STRING) WITH (KAFKA_TOPIC='demo.class.courses', VALUE_FORMAT='AVRO');

    CREATE STREAM courses_src_rekey WITH (PARTITIONS=1) AS \ SELECT * FROM courses_src PARTITION BY course_id;

    CREATE TABLE courses (course_id INTEGER PRIMARY KEY, course_name STRING)\ WITH (KAFKA_TOPIC='COURSES_SRC_REKEY', VALUE_FORMAT='AVRO');



    CREATE STREAM subjects_src (subject_id INTEGER, subject_name STRING, course_id INTEGER) WITH (KAFKA_TOPIC='dbserver1.public.subjects', VALUE_FORMAT='AVRO');

    CREATE STREAM subjects_src_rekey WITH (PARTITIONS=1) AS \ SELECT * FROM subjects_src PARTITION BY subject_id;

    CREATE TABLE subjects (subject_id INTEGER PRIMARY KEY, subject_name STRING, course_id INTEGER)\ WITH (KAFKA_TOPIC='SUBJECTS_SRC_REKEY', VALUE_FORMAT='AVRO');


    
    CREATE STREAM chapters_src (chapter_id INTEGER, chapter_name STRING, subject_id INTEGER) WITH (KAFKA_TOPIC='local.class.chapters', VALUE_FORMAT='AVRO');

    CREATE STREAM chapters_src_rekey WITH (PARTITIONS=1) AS \ SELECT * FROM chapters_src PARTITION BY chapter_id;

    CREATE TABLE chapters (chapter_id INTEGER PRIMARY KEY, chapter_name STRING, subject_id INTEGER)\ WITH (KAFKA_TOPIC='CHAPTERS_SRC_REKEY', VALUE_FORMAT='AVRO');

   
   
    CREATE STREAM subchapters_src (subchapter_id INTEGER, subchapter_name STRING, chapter_id INTEGER) WITH (KAFKA_TOPIC='file.subchap', VALUE_FORMAT='JSON');

    CREATE STREAM subchapters_src_rekey WITH (PARTITIONS=1) AS \ SELECT * FROM subchapters_src PARTITION BY chapter_id;

    CREATE TABLE subchapters (subchapter_id INTEGER , subchapter_name STRING, chapter_id INTEGER PRIMARY KEY)\ WITH (KAFKA_TOPIC='SUBCHAPTERS_SRC_REKEY', VALUE_FORMAT='JSON');



    CREATE TABLE course_sub AS SELECT courses.course_id as course_id, course_name, subjects.course_id as subject_id, subject_name FROM courses INNER JOIN subjects ON courses.course_id = subjects.subject_id;

    CREATE TABLE chap_sub AS SELECT chapters.chapter_id as chapter_id, chapter_name, subject_id, subchapter_id, subchapter_name  FROM chapters INNER JOIN subchapters ON chapters.chapter_id = subchapters.chapter_id;

    CREATE TABLE class_boost AS SELECT course_id, course_name, chap_sub.subject_id as subject_id, subject_name, chapter_id, chapter_name, subchapter_id, subchapter_name FROM course_sub INNER JOIN chap_sub ON course_sub.course_id = chap_sub.chapter_id;

EOF
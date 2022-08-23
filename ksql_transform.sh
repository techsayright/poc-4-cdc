
show topics;

set 'commit.interval.ms'='2000';
set 'cache.max.bytes.buffering'='10000000';
set 'auto.offset.reset'='earliest';

# for courses table
create stream courses_src (course_id INTEGER, course_name STRING) WITH (KAFKA_TOPIC='demo.mydb.courses', VALUE_FORMAT='AVRO');

CREATE STREAM admission_src_rekey WITH (PARTITIONS=1) AS \ SELECT * FROM admission_src PARTITION BY student_id;
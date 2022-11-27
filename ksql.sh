docker-compose exec -T ksqldb-cli ksql http://ksqldb-server:8088 <<-EOF
    show topics;

    set 'commit.interval.ms'='5000';
    set 'cache.max.bytes.buffering'='10000000';
    set 'auto.offset.reset'='earliest';


    CREATE STREAM student1 WITH (KAFKA_TOPIC='demo.class.student', VALUE_FORMAT='AVRO');

    CREATE OR REPLACE STREAM student1_src WITH (
    kafka_topic = 'student1_src',
    VALUE_FORMAT='AVRO'
)   AS
    SELECT *, rowtime AS time FROM student1
    EMIT CHANGES;



    CREATE STREAM student2 WITH (KAFKA_TOPIC='dbserver1.public.student', VALUE_FORMAT='AVRO');

    CREATE OR REPLACE STREAM student2_src WITH (
    kafka_topic = 'student2_src',
    VALUE_FORMAT='AVRO'
)   AS
    SELECT _id, first_name, last_name, cast(__deleted as BOOLEAN) as __deleted, rowtime AS time FROM student2
    EMIT CHANGES;


    
    CREATE STREAM student3 WITH (KAFKA_TOPIC='local.class.student', VALUE_FORMAT='AVRO');

    CREATE OR REPLACE STREAM student3_src WITH (
    kafka_topic = 'student3_src',
    VALUE_FORMAT='AVRO'
)   AS
    SELECT  _id, first_name, last_name, cast(__deleted as BOOLEAN) as __deleted, rowtime AS time FROM student3
    EMIT CHANGES;

   
   
   
    CREATE STREAM student4 (_id INTEGER, first_name STRING, last_name STRING, __deleted BOOLEAN) WITH (KAFKA_TOPIC='file.student', VALUE_FORMAT='JSON');

    CREATE OR REPLACE STREAM student4_src WITH (
    kafka_topic = 'student4_src',
    VALUE_FORMAT='AVRO'
)   AS
    SELECT *, rowtime AS time FROM student4
    EMIT CHANGES;




    CREATE STREAM class AS SELECT * FROM student1_src EMIT CHANGES;
    INSERT INTO  class SELECT * FROM student2_src EMIT CHANGES;
    INSERT INTO  class SELECT * FROM student3_src EMIT CHANGES;
    INSERT INTO  class SELECT * FROM student4_src EMIT CHANGES;

    CREATE OR REPLACE STREAM CLASS_BOOST WITH (
    kafka_topic = 'CLASS_BOOST',
    VALUE_FORMAT='AVRO'
)   AS
    SELECT * FROM class EMIT CHANGES;


EOF
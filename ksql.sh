docker-compose exec -T ksqldb-cli ksql http://ksqldb-server:8088 <<-EOF
    show topics;

    set 'commit.interval.ms'='5000';
    set 'cache.max.bytes.buffering'='10000000';
    set 'auto.offset.reset'='earliest';


    CREATE STREAM student1 WITH (KAFKA_TOPIC='demo.class.student', VALUE_FORMAT='AVRO');

    CREATE OR REPLACE STREAM class_boost WITH (
    kafka_topic = 'class_boost',
    VALUE_FORMAT='AVRO'
)   AS
    SELECT *, rowtime AS time FROM student1
    EMIT CHANGES;



    CREATE STREAM student2 WITH (KAFKA_TOPIC='dbserver1.public.student', VALUE_FORMAT='AVRO');

    CREATE OR REPLACE STREAM class_boost WITH (
    kafka_topic = 'class_boost',
    VALUE_FORMAT='AVRO'
)   AS
    SELECT *, rowtime AS time FROM student2
    EMIT CHANGES;



    
    CREATE STREAM student3 WITH (KAFKA_TOPIC='local.class.student', VALUE_FORMAT='AVRO');

    CREATE OR REPLACE STREAM class_boost WITH (
    kafka_topic = 'class_boost',
    VALUE_FORMAT='AVRO'
)   AS
    SELECT *, rowtime AS time FROM student3
    EMIT CHANGES;

   
   
    CREATE STREAM student4 (_id INTEGER KEY, first_name STRING, last_name STRING, __deleted BOOLEAN) WITH (KAFKA_TOPIC='file.student', VALUE_FORMAT='JSON');

    CREATE OR REPLACE STREAM class_boost WITH (
    kafka_topic = 'class_boost',
    VALUE_FORMAT='AVRO'
)   AS
    SELECT *, rowtime AS time FROM student4
    EMIT CHANGES;

EOF
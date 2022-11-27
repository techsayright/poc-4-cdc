from time import sleep
from json import dumps
from kafka import KafkaProducer
import csv

# initializing the Kafka producer
sleep(8)
my_producer = KafkaProducer(
    bootstrap_servers=['broker0:19092'],
    value_serializer=lambda x:dumps(x).encode('utf-8')
)

with open('./student4.csv') as file:
    reader = csv.DictReader(file, delimiter=",")
    for row in reader:
        my_producer.send('file.student', value = row)
        my_producer.flush()
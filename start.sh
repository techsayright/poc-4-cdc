#!/bin/sh

# echo What is Your Name?

# read name

# echo =======================================
# echo Hey $name, Welcome
# echo =======================================


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

sleep 10

echo half completed process
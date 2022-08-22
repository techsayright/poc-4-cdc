#!/bin/sh

mongoimport --uri mongodb://mongo1:27017/mydb --collection courses --type json --file "home/config/Data/courses.json" --jsonArray
#!/bin/sh

mongoimport --uri mongodb://mongo1:27017/class --collection courses --type json --file "home/config/Data/courses.json" --jsonArray
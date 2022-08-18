FROM mysql:5.7

COPY mysql.cnf /etc/mysql/conf.d/
# COPY mysql.cnf /etc/mysql/conf.d/custom.cnf
COPY inventory.sql /docker-entrypoint-initdb.d/
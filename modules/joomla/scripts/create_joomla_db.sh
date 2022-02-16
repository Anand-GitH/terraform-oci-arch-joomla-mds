#!/bin/bash

joomlaschema="${joomla_schema}"
joomlaname="${joomla_name}"

mysqlsh --user ${admin_username} --password=${admin_password} --host ${mds_ip} --sql -e "CREATE DATABASE $joomlaschema;"
mysqlsh --user ${admin_username} --password=${admin_password} --host ${mds_ip} --sql -e "CREATE USER $joomlaname identified by '${joomla_password}';"
mysqlsh --user ${admin_username} --password=${admin_password} --host ${mds_ip} --sql -e "GRANT ALL PRIVILEGES ON $joomlaschema.* TO $joomlaname;"

echo "Joomla Database and User created !"
echo "JOOMLA USER = $joomlaname"
echo "JOOMLA SCHEMA = $joomlaschema"

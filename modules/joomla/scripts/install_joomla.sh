#!/bin/bash
#set -x

export use_shared_storage='${use_shared_storage}'

if [[ $use_shared_storage == "true" ]]; then
  echo "Mount NFS share: ${joomla_shared_working_dir}"
  yum install -y -q nfs-utils
  mkdir -p ${joomla_shared_working_dir}
  echo '${mt_ip_address}:${joomla_shared_working_dir} ${joomla_shared_working_dir} nfs nosharecache,context="system_u:object_r:httpd_sys_rw_content_t:s0" 0 0' >> /etc/fstab
  setsebool -P httpd_use_nfs=1
  mount ${joomla_shared_working_dir}
  mount
  echo "NFS share mounted."
  cd ${joomla_shared_working_dir}
else
  echo "No mount NFS share. Moving to /var/www/html" 
  cd /var/www/html	
fi

wget https://downloads.joomla.org/cms/joomla3/3-9-26/Joomla_3-9-26-Stable-Full_Package.tar.gz
tar zxvf Joomla_3-9-26-Stable-Full_Package.tar.gz
rm -rf Joomla_3-9-26-Stable-Full_Package.tar.gz
if [[ $use_shared_storage == "true" ]]; then
	cp ${joomla_shared_working_dir}/htaccess.txt ${joomla_shared_working_dir}/.htaccess
  chown apache:apache -R ${joomla_shared_working_dir}
else
  cp /var/www/html/htaccess.txt /var/www/html/.htaccess
	chown apache:apache -R /var/www/html
fi

sed -i '/memory_limit = 128M/c\memory_limit = 256M' /etc/httpd/conf/httpd.conf
sed -i '/max_execution_time = 30/c\max_execution_time = 240' /etc/httpd/conf/httpd.conf
sed -i '/max_input_time = 60/c\max_input_time = 120' /etc/httpd/conf/httpd.conf
sed -i '/post_max_size = 8M/c\post_max_size = 50M' /etc/httpd/conf/httpd.conf

if [[ $use_shared_storage == "true" ]]; then
  echo "... Changing /etc/httpd/conf/httpd.conf with Document set to new shared NFS space ..."
  sed -i 's/"\/var\/www\/html"/"\${joomla_shared_working_dir}"/g' /etc/httpd/conf/httpd.conf
  echo "... /etc/httpd/conf/httpd.conf with Document set to new shared NFS space ..."
fi

## Joomla setup
if [[ $use_shared_storage == "true" ]]; then
  export DBUSER='${joomla_schema}'
  sed -i "s/\$user = ''/\$user = '$DBUSER'/" ${joomla_shared_working_dir}/installation/configuration.php-dist
  export DBPASS='${joomla_password}'
  sed -i "s/\$password = ''/\$password = '$DBPASS'/" ${joomla_shared_working_dir}/installation/configuration.php-dist
  export DBHOST='${mds_ip}'
  sed -i "s/\$host = 'localhost'/\$host = '$DBHOST'/" ${joomla_shared_working_dir}/installation/configuration.php-dist
  export DBNAME='${joomla_name}'
  sed -i "s/\$db = ''/\$db = '$DBNAME'/" ${joomla_shared_working_dir}/installation/configuration.php-dist 
  export DBPREFIX='${joomla_prefix}'  
  sed -i "s/\$dbprefix = 'jos_'/\$dbprefix = '$DBPREFIX'/" ${joomla_shared_working_dir}/installation/configuration.php-dist   
  mkdir ${joomla_shared_working_dir}/tmps
  chown apache:apache -R ${joomla_shared_working_dir}/tmps
  mkdir ${joomla_shared_working_dir}/logs
  chown apache:apache -R ${joomla_shared_working_dir}/logs
  sed -i "s/\$tmp_path = '\/tmp'/\$tmp_path = '\${joomla_shared_working_dir}\/tmps'/" ${joomla_shared_working_dir}/installation/configuration.php-dist
  sed -i "s/\$log_path = '\/administrator\/logs'/\$log_path = '\${joomla_shared_working_dir}\/logs'/" ${joomla_shared_working_dir}/installation/configuration.php-dist
  sed -i "s/\$cache_handler = 'file'/\$cache_handler = ''/" ${joomla_shared_working_dir}/installation/configuration.php-dist
  mv ${joomla_shared_working_dir}/installation/configuration.php-dist ${joomla_shared_working_dir}/configuration.php
  sed -i "s/#__/$DBPREFIX/" ${joomla_shared_working_dir}/installation/sql/mysql/joomla.sql
  mysqlsh --user $DBUSER --password=$DBPASS --host $DBHOST --database=$DBNAME --sql --file ${joomla_shared_working_dir}/installation/sql/mysql/joomla.sql
  
  mysqlsh --user $DBUSER --password=$DBPASS --host $DBHOST --database=$DBNAME --sql -e "INSERT INTO \`${joomla_prefix}users\` (\`id\`, \`name\`, \`username\`, \`email\`, \`password\`, \`block\`, \`sendEmail\`, \`registerDate\`, \`lastvisitDate\`, \`activation\`, \`params\`, \`lastResetTime\`, \`resetCount\`, \`otpKey\`, \`otep\`, \`requireReset\`) VALUES ('2', 'Me', '${joomla_console_user}', '${joomla_console_email}', '${joomla_console_password}', '0', '0', CURDATE(), CURDATE(), '', '', CURDATE() , '0', '', '', '0');" 
  mysqlsh --user $DBUSER --password=$DBPASS --host $DBHOST --database=$DBNAME --sql -e "SELECT * from \`${joomla_prefix}users\`;"
  mysqlsh --user $DBUSER --password=$DBPASS --host $DBHOST --database=$DBNAME --sql -e "INSERT INTO \`${joomla_prefix}user_usergroup_map\` (\`user_id\`, \`group_id\`) VALUES ('2', '8');"    
  #mysqlsh --user $DBUSER --password=$DBPASS --host $DBHOST --database=$DBNAME --sql -e "ALTER TABLE \`$DBPREFIXusers\` auto_increment = $JUSERINC;" 
  rm -rf ${joomla_shared_working_dir}/installation/
else
  export DBUSER='${joomla_schema}'
  sed -i "s/\$user = ''/\$user = '$DBUSER'/" /var/www/html/installation/configuration.php-dist
  export DBPASS='${joomla_password}'
  sed -i "s/\$password = ''/\$password = '$DBPASS'/" /var/www/html/installation/configuration.php-dist
  export DBHOST='${mds_ip}'
  sed -i "s/\$host = 'localhost'/\$host = '$DBHOST'/" /var/www/html/installation/configuration.php-dist
  export DBNAME='${joomla_name}'
  sed -i "s/\$db = ''/\$db = '$DBNAME'/" /var/www/html/installation/configuration.php-dist 
  export DBPREFIX='${joomla_prefix}'  
  sed -i "s/\$dbprefix = 'jos_'/\$dbprefix = '$DBPREFIX'/" /var/www/html/installation/configuration.php-dist   
  mkdir /var/www/html/tmps
  chown apache:apache -R /var/www/html/tmps
  mkdir /var/www/html/logs
  chown apache:apache -R /var/www/html/logs
  sed -i "s/\$tmp_path = '\/tmp'/\$tmp_path = '\/var\/www\/html\/tmp'/" /var/www/html/installation/configuration.php-dist
  sed -i "s/\$log_path = '\/administrator\/logs'/\$log_path = '\/var\/www\/html\/logs'/" /var/www/html/installation/configuration.php-dist
  sed -i "s/\$cache_handler = 'file'/\$cache_handler = ''/" /var/www/html/installation/configuration.php-dist
  mv /var/www/html/installation/configuration.php-dist /var/www/html/configuration.php
  sed -i "s/#__/$DBPREFIX/" /var/www/html/installation/sql/mysql/joomla.sql
  mysqlsh --user $DBUSER --password=$DBPASS --host $DBHOST --database=$DBNAME --sql --file /var/www/html/installation/sql/mysql/joomla.sql

  mysqlsh --user $DBUSER --password=$DBPASS --host $DBHOST --database=$DBNAME --sql -e "INSERT INTO \`${joomla_prefix}users\` (\`id\`, \`name\`, \`username\`, \`email\`, \`password\`, \`block\`, \`sendEmail\`, \`registerDate\`, \`lastvisitDate\`, \`activation\`, \`params\`, \`lastResetTime\`, \`resetCount\`, \`otpKey\`, \`otep\`, \`requireReset\`) VALUES ('5', 'Me', '${joomla_console_user}', '${joomla_console_email}', '${joomla_console_password}', '0', '0', CURDATE(), CURDATE(), '', '', CURDATE() , '0', '', '', '0');" 
  mysqlsh --user $DBUSER --password=$DBPASS --host $DBHOST --database=$DBNAME --sql -e "SELECT * from \`${joomla_prefix}users\`;"
  mysqlsh --user $DBUSER --password=$DBPASS --host $DBHOST --database=$DBNAME --sql -e "INSERT INTO \`${joomla_prefix}user_usergroup_map\` (\`user_id\`, \`group_id\`) VALUES ('5', '8');"    
  #mysqlsh --user $DBUSER --password=$DBPASS --host $DBHOST --database=$DBNAME --sql -e "ALTER TABLE \`${joomla_prefix}IXusers\` auto_increment = $JUSERINC;" 
  rm -rf /var/www/html/installation/
fi

systemctl start httpd
systemctl enable httpd

echo "Joomla! is installed and Apache started !"

#add for chkconfig 
#chkconfig: 2345 70 30 
#description: xingcloud analytics
#processname: xa-analytics

redis-server /etc/redis.conf

/home/app/nginx -c /home/app/nginx/conf/nginx.conf

cd /home/app/apps/analytic2.0/current;RAILS_ENV=production bundle exec thin -C config/private_pub_thin.yml restart

rake resque:restart
rake resque:scheduler:restart



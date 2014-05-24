wget http://download.redis.io/releases/redis-2.8.9.tar.gz
tar -xvzf redis-2.8.9.tar.gz
cd redis-2.8.9
make
make install

curl "http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/ip" -H "Metadata-Flavor: Google" > /tmp/addr

cp redis.conf redis.conf.orig;
perl -pi -e "s/logfile\s+stdout/logfile \/var\/log\/redis.log/" redis.conf;
perl -pi -e "s/daemonize\s+no/daemonize yes/" redis.conf;
perl -pi -e "s/#\s+(bind\s*)[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/\$1 `cat /tmp/addr`/" redis.conf;
perl -pi -e "s/pidfile\s+\/var\/run\/redis.pid/pidfile \/var\/run\/redis_6379.pid/" redis.conf;

# if [ ! "${REDIS_MASTER}x" == "x" ]; then
#   echo slaveof $REDIS_MASTER 6379 >> redis.conf
# fi

mkdir /etc/redis
cp redis.conf /etc/redis/6379.conf

cp utils/redis_init_script /etc/init.d/redis_6379

update-rc.d redis_6379 defaults

/etc/init.d/redis_6379 start

touch /etc/redis/26379.conf
cat <<EOF >> /etc/redis/26379.conf
port 26379
sentinel monitor mymaster 127.0.0.1 6379 2
sentinel down-after-milliseconds mymaster 5000
sentinel failover-timeout mymaster 900000
sentinel parallel-syncs mymaster 1
daemonize yes
loglevel notice
logfile /var/log/redis-sentinel.log
pidfile /var/run/redis_26379.pid
EOF

cp utils/redis_init_script /etc/init.d/redis_26379
perl -pi -e 's/\$CONF/\$CONF --sentinel/' /etc/init.d/redis_26379
perl -pi -e 's/REDISPORT=6379/REDISPORT=26379/' /etc/init.d/redis_26379
perl -pi -e 's/\$CLIEXEC -p \$REDISPORT shutdown/kill -2 \$PID; rm -rf \$PIDFILE/' /etc/init.d/redis_26379
update-rc.d redis_26379 defaults

/etc/init.d/redis_26379 start

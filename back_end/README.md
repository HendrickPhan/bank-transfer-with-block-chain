# start docker
docker-compose up -d

# start cronjob
docker exec -u 0 -it bc-php bash
cron
crontab -e
* * * * * cd /var/www && php artisan schedule:run >/var/log/cron.log 2>&1

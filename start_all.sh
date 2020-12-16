docker start bc-db 
docker start bc-php
docker start bc-queue
docker start bc-cron
docker start bc-nginx
docker start bc-eth
docker exec -it -d bc-eth bash -c "/app/bc_node/start.sh &"
sleep 4
docker start bc-node
docker start bc-crawl
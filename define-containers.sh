#!/bin/bash 

echo "Snapshot before (containers running)"
sudo docker ps

echo "Stopping the following containers:"
sudo docker stop plex
sudo docker stop sonarr
sudo docker stop couchpotato

echo "Removing the following containers:" 
sudo docker rm plex
sudo docker rm sonarr
sudo docker rm couchpotato

echo "Pulling new images"
sudo docker pull plexinc/pms-docker
sudo docker pull linuxserver/sonarr
sudo docker pull linuxserver/couchpotato

echo "Recreating containers"
sudo docker run --name plex -d --restart=unless-stopped --net=host -e TZ="America/New_York" -v /media/docker/plex/database:/config -v /media/docker/plex/transcode:/transcode -v /media:/data plexinc/pms-docker
sudo docker run --name=sonarr -d --restart=unless-stopped -p 8989:8989 -e PUID=1000 -e PGID=1000 -e TZ="America/New_York" -v /media/docker/sonarr:/config -v /media/tv/Active:/tv -v /media/downloaders/Completed/TV:/downloads linuxserver/sonarr
sudo docker run --name=couchpotato -d --restart=unless-stopped -p 5050:5050 -e PUID=1000 -e PGID=1000 -e TZ="America/New_York" -v /media/docker/couchpotato:/config -v /media/movies/2_Archive:/movies -v /media/downloaders/Completed/Movies:/downloads linuxserver/couchpotato

echo "Sanpshot after (containers running)"
sudo docker ps
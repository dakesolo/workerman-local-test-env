## System
Only CentOS 7.*
## Install
curl -sfL https://raw.githubusercontent.com/dakesolo/workerman-local-test-env/master/install.sh | sh -
## Detail
**--docker run**

The installed file have a command like:  

`docker run --name workerman -p 80:5001 -v /home/wwwroot:/var/www -d dake/php:v1 /bin/bash start.sh`  

So,you must upload your workerman projects to the host at `/home/wwwroot` first.  
Login the host with sftp 22,and create development project at phpstorm,specially turn on `auto upload`. 

## Some command
`docker rmi ??`  
`docker images`  
`docker ps -a`  
`docker stop $(docker ps -a -q)`  
`docker rm $(docker ps -a -q)`  
`docker run --name workerman -p 80:5001 -v /home/wwwroot:/var/www -it dake/php:v1 /bin/bash start.sh`  
`docker logs ?? --details`  


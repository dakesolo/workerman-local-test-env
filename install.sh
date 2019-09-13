yum -y install yum-utils
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce-18.06.1.ce-3.el7
systemctl enable docker && systemctl start docker
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
systemctl stop firewalld.service
systemctl disable firewalld.service
systemctl restart docker
docker login --username=original_dk@163.com registry.cn-hangzhou.aliyuncs.com
docker pull registry.cn-hangzhou.aliyuncs.com/dakesole/php:v2
docker tag registry.cn-hangzhou.aliyuncs.com/dakesole/php:v2 dakesole/php:v2
docker run --name workerman-spike --restart=always -p 80:5001 -v /home/wwwroot:/home/wwwroot -d dakesolo/php:v2 php think worker
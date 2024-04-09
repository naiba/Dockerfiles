# PHP docker all-in-one

```shell
# Download docker-compose.yml & related files
wget https://github.com/naiba/Dockerfiles/archive/refs/heads/master.zip
unzip master.zip
cp -r Dockerfiles-master/php-docker-allinone/ ./your-app
rm -rf Dockerfiles-master/ master.zip
cd ./your-app
# Edit configuration https://www.digitalocean.com/community/tools/nginx
nano ./www-data/nginx/localhost.conf
# Edit port mapping if needed
nano docker-compose.yaml
# Start
docker-compose up -d
```

## Access

- http://www.localhost (default)
- http://mysql.localhost (MySQL Adminer)
- http://file.localhost (File Manager)


# Deploy LEMP Stack on Openstack Instance

This file list all commands you can see in the video : 
Titre_ Video : URL_Video

### Technology used:

<img src="https://static.linit.io/img/logo/openstack-logo.png" width="50"> <img src="https://static.linit.io/img/logo/linux-logo.png" width="50"> <img src="https://static.linit.io/img/logo/nginx-logo.png" width="50"> <img src="https://static.linit.io/img/logo/mariadb-logo.png" width="50"> <img src="https://static.linit.io/img/logo/php-logo.png" width="50">

All these command permit to deploy Wordpress in OpenStack instances, using LEMP Stack (Linux, Nginx (EngineX), MySQL/MariaDB, PHP) on Ubuntu Server 20.04

### Deployed Architecture:

<p align="center">
  <img src="https://static.linit.io/img/architectures/openstack-lemp.png" width="600"/>
</p>

### Update the server

```bash
sudo apt update
sudo apt full-upgrade
```

### Install all required software

```bash
sudo apt install php-fpm php-mysql php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip certbot python3-certbot-nginx
```

### Verify all services are started and enable at boot

```bash
sudo systemctl enable nginx
sudo systemctl restart nginx
sudo systemctl enable php7.4-fpm
sudo systemctl restart php7.4-fpm
sudo systemctl enable mariadb
sudo systemctl restart mariadb
```

### Configure MariaDB securely

```bash
sudo mysql_secure_installation
```

### Create MySQL/MariaDB database and user for wordpress

```bash
sudo mysql
```
#### /!\ All this commands bellow are executed in MySQL/MariaDB Shell

```sql
CREATE DATABASE wordpress_database_name;
GRANT ALL PRIVILEGES ON wordpress_database_name.* TO "wordpress_database_username"@"localhost" IDENTIFIED BY "wordpress_database_password";
FLUSH PRIVILEGES;
exit
```

### Download Wordpress and configure permissions

```
wget -O /tmp/wordpress.tar.gz https://wordpress.org/latest.tar.gz
sudo tar -xzvf /tmp/wordpress.tar.gz -C /var/www
sudo chown -R www-data:www-data /var/www/wordpress
```

### Configure Nginx web server with Wordpress

```bash
sudo vi /etc/nginx/sites-available/site_name.conf
```
Paste this content in your file:
```vim
server {

        server_name cloud-formation.com;
        root /var/www/wordpress;
        index index.php index.html index.htm;

            location / {
                try_files $uri $uri/ /index.php?$args;
            }

            location = /favicon.ico {
                log_not_found off;
                access_log off;
            }

            location ~* \.(js|css|png|jpg|jpeg|gif|ico)$ {
                expires max;
                log_not_found off;
            }

            location = /robots.txt {
                allow all;
                log_not_found off;
                access_log off;
            }

           location ~ \.php$ {
                include snippets/fastcgi-php.conf;
                fastcgi_pass unix:/run/php/php7.4-fpm.sock;
                fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
                include fastcgi_params;
           }
    access_log  /var/log/nginx/access-wordpress.log;
    error_log  /var/log/nginx/error-wordpress.log  warn;
    
}

```

### Disabling default website and activate wordpress configuration

```bash
sudo rm /etc/nginx/sites-enabled/default
sudo ln -s /etc/nginx/sites-available/site_name.conf /etc/nginx/sites-enabled/site_name;conf
sudo systemctl reload nginx
```

### Enabling HTTPS on Wordpress website

```bash
sudo certbot --nginx
sudo systemctl status certbot.timer
```

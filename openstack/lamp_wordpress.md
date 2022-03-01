# Deploy LAMP Stack on Openstack Instance

This file list all commands you can see in the video : 
Titre_ Video : URL_Video

### Technology used:

<img src="https://static.linit.io/img/logo/openstack-logo.png" width="50"> <img src="https://static.linit.io/img/logo/linux-logo.png" width="50"> <img src="https://static.linit.io/img/logo/apache-logo.png" width="50"> <img src="https://static.linit.io/img/logo/mariadb-logo.png" width="50"> <img src="https://static.linit.io/img/logo/php-logo.png" width="50">

All these command permit to deploy Wordpress in OpenStack instances, using LAMP Stack (Linux, Apache, MySQL/MariaDB, PHP) on Ubuntu Server 20.04

### Deployed Architecture:

<p align="center">
  <img src="https://static.linit.io/img/architectures/openstack-lamp.png" width="600"/>
</p>

### Update the server

```bash
sudo apt update
sudo apt full-upgrade
```

### Install all required software

```bash
sudo apt install apache2 mariadb-server php libapache2-mod-php php-mysql php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip certbot python3-certbot-apache
```

### Verify all services are started and enable at boot

```bash
sudo systemctl enable apache2
sudo systemctl restart apache2
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

### Configure Apache web server with Wordpress

```bash
sudo vi /etc/apache2/sites-available/site_name.conf
```
Paste this content in your file:
```vim
<VirtualHost *:80>
    ServerAdmin kevin@domain.tld
    ServerName blog.domain.tld
    DocumentRoot /var/www/wordpress

    # Custom log files, to differentiate from root server
    ErrorLog ${APACHE_LOG_DIR}/error-wordpress.log
    CustomLog ${APACHE_LOG_DIR}/access-wordpress.log combined
    
    Alias /wp-content /var/www/wordpress/wp-content

    <Directory /var/www/wordpress>
        Options FollowSymLinks
        AllowOverride Limit Options FileInfo
        DirectoryIndex index.php
        Require all granted
    </Directory>
    <Directory /var/www/wordpress/wp-content>
        Options FollowSymLinks
        Require all granted
    </Directory>
</VirtualHost>
```

### Disabling default website and activate wordpress configuration

```bash
sudo a2dissite 000-default
sudo a2ensite site_name.conf
sudo systemctl reload apache2
```

### Enabling HTTPS on Wordpress website

```bash
sudo certbot --apache
sudo systemctl status certbot.timer
```

# This file list all commands you can see in the video :
# Titre_ Video : URL_Video

# All these command permit to deploy Wordpress in OpenStack instances
# Using LAMP Stack (Linux, Apache, MySQL/MariaDB, PHP) on Ubuntu Server

## Update the server

```
sudo apt update
sudo apt full-upgrade
```

# Install all required software

```
sudo apt install apache2 mariadb-server php libapache2-mod-php php-mysql php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip certbot python3-certbot-apache
```

# Verify all services are started and enable at boot

```
sudo systemctl enable apache2
sudo systemctl restart apache2
sudo systemctl enable mariadb
sudo systemctl restart mariadb
```

# Configure MariaDB securely

```
sudo mysql_secure_installation
```

# Create MySQL/MariaDB database and user for wordpress

```
sudo mysql
CREATE DATABASE wordpress_database_name;
GRANT ALL PRIVILEGES ON wordpress_database_name.* TO "wordpress_database_username"@"localhost" IDENTIFIED BY "wordpress_database_password";
FLUSH PRIVILEGES;
exit
```

# Download Wordpress and configure permissions

```
wget -O /tmp/wordpress.tar.gz https://wordpress.org/latest.tar.gz
sudo tar -xzvf /tmp/wordpress.tar.gz -C /var/www
sudo chown -R www-data:www-data /var/www/wordpress
```

# Configure Apache web server with Wordpress

```
sudo vi /etc/apache2/sites-available/site_name.conf
```
Paste this content in your file:
```
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

# Disabling default website and activate wordpress configuration

```
sudo a2dissite 000-default
sudo a2ensite site_name.conf
sudo systemctl reload apache2
```

# Enabling HTTPS on Wordpress website

```
sudo apt install certbot python3-certbot-apache
sudo certbot --apache
sudo systemctl status certbot.timer
```

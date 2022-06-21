CREATE DATABASE wordpress;
GRANT ALL PRIVILEGES ON wordpress.* TO "wordpress-user"@"%" IDENTIFIED BY "wordpress-password";
FLUSH PRIVILEGES;
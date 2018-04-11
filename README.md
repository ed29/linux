# Linux with x11 and openbox custom configure

Install linux minimal, x window server, openbox, then do some configures for it, that is it, a simple operate system.

## Installed rpm for centos 7 :

* epel-release
* xorg-x11-server-xorg
* xorg-x11-drivers
* xorg-x11-xinit
* openbox
* xterm
* wqy-microhei-fonts
* ibus-libpinyin
* caja
* gnome-themes-standard



安装lnmp

添加软件仓库：
sudo yum install epel-release
sudo rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
开始安装：
sudo yum install git ImageMagick nginx mariadb-server php71w-fpm php71w-mysqlnd php71w-cli php71w-gd php71w-mbstring php71w-xml php71w-opcache php71w-intl
启动：
sudo systemctl start nginx mariadb php-fpm
设置开机自启：
sudo systemctl enable nginx mariadb php-fpm
运行mariadb安全向导设置mysql root密码：
mysql_secure_installation
设置php用户：
sudo vi /etc/php-fpm.d/www.conf
user = nginx
group = nginx

完成 lnmp 的安装了。添加一个网站xxx.com的nginx配置：
sudo vi /etc/nginx/conf.d/xxx.com.conf
内容为：
limit_req_zone $binary_remote_addr zone=one:10m rate=1r/s;
limit_req_zone $binary_remote_addr zone=two:10m rate=30r/s;
set_real_ip_from   199.27.128.0/21;
set_real_ip_from   173.245.48.0/20;
set_real_ip_from   103.21.244.0/22;
set_real_ip_from   103.22.200.0/22;
set_real_ip_from   103.31.4.0/22;
set_real_ip_from   141.101.64.0/18;
set_real_ip_from   108.162.192.0/18;
set_real_ip_from   190.93.240.0/20;
set_real_ip_from   188.114.96.0/20;
set_real_ip_from   197.234.240.0/22;
set_real_ip_from   198.41.128.0/17;
set_real_ip_from   162.158.0.0/15;
set_real_ip_from   2400:cb00::/32;
set_real_ip_from   2606:4700::/32;
set_real_ip_from   2803:f800::/32;
set_real_ip_from   2405:b500::/32;
set_real_ip_from   2405:8100::/32;
real_ip_header     CF-Connecting-IP;
gzip            on;
gzip_min_length 1000;
gzip_proxied    any;
gzip_types      text/plain application/javascript application/x-javascript text/css application/xml text/javascript application/x-httpd-php font/ttf font/opentype font/x-woff image/svg+xml;
gzip_comp_level 6;

server {
    server_name www.ed29.com;
    return 301 $scheme://ed29.com$request_uri;
}

server {

    listen	80;
    listen 443 ssl;
    
    server_name ed29.com test.ed29.com;
    root /home/ed/ed29.com;

    index index.php;
    autoindex off;

    # SSL Certificate Configuration
    #ssl_certificate /etc/letsencrypt/live/wiki.hakase-labs.co/fullchain.pem;
    #ssl_certificate_key /etc/letsencrypt/live/wiki.hakase-labs.co/privkey.pem;

    client_max_body_size 5m;
    client_body_timeout 60;

    location / {
        try_files $uri $uri/ @rewrite;
        limit_req zone=one burst=5;
    }

    location @rewrite {
        rewrite ^/(.*)$ /index.php?title=$1&$args;
    }

    location ^~ /maintenance/ {
        return 403;
    }

    # PHP-FPM Configuration Nginx
    location ~ \.php$ {
        try_files $uri =404;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass 127.0.0.1:9000;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }

    location ~* \.(js|css|png|jpg|jpeg|gif|ico)$ {
        try_files $uri /index.php;
        expires max;
        log_not_found off;
        limit_req zone=two burst=50;
    }

    location = /_.gif {
        expires max;
        empty_gif;
    }

    location ^~ ^/(cache|includes|maintenance|languages|serialized|tests|images/deleted)/ {
        deny all;
    }

    location ^~ ^/(bin|docs|extensions|includes|maintenance|mw-config|resources|serialized|tests)/ {
        internal;
    }

    # Security for 'image' directory
    location ~* ^/images/.*.(html|htm|shtml|php)$ {
        types { }
        default_type text/plain;
    }

    # Security for 'image' directory
    location ^~ /images/ {
        try_files $uri /index.php;
    }

}












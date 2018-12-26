#！ /bin/sh

# 源码编译安装
sudo apt-get install build-essential libssl-dev
sudo apt-get install zlib1g-dev
sudo apt-get install libpcre3 libpcre3-dev
wget http://nginx.org/download/nginx-1.15.4.tar.gz
tar -zxvf nginx-1.15.4.tar.gz 
cd nginx-1.15.4/
./configure --prefix=/usr/local/nginx --with-http_stub_status_module --with-http_v2_module --with-http_gzip_static_module --with-http_sub_module --with-pcre --with-http_ssl_module # 配置nginx的安装参数，可以根据自己的需要进行调整
make 
sudo make install

# 设置为系统服务
(
cat <<EOF
[Unit]
Description=Nginx Daemon
After=syslog.target network-online.target
Wants=network-online.target
ConditionFileNotEmpty=/usr/local/nginx/conf/nginx.conf

[Service]
Type=forking
KillMode=process
ExecStart=/usr/local/nginx/sbin/nginx
ExecStop=/usr/local/nginx/sbin/nginx -s stop
ExecReload=/usr/local/nginx/sbin/nginx -s reload

[Install]
WantedBy=multi-user.target
EOF
) > nginx.service

sudo cp -a nginx.service /lib/systemd/system/nginx.service
sudo ln -s /lib/systemd/system/nginx.service /etc/systemd/system/multi-user.target.wants/nginx.service

# 设置开机启动
sudo systemctl start nginx
sudo systemctl status nginx
sudo systemctl enable nginx
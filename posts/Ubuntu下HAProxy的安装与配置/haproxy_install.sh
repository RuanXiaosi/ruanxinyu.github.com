#！ /bin/sh

# 源码编译安装
cd /tmp
sudo apt-get install build-essential libssl-dev
sudo apt-get install zlib1g-dev
sudo apt-get install libpcre3 libpcre3-dev
wget https://www.haproxy.org/download/1.8/src/haproxy-1.8.8.tar.gz
tar -zxvf haproxy-1.8.8.tar.gz
cd haproxy-1.8.8/
make TARGET=linux26 ARCH=x86_64 USE_PCRE=1 USE_OPENSSL=1 USE_ZLIB=1
sudo make install PREFIX=/usr/local/haproxy
sudo mkdir -p /etc/haproxy
sudo cp -a examples/transparent_proxy.cfg /etc/haproxy/haproxy.cfg

# 设置为系统服务
(
cat <<EOF
[Unit]
Description=HAproxy Daemon
After=syslog.target network-online.target
Wants=network-online.target
ConditionFileNotEmpty=/etc/haproxy/haproxy.cfg

[Service]
Type=forking
KillMode=process
ExecStart=/usr/local/haproxy/sbin/haproxy -f /etc/haproxy/haproxy.cfg
ExecReload=/bin/kill -HUP $MAINPID

[Install]
WantedBy=multi-user.target
EOF
) > haproxy.service

sudo cp -a haproxy.service /lib/systemd/system/haproxy.service
sudo ln -s /lib/systemd/system/haproxy.service /etc/systemd/system/multi-user.target.wants/haproxy.service

# 设置开机启动
sudo systemctl start haproxy
sudo systemctl status haproxy
sudo systemctl enable haproxy
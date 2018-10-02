#！ /bin/sh

# 源码编译安装
cd /tmp
sudo apt-get install build-essential libssl-dev
wget http://www.keepalived.org/software/keepalived-2.0.7.tar.gz
tar -zxvf keepalived-2.0.7.tar.gz
cd keepalived-2.0.7/
./configure --prefix=/usr/local/keepalived
make
sudo make install

# 创建超链接
sudo mkdir -p /etc/keepalived
sudo ln -s /usr/local/keepalived/sbin/keepalived /usr/sbin/
sudo ln -s /usr/local/keepalived/etc/keepalived/keepalived.conf /etc/keepalived/keepalived.conf
sudo ln -s /usr/local/keepalived/etc/sysconfig/keepalived /etc/default/keepalived

# 设置为系统服务
(
cat <<EOF
[Unit]
Description=Keepalive Daemon (LVS and VRRP)
After=syslog.target network-online.target
Wants=network-online.target
# Only start if there is a configuration file
ConditionFileNotEmpty=/etc/keepalived/keepalived.conf

[Service]
Type=forking
KillMode=process
# Read configuration variable file if it is present
EnvironmentFile=-/etc/default/keepalived
ExecStart=/usr/sbin/keepalived $KEEPALIVED_OPTIONS
ExecReload=/bin/kill -HUP $MAINPID

[Install]
WantedBy=multi-user.target
EOF
) > keepalived.service

sudo cp -a keepalived.service /lib/systemd/system/keepalived.service
sudo ln -s /lib/systemd/system/keepalived.service /etc/systemd/system/multi-user.target.wants/keepalived.service

# 设置开机启动
sudo systemctl start keepalived
sudo systemctl enable keepalived
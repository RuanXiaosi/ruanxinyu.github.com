#！ /bin/sh

# 源码编译安装
wget http://download.sonatype.com/nexus/3/nexus-3.13.0-01-unix.tar.gz
sudo mkdir -p /usr/local/nexus
sudo tar -zxvf nexus-3.13.0-01-unix.tar.gz -C /usr/local/nexus
sudo chown -R $(whoami):$(whoami) /usr/local/nexus

# 设置为系统服务
(
cat <<EOF
[Unit]
Description=Sonatyp Nexus Daemon
After=network.target
Wants=network-online.target

[Service]
Type=forking
LimitNOFILE=65536
ExecStart=/usr/local/nexus/nexus-3.13.0-01/bin/nexus start
ExecStop=/usr/local/nexus/nexus-3.13.0-01/bin/nexus stop
User=$(whoami)
Restart=on-abort

[Install]
WantedBy=multi-user.target
EOF
) > nexus.service

sudo cp -a nexus.service /lib/systemd/system/nexus.service
sudo ln -s /lib/systemd/system/nexus.service /etc/systemd/system/multi-user.target.wants/nexus.service

# 设置开机启动
sudo systemctl start nexus
sudo systemctl enable nexus
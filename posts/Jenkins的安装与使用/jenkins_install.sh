#！ /bin/sh

# 源码编译安装
cd /tmp
wget http://mirrors.jenkins.io/war-stable/latest/jenkins.war
sudo mkdir -p /usr/local/jenkins
sudo cp -a jenkins.war /usr/local/jenkins/
sudo chown -R $(whoami):$(whoami) /usr/local/jenkins
export JENKINS_HOME=

# 设置为系统服务
(
cat <<EOF
[Unit]
Description=Jenkins Daemon
After=syslog.target network-online.target
Wants=network-online.target
ConditionFileNotEmpty=/etc/haproxy/haproxy.cfg

[Service]
Type=forking
KillMode=process
ExecStart=/usr/local/haproxy/sbin/haproxy -f /etc/haproxy/haproxy.cfg
ExecReload=/bin/kill -HUP $MAINPID
User=$(whoami)

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
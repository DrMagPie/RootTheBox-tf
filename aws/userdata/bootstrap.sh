#! /bin/bash

echo 'Change directory to home/ec2-user'
echo "[*] Change directory to /opt..."
cd /opt || exit

echo "[*] Clone RootTheBox repository..."
git clone https://github.com/moloch--/RootTheBox.git && cd RootTheBox || exit

pip3 install awscli
aws s3 cp --recursive "s3://${BUCKET}/bkp" .
# aws s3 cp --recursive s3://${BUCKET}/bkp/files files

echo "[*] Installing Dependencies..."
chmod +x ./setup/depends.sh && DEBIAN_FRONTEND=noninteractive ./setup/depends.sh -y

# crontab -l | { cat; echo "0 */1 * * * /opt/bkp >> /var/log/bkp.log 2>&1"} | crontab -

echo "[*] Setup Permissions..."
chown ubuntu:ubuntu -R /opt/RootTheBox

echo "[*] Setup System D..."
systemctl enable rtb
systemctl start rtb
# cp setup/rtb.service /etc/systemd/system/
# systemctl set-environment "SQL_DIALECT=sqlite"
# systemctl daemon-reload

# sleep 300
certbot --nginx --agree-tos -m "${EMAIL}" -d "${DOMAIN}"

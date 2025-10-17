#!/bin/sh
echo "= = = Downloading bitwarden binary..."
curl -L "https://bitwarden.com/download/?app=cli&platform=linux" -o bw.zip
echo "= = = Unzipping..."
unzip bw.zip
echo "= = = Cleaning up"
rm bw.zip
echo "= = = Adding permissions..."
chmod +x bw
chmod +x 2-bw-login.sh
echo "= = = Ready ! - You can now login with 2-bw-login.sh..."
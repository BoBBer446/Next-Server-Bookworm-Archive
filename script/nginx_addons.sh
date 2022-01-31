#!/bin/bash
#Please check the license provided with the script!

install_nginx_addons() {

trap error_exit ERR

cd /root/NeXt-Server-Bullseye/sources
git clone https://github.com/nbs-system/naxsi.git -q 
}
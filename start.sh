#!/bin/sh

# configs
AUUID=446fc7c2-766b-11ed-a1eb-0242ac120002
CADDYIndexPage=https://github.com/AYJCSGM/mikutap/archive/master.zip
CONFIGCADDY=https://raw.githubusercontent.com/Lbingyi/HerokuXray/master/etc/Caddyfile
CONFIGXRAY=https://raw.githubusercontent.com/Lbingyi/HerokuXray/master/etc/xray.json
ParameterSSENCYPT=chacha20-ietf-poly1305
StoreFiles=https://raw.githubusercontent.com/Lbingyi/HerokuXray/master/etc/StoreFiles
#PORT=4433
mkdir -p /etc/caddy/ /usr/share/caddy && echo -e "User-agent: *\nDisallow: /" >/usr/share/caddy/robots.txt
wget $CADDYIndexPage -O /usr/share/caddy/index.html && unzip -qo /usr/share/caddy/index.html -d /usr/share/caddy/ && mv /usr/share/caddy/*/* /usr/share/caddy/
wget -qO- $CONFIGCADDY | sed -e "1c :$PORT" -e "s/\$AUUID/$AUUID/g" -e "s/\$MYUUID-HASH/$(caddy hash-password --plaintext $AUUID)/g" >/etc/caddy/Caddyfile
wget -qO- $CONFIGXRAY | sed -e "s/\$AUUID/$AUUID/g" -e "s/\$ParameterSSENCYPT/$ParameterSSENCYPT/g" >/xray.json

# storefiles
mkdir -p /usr/share/caddy/$AUUID && wget -O /usr/share/caddy/$AUUID/StoreFiles $StoreFiles
wget -P /usr/share/caddy/$AUUID -i /usr/share/caddy/$AUUID/StoreFiles

for file in $(ls /usr/share/caddy/$AUUID); do
    [[ "$file" != "StoreFiles" ]] && echo \<a href=\""$file"\" download\>$file\<\/a\>\<br\> >>/usr/share/caddy/$AUUID/ClickToDownloadStoreFiles.html
done

alias qtro="tor &"
alias webserverzz="/xray -config /xray.json &"
alias webfin="caddy run --config /etc/caddy/Caddyfile --adapter caddyfile"

# start
qtro
webserverzz
webfin



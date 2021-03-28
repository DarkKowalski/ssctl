# shadowsocks-libev + privoxy bash automation

**Read the source before using it!**

## Dependencies

- shadowsocks-libev
- privoxy
- curl
- jq
- vim

## Setup

### privoxy
```
# /etc/privoxy/config
listen-address         127.0.0.1:8118
forward-socks5t   /    127.0.0.1:10086 .
```

### ssctl
```
# ssctl.sh
PRIVOXY_HTTP_LOCAL="http://localhost:8118"
PRIVOXY_HTTPS_LOCAL="http://localhost:8118"
SS_ETC_DIR="/etc/shadowsocks"
SSCTL_EDITOR="vim"
```

```
# ~/.profile
source path/to/ssctl.sh
```

## Uage

```
ssctl help
```

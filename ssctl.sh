PRIVOXY_HTTP_LOCAL="http://localhost:8118"
PRIVOXY_HTTPS_LOCAL="http://localhost:8118"
SS_ETC_DIR="/etc/shadowsocks"
SSCTL_EDITOR="vim"

alias withproxy="http_proxy=${PRIVOXY_HTTP_LOCAL} https_proxy=${PRIVOXY_HTTPS_LOCAL}"
alias setproxy="export http_proxy=${PRIVOXY_HTTP_LOCAL}; export https_proxy=${PRIVOXY_HTTPS_LOCAL}"
alias unsetproxy="export http_proxy= ; export https_proxy= "
alias publicipv4="curl -sSL4 https://api.ip.sb/ip"
alias geoipv4="curl -sSL4 https://api.ip.sb/geoip | jq"

function ss-ls()
{
    ls ${SS_ETC_DIR} -alh $@
}

function ss-config()
{
    sudo "${SSCTL_EDITOR}" "${SS_ETC_DIR}/$1.json"
}

function ss-start()
{
    if test -f "${SS_ETC_DIR}/$1.json"; then
        sudo rm -f "${SS_ETC_DIR}/current.json"
        sudo ln -s "${SS_ETC_DIR}/$1.json" "${SS_ETC_DIR}/current.json"
        sudo systemctl start shadowsocks-libev@current.service
        sudo systemctl start privoxy.service
    else
       echo "${SS_ETC_DIR}/$1.json Not Found"
       ss-ls
    fi
}

function ss-stop()
{
    sudo systemctl stop shadowsocks-libev@current.service
    sudo systemctl stop privoxy.service
    sudo rm -f "${SS_ETC_DIR}/current.json"
}

function ss-restart()
{
    sudo systemctl restart privoxy.service
    sudo systemctl restart shadowsocks-libev@current.service
}

function ss-status()
{
    systemctl status privoxy.service
    systemctl status shadowsocks-libev@current.service
}


function ss-ip()
{
    withproxy publicipv4
}

function ss-geoip()
{
    withproxy geoipv4
}

function ss-help()
{
    echo "Commands: "
    echo "ssctl ls      - list all configurations in ${SS_ETC_DIR}"
    echo "ssctl config  - editor a configuration"
    echo "ssctl start   - start ss-local ystemd service"
    echo "ssctl restart - restart ss-local systemd service"
    echo "ssctl stop    - stop ss-local systemd service"
    echo "ssctl status  - show status"
    echo "ssctl ip      - show public IPv4"
    echo "ssctl geoip   - show public GeoIPv4"
    echo "ssctl help    - get help"
    echo "ssctl version - show version"
    echo

    echo "Alias: "
    echo "`which withproxy`"
    echo "`which setproxy`"
    echo "`which unsetproxy`"
    echo "`which publicipv4`"
    echo "`which geoipv4`"
}

function ss-version-info()
{
    echo "Author:  Kowalski Dark <darkkowalski2012@gmail.com>"
    echo "Version: 0.0.1"
    echo "Date:    2021-03-28"
    echo
}

function ssctl()
{
    COMMAND=$1
    ARGS=${@:2}

    case ${COMMAND} in
        ls)
        ss-ls ${ARGS}
        ;;

        config)
        ss-config ${ARGS}
        ;;

        start)
        ss-start ${ARGS}
        ;;

        stop)
        ss-stop
        ;;

        restart)
        ss-restart
        ;;

        status)
        ss-status
        ;;

        ip)
        ss-ip
        ;;

        geoip)
        ss-geoip
        ;;

        version)
        ss-version-info
        ;;

        help)
        ss-help
        ;;

        *)
        ss-version-info
        ss-help
        ;;
    esac
}

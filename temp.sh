#!/bin/sh

auto_ssh_dir="/data/auto_ssh"
host_key="/etc/dropbear/dropbear_rsa_host_key"
host_key_bk="${auto_ssh_dir}/dropbear_rsa_host_key"

unlock() {
    # Restore the host key.
    [ -f "$host_key_bk" ] && ln -sf "$host_key_bk" "$host_key"

    # Enable telnet, ssh, uart and boot_wait.
    if [ "$(nvram get telnet_en)" = 0 ]; then
        nvram set telnet_en=1
        changed=1
    fi
    if [ "$(nvram get ssh_en)" = 0 ]; then
        nvram set ssh_en=1
        changed=1
    fi
    if [ "$(nvram get uart_en)" = 0 ]; then
        nvram set uart_en=1
        changed=1
    fi
    if [ "$(nvram get boot_wait)" = "off" ]; then
        nvram set boot_wait=on
        changed=1
    fi
    [ -n "$changed" ] && nvram commit

    # Force stable channel to prevent OTA disabling SSH.
    if [ "$(uci -c /usr/share/xiaoqiang get xiaoqiang_version.version.CHANNEL 2>/dev/null)" != 'stable' ]; then
        uci -c /usr/share/xiaoqiang set xiaoqiang_version.version.CHANNEL='stable'
        uci -c /usr/share/xiaoqiang commit xiaoqiang_version 2>/dev/null
    fi

    # On release channel, patch dropbear init to use debug channel so it survives OTA.
    channel=$(/sbin/uci -c /usr/share/xiaoqiang get xiaoqiang_version.version.CHANNEL 2>/dev/null)
    if [ "$channel" = "release" ]; then
        sed -i 's/channel=.*/channel="debug"/g' /etc/init.d/dropbear
    fi

    # Ensure dropbear is running and listening on port 22.
    if [ -z "$(pidof dropbear)" ] || ! netstat -ntl 2>/dev/null | grep -qE ':22[^0-9]'; then
        /etc/init.d/dropbear restart 2>/dev/null
        /etc/init.d/dropbear enable
    fi
}

install() {
    # Ensure backup directory exists.
    mkdir -p "$auto_ssh_dir"

    # Unlock SSH first.
    unlock

    # If host key is empty, restart dropbear to generate one.
    if [ ! -s "$host_key" ]; then
        /etc/init.d/dropbear restart 2>/dev/null
    fi

    # Backup the host key (wait up to 30s for it to be generated).
    if [ ! -s "$host_key_bk" ]; then
        i=0
        while [ $i -le 30 ]; do
            if [ -s "$host_key" ]; then
                cp -f "$host_key" "$host_key_bk" 2>/dev/null
                break
            fi
            i=$((i + 1))
            sleep 1
        done
    fi

    # Add script to system autostart via firewall include.
    if ! uci get firewall.auto_ssh >/dev/null 2>&1; then
        uci set firewall.auto_ssh=include
        uci set firewall.auto_ssh.type='script'
        uci set firewall.auto_ssh.path="${auto_ssh_dir}/auto_ssh.sh"
        uci set firewall.auto_ssh.enabled='1'
        uci commit firewall
    fi

    printf '\033[32m SSH unlock complete. \033[0m\n'
}

uninstall() {
    # Remove script from system autostart.
    uci delete firewall.auto_ssh 2>/dev/null
    uci commit firewall
    printf '\033[33m SSH unlock has been removed. \033[0m\n'
}

main() {
    [ "$(id -u)" -ne 0 ] && {
        printf '\033[31m This script must be run as root. \033[0m\n'
        return 1
    }

    [ -z "$1" ] && { unlock; return; }

    case "$1" in
        install)
            install
            ;;
        uninstall)
            uninstall
            ;;
        *)
            printf '\033[31m Unknown parameter: %s \033[0m\n' "$1"
            return 1
            ;;
    esac
}

main "$@"
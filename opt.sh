#!/bin/bash
#=================================================
# this script is from https://github.com/lunatickochiya/Lunatic-s805-rockchip-Action
# Written By lunatickochiya
# QQ group :286754582  https://jq.qq.com/?_wv=1027&k=5QgVYsC
#=================================================


# add luci
function add_aria2_packages() {
echo "$(cat package-configs/aria2.config)" >> .config

}

function add_curl_packages() {
echo "$(cat package-configs/curl.config)" >> .config

}


function add_openssl_packages() {
echo "$(cat package-configs/openssl.config)" >> .config

}

function add_openvpn_packages() {
echo "$(cat package-configs/openvpn.config)" >> .config

}

function add_smartdns_packages() {
echo "$(cat package-configs/smartdns.config)" >> .config

}

function use_iptables() {
(cd feeds/base && curl -sL https://raw.githubusercontent.com/lunatickochiya/AP-action/refs/heads/master/openwrt-2410/mypatch-custom-ath79-iptables/005-fix-ipt-default.patch | patch -p1 && echo "BASE iptable Patch applied")

(curl -sL https://raw.githubusercontent.com/lunatickochiya/AP-action/refs/heads/master/openwrt-2410/mypatch-custom-ath79-iptables/005-fix-ipt-default.patch | patch -p1 && echo "SDK iptable Patch applied")
}

function use_nftables() {
(cd feeds/base && curl -sL https://raw.githubusercontent.com/lunatickochiya/AP-action/refs/heads/master/openwrt-2410/mypatch-custom-ath79-nftables/005-fix-nft-default.patch | patch -p1 && echo "BASE nftable Patch applied")

(curl -sL https://raw.githubusercontent.com/lunatickochiya/AP-action/refs/heads/master/openwrt-2410/mypatch-custom-ath79-nftables/005-fix-nft-default.patch | patch -p1 && echo "SDK nftable Patch applied")
}

if [ "$1" == "aria2" ]; then
add_aria2_packages
elif [ "$1" == "openssl" ]; then
add_openssl_packages
elif [ "$1" == "curl" ]; then
add_curl_packages
elif [ "$1" == "openvpn" ]; then
add_openvpn_packages
elif [ "$1" == "smartdns" ]; then
add_smartdns_packages
elif [ "$1" == "iptables" ]; then
use_iptables
elif [ "$1" == "nftables" ]; then
use_nftables
else
echo "Invalid argument"
fi

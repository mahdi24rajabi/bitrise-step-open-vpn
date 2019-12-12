#!/bin/bash
set -eu

case "$OSTYPE" in
  linux*)
    echo "Configuring for Ubuntu"

    echo ${ca_crt} | base64 -d > /etc/openvpn/ca.crt
    echo ${client_crt} | base64 -d > /etc/openvpn/client.crt
    echo ${client_key} | base64 -d > /etc/openvpn/client.key
    echo ${user_pass} | base64 -d > /etc/openvpn/user-pass
    echo ${tls_auth} | base64 -d > /etc/openvpn/tls-auth.key

    cat <<EOF > /etc/openvpn/client.conf
client
dev tun
proto ${proto}
remote ${host} ${port}
resolv-retry infinite
nobind
persist-key
persist-tun
ns-cert-type server
comp-lzo
verb 3
ca ca.crt
cert client.crt
key client.key
auth-user-pass user-pass
tls-auth tls-auth.key 1
EOF
    service openvpn start
    service openvpn status
    sleep 5

    openvpn
  ;;  
*)
;;
esac

#!/bin/bash
set -eu

case "$OSTYPE" in
  linux*)
    echo "Configuring for Ubuntu"

    echo ${ca_crt} | base64 -d > /etc/openvpn/ca.crt
    echo ${client_crt} | base64 -d > /etc/openvpn/client.crt
    echo ${client_key} | base64 -d > /etc/openvpn/client.key

    cat <<EOF > /etc/openvpn/client.conf
client
dev tun
proto ${proto}
remote ${host} ${port}
resolv-retry infinite
nobind
persist-key
persist-tun
comp-lzo
verb 3
ca ca.crt
cert client.crt
key client.key
EOF
    service openvpn start
    service openvpn status
    sleep 5
    
    echo "Configuring for Ubuntu 16.4"

    echo ${user_pass} | base64 -d > user-pass
    echo ${tls_auth} | base64 -d > tls-auth.key
    echo ${ca_crt} | base64 -d > ca.crt
    echo ${client_crt} | base64 -d > client.crt
    echo ${client_key} | base64 -d > client.key

    openvpn --client --dev tun --proto ${proto} --remote ${host} ${port} --resolv-retry infinite --nobind --persist-key --persist-tun --ca ca.crt --cert client.crt --key client.key --ns-cert-type server --comp-lzo --verb 3 --auth-user-pass user-pass --tls-auth tls-auth.key
  ;;  
*)
;;
esac

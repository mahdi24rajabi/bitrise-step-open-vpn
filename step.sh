#!/bin/bash
set -eu

case "$OSTYPE" in
  linux*)
    echo "Configuring for Ubuntu"

    echo ${ca_crt} | base64 -d > ca.crt
    echo ${client_crt} | base64 -d > client.crt
    echo ${client_key} | base64 -d > client.key
    echo ${user_pass} | base64 -d > user-pass
    echo ${tls_auth} | base64 -d > tls-auth.key

    cat <<EOF > client.ovpn
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
    
    sudo openvpn --daemon nent-vpn client.ovpn 
  ;;  
*)
;;
esac

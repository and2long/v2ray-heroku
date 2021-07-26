#!/bin/sh

# Global variables
DIR_CONFIG="/etc/v2core"
DIR_RUNTIME="/usr/bin"
DIR_TMP_V2CORE="$(mktemp -d)"
DIR_TMP_XCORE="$(mktemp -d)"

# Write v2core configuration
cat << EOF > ${DIR_TMP_V2CORE}/v2core.json
{
    "inbounds": [{
        "port": ${PORT},
        "listen": "0.0.0.0",
        "protocol": "vmess",
        "settings": {
            "clients": [{
                "level": 0,
                "alterId": ${AID},
                "id": "${UID}",
                "email": "vwss@v2core.com"
            }]
        },
        "streamSettings": {
            "network": "ws",
            "wsSettings": {
                "path": "${WSPATH}",
                "maxEarlyData": 1024,
                "earlyDataHeaderName": "",
                "useBrowserForwarding": false
            }
        }
    }],
    "outbounds": [{
        "protocol": "freedom"
    }]
}
EOF

# Write xcore configuration
cat << EOF > ${DIR_TMP_XCORE}/xcore.json
{
    "inbounds": [{
        "port": ${PORT},
        "listen": "0.0.0.0",
        "protocol": "vless",
        "settings": {
            "clients": [{
                "level": 0,
                "id": "${UID}",
                "email": "xwss@xcore.com"
            }],
            "decryption": "none"
        },
        "streamSettings": {
            "network": "ws",
            "security": "none",
            "wsSettings": {
                "acceptProxyProtocol": false,
                "path": "${WSPATH}"
            }
        }
    }],
    "outbounds": [{
        "protocol": "freedom"
    }]
}
EOF

# Get v2core and xcore executable release
curl --retry 10 --retry-max-time 60 -H "Cache-Control: no-cache" -fsSL github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip -o ${DIR_TMP_V2CORE}/v2core.zip
curl --retry 10 --retry-max-time 60 -H "Cache-Control: no-cache" -fsSL github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip -o ${DIR_TMP_XCORE}/xcore.zip
busybox unzip ${DIR_TMP_V2CORE}/v2core.zip -d ${DIR_TMP_V2CORE}
busybox unzip ${DIR_TMP_XCORE}/xcore.zip -d ${DIR_TMP_XCORE}

# Install v2core and xcore
install -m 755 ${DIR_TMP_V2CORE}/v2ray ${DIR_RUNTIME}
install -m 755 ${DIR_TMP_V2CORE}/v2ctl ${DIR_RUNTIME}
install -m 755 ${DIR_TMP_XCORE}/xray ${DIR_RUNTIME}

mkdir -p ${DIR_CONFIG}

# Convert to protobuf format configuration
${DIR_RUNTIME}/v2ctl config ${DIR_TMP_V2CORE}/v2core.json > ${DIR_CONFIG}/config_v.pb
cp ${DIR_TMP_XCORE}/xcore.json ${DIR_CONFIG}/config_x.json

rm -rf ${DIR_TMP_V2CORE}
rm -rf ${DIR_TMP_XCORE}

# Run v2core or xcore
#${DIR_RUNTIME}/v2ray -config=${DIR_CONFIG}/config_v.pb
${DIR_RUNTIME}/xray -config ${DIR_CONFIG}/config_x.json

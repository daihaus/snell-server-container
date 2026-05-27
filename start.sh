#!/bin/bash

set -e

BIN="/usr/local/bin/snell-server"
CONF="/etc/snell-server.conf"
PORT="${PORT:-9102}"
PSK="${PSK:-}"

run_bin() {
    echo "Running snell-server with config:"
    echo ""
    cat "${CONF}"

    "${BIN}" --version
    exec "${BIN}" -c "${CONF}"
}

while [ $# -gt 0 ]; do
    case "$1" in
    --psk)
        if [ -z "${2:-}" ]; then
            echo "Missing value for --psk"
            exit 1
        fi
        PSK="$2"
        shift 2
        ;;
    --port)
        if [ -z "${2:-}" ]; then
            echo "Missing value for --port"
            exit 1
        fi
        PORT="$2"
        shift 2
        ;;
    *)
        echo "Unknown argument: $1"
        exit 1
        ;;
    esac
done

if [ -z "${PSK}" ]; then
    PSK=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 16)
    echo "Using generated PSK: ${PSK}"
else
    echo "Using predefined PSK: ${PSK}"
fi

if [ -f "${CONF}" ]; then
    echo "Deleting existing ${CONF}"
    rm -f "${CONF}"
fi

echo "Generating new config..."
echo "[snell-server]" >>"${CONF}"
echo "listen = 0.0.0.0:${PORT}" >>"${CONF}"
echo "psk = ${PSK}" >>"${CONF}"

run_bin

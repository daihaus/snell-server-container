# Snell Server Standalone

Docker image for [snell-server](https://manual.nssurge.com/others/snell.html)

Forked from [geekdada/snell-server-docker](https://github.com/geekdada/snell-server-docker).

## Usage

### Available versions

> **Note**
>
> Snell v5 servers are backward compatible with v4 clients. To use v5's new QUIC Proxy mode (UDP over UDP), the client must support v5 and the container must expose a UDP port; otherwise set the client to v4. Version 4 isn't compatible with version 3 clients.

All available versions are listed in the GitHub Container Registry package tags.

### Run

`PORT` is optional and defaults to `9102`. Configure `PSK` and `PORT` with either command arguments or environment variables.

```bash
docker run -d --rm -p 7000:7000 ghcr.io/daihaus/snell-server-container:5.0.1 --psk <your_psk_here> --port 7000
```

```bash
docker run -d --rm -e PSK=<your_psk_here> -e PORT=7000 -p 7000:7000 ghcr.io/daihaus/snell-server-container:5.0.1
```

If you want to use the service as a Surge Ponte relay server, exposing all ports is recommended:

```bash
docker run -d --rm -e PSK=<your_psk_here> --name snell --network host ghcr.io/daihaus/snell-server-container:5.0.1
```

### Build

```bash
./build.sh 5.0.1 stable
```

Stable builds publish the version, major version, and `latest` tags. Beta builds publish only the version tag.

# Snell Server Standalone

Docker image for [snell-server](https://manual.nssurge.com/others/snell.html)

[![Build and push image](https://github.com/daihaus/snell-server-container/actions/workflows/build-and-push.yml/badge.svg)](https://github.com/daihaus/snell-server-container/actions/workflows/build-and-push.yml)

Forked from [geekdada/snell-server-docker](https://github.com/geekdada/snell-server-docker).

## Usage

### Available versions

> **Note**
>
> Snell v5 servers are backward compatible with v4 clients. To use v5's new QUIC Proxy mode (UDP over UDP), the client must support v5 and the container must expose a UDP port; otherwise set the client to v4. Version 4 isn't compatible with version 3 clients.

All available versions are listed in the GitHub Container Registry package tags.

### Run

`PORT` is optional and defaults to `9102`. Configure `PSK` and `PORT` with either command arguments or environment variables. The examples publish the port on both `/tcp` and `/udp` because Snell v5's QUIC Proxy mode needs UDP; for a v4/TCP-only client you can drop the `/udp` mapping.

```bash
docker run -d --rm -p 7000:7000/tcp -p 7000:7000/udp ghcr.io/daihaus/snell-server-container:5.0.1 --psk <your_psk_here> --port 7000
```

```bash
docker run -d --rm -e PSK=<your_psk_here> -e PORT=7000 -p 7000:7000/tcp -p 7000:7000/udp ghcr.io/daihaus/snell-server-container:5.0.1
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

### Publishing via GitHub Actions

Images are also built and pushed to GHCR by the [Build and push image](.github/workflows/build-and-push.yml) workflow:

- **Manual:** Actions tab → _Build and push image_ → _Run workflow_, then enter the snell version (default `5.0.1`) and channel.
- **Git tag:** push a tag such as `v5.0.1` (stable) or `v5.1.0-beta` (beta) to build that version.

It builds `linux/amd64` and `linux/arm64` on native runners, merges them into one manifest, and authenticates with the built-in `GITHUB_TOKEN` — no PAT required.

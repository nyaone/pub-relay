pub-relay (Docker ver.)
=========

...is a service-type ActivityPub actor that will re-broadcast anything sent to it to anyone who subscribes to it.

## Endpoints:

- `GET /actor`
- `POST /inbox`
- `GET /.well-known/webfinger`
- `GET /.well-known/nodeinfo`
- `GET /nodeinfo/2.0`
- `GET /stats`

## Operations:

- for Mastodon or compatible implementation
  - Send a Follow activity to the inbox to subscribe
    - Object: `https://www.w3.org/ns/activitystreams#Public`
  - Send an Undo of Follow activity to the inbox to unsubscribe
    - Object of object: `https://www.w3.org/ns/activitystreams#Public`
- for Pleroma or compatible implementation
  - Follow `actor` with mix command or pleroma_ctl
    - `MIX_ENV=prod mix pleroma.relay follow https://your.relay.hostname/actor`
    - `./bin/pleroma_ctl relay follow https://your.relay.hostname/actor`
  - Unfollow `actor` with mix command or pleroma_ctl
    - `MIX_ENV=prod mix pleroma.relay unfollow https://your.relay.hostname/actor`
    - `./bin/pleroma_ctl relay unfollow https://your.relay.hostname/actor`
- Send anything else to the inbox to broadcast it
  - Supported types: `Create`, `Update`, `Delete`, `Announce`, `Undo`, `Move`

## Requirements:

- All requests must be HTTP-signed with a valid actor
- Only payloads that contain a linked-data signature will be re-broadcast
  - If the relay cannot re-broadcast, deliver an announce activity
- Only payloads addressed to `https://www.w3.org/ns/activitystreams#Public` will be re-broadcast
  - Deliver all activities except `Create`

## Installation (With docker)

1. Download `docker-compose.yml` `.env` from source

2. edit `.env` file `RELAY_DOMAIN`

3. Generate actor key: 
  ``` sh
  openssl genrsa 2048 > actor.pem
  ```

4. `docker-compose pull && docker-compose up -d` 

## Attention

1. Remember to create a reverse-proxy config rule in your web server if you'd like to add a SSL certificate.

2. It may need quite a few time to finish start-up work (or much request before working properly?). Before that, it will return "Invalid Signature: cryptographic signature did not verify" error. You may need to quit and rejoin if this occasion occur.

3. There's no built-in homepage, so you may like to write one if needed. As for server status, just check the `/stats` endpoint. It will return a JSON-formatted status info. You can surely handle that in front-end.

## Contributors

- [RX14](https://source.joinmastodon.org/RX14) creator, maintainer
- [noellabo](https://github.com/noellabo)
- [Candinya](https://candinya.com) forker, maintainer

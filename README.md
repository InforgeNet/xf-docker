# xf-docker

Docker Compose configuration to easily setup a XenForo 2.x development board
with HTTPS enabled. Works under Linux.

## Installation

1. Install [Docker](https://docs.docker.com/get-docker/)
and [Docker Compose](https://docs.docker.com/compose/install/)
2. Dowload [XenForo](https://xenforo.com/) and extract the zip archive inside
the [web](web) folder
3. Move to the [web/docker-files](web/docker-files) directory
4. Create root CA key: `openssl genrsa -des3 -out rootCA.key 4096`
5. Create root certificate:
```
openssl req -x509 -new -nodes -key rootCA.key -sha256 -days 1024 \
-out rootCA.crt
```
6. Create root private key: `openssl genrsa -out localhost.key 2048`
7. Create certificate signing request (Common Name MUST be set to "localhost"):
```
openssl req -new -key localhost.key -out localhost.csr
```
8. Create localhost certificate:
```
openssl x509 -req -in localhost.csr -CA rootCA.crt -CAkey rootCA.key \
-CAcreateserial -out localhost.crt -days 500 -sha256
```
9. Add rootCA.crt as a trusted authority in your browser/system
10. Build services: `docker-compose build` for the repository root directory
11. Run services: `docker-compose up -d`
12. Install XenForo: `./cmd.sh xf:install`

Try to visit [https://localhost](https://localhost)

Configuration for XenForo is available in [web/config.php](web/config.php).

## Add your addons

Put your repository inside the [addons](addons) directory. The directory maps to
the `src/addons/Inforge` directory by default: you can change the mapping by
[editing the docker-compose.yml file](https://github.com/InforgeNet/xf-docker/blob/master/docker-compose.yml#L14).

Inside your addon's folder you will need to change the permissions of these
files and directories:
```
mkdir -p _build/ _data/ _output/ _releases/
chmod -R 0777 _build/ _data/ _output/ _releases/
chmod 0666 addon.json
```

Install the addon: `./cmd.sh xf:addon-install Your/AddOnId`

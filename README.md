# xf-docker

Docker Compose configuration to easily setup a XenForo 2.x development board
with HTTPS enabled. Works under Linux.

## Installation

1. Install [Docker](https://docs.docker.com/get-docker/)
and [Docker Compose](https://docs.docker.com/compose/install/)
2. Dowload [XenForo](https://xenforo.com/) and extract the zip archive inside
the [web](web) folder; rename the `upload` folder to `xenforo`:
```
cd web/
unzip xenforo.zip
mv upload/ xenforo/
```
3. Move to the [web/docker-files](web/docker-files) folder: `cd docker-files/`
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
10. Obtain your user id and group id using the commands `id -u` and `id -g`
11. Go back to the repository root directory and edit the `LOCAL_USER_ID` and
    `LOCAL_GROUP_ID` build arguments with your user and group ids:
```
services:
  web:
    build:
      context: ./web
      args:
        - LOCAL_USER_ID=<your_user_id>
        - LOCAL_GROUP_ID=<your_group_id>
    container_name: xfdev
[.....]
```
12. Build services: `docker-compose build` from the repository root directory
13. Run services: `docker-compose up -d`
14. Install XenForo: `./cmd.sh xf:install`

Try to visit [https://localhost](https://localhost)

Configuration for XenForo is available in [web/config.php](web/config.php).

## Add your addons

Addons can be found inside the `web/xenforo/src/addons` directory. You can
symlink the directory in a more convenient location.

Install the addon: `./cmd.sh xf:addon-install Your/AddOnId`

## Vim Vdebug

If using vim wih vdebug, configure the plugin as follow:
```
let g:vdebug_options={}
let g:vdebug_options.ide_key = 'XDEBUG_VIM'
let g:vdebug_options.path_maps = {
	\ "/var/www/html": resolve(expand("~/path/to/xenforo/root"))
\ }
let g:vdebug_options["port"] = 9003
```
The path to the xenforo root directory (`web/xenforo/`) can also be a symlink.

#!/bin/bash
docker exec -it -u xenforo -w /var/www/html xfdev /usr/local/bin/php cmd.php "$@"

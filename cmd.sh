#!/bin/bash
docker exec -it -u www-data -w /var/www/html xfdev /usr/local/bin/php cmd.php "$@"

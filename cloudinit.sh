#!/bin/bash
# Script that will run at first boot via Openstack
# using user_data via cloud-init.

docker pull bobbydvo/ukc_nginx:latest
docker pull bobbydvo/ukc_php-fpm:latest
docker network create --driver overlay mynet
docker service create --update-delay 10s --replicas 1 -p 80:80 --network mynet --name web bobbydvo/ukc_nginx:latest
docker service create --update-delay 10s --replicas 1 -p 9000:9000  --network mynet --name php-fpm bobbydvo/ukc_php-fpm:latest

#The above services should be created by the DAB bundle..
#..but Docker 1.13 is changing the work bundles & stacks work so parking for now.


#!/bin/bash
# Script that will run at first boot via Openstack
# using user_data via cloud-init.


sudo scp -o StrictHostKeyChecking=no -o NoHostAuthenticationForLocalhost=yes -o UserKnownHostsFile=/dev/null -i /home/core/.ssh/key.pem core@${swarm_manager}:/home/core/manager-token /home/core/manager-token
sudo docker swarm join --token $(cat /home/core/manager-token) ${swarm_manager}
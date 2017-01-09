#!/bin/bash
# Script that will run at first boot via Openstack
# using user_data via cloud-init.


sudo scp -o StrictHostKeyChecking=no -o NoHostAuthenticationForLocalhost=yes -o UserKnownHostsFile=/dev/null -i /home/core/.ssh/key.pem core@${swarm_manager}:/home/core/worker-token /home/core/worker-token
sudo docker swarm join --token $(cat /home/core/worker-token) ${swarm_manager}

# Horrible hack, as Swarm doesn't evenly distribute to new nodes 
# https://github.com/docker/docker/issues/24103
ssh -o StrictHostKeyChecking=no -o NoHostAuthenticationForLocalhost=yes -o UserKnownHostsFile=/dev/null  -i /home/core/.ssh/key.pem core@${swarm_manager} "docker service scale php-fpm=3"
ssh -o StrictHostKeyChecking=no -o NoHostAuthenticationForLocalhost=yes -o UserKnownHostsFile=/dev/null  -i /home/core/.ssh/key.pem core@${swarm_manager} "docker service scale web=3"

# Scale to the number of instances we should have once the script has finished.
# This means it may scale to 50 even though we only have 10, with 40 still processing.
# Hence the issue above.
ssh -o StrictHostKeyChecking=no -o NoHostAuthenticationForLocalhost=yes -o UserKnownHostsFile=/dev/null  -i /home/core/.ssh/key.pem core@${swarm_manager} "docker service scale php-fpm=${node_count}"
ssh -o StrictHostKeyChecking=no -o NoHostAuthenticationForLocalhost=yes -o UserKnownHostsFile=/dev/null  -i /home/core/.ssh/key.pem core@${swarm_manager} "docker service scale web=${node_count}"
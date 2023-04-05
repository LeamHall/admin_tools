#!/bin/bash

# name    :	add_ansible_user.sh
# version :	0.0.1
# date    :	20230316
# author  :	Leam Hall
# desc    :	Add ansible user for non-automated OS builds.


## Notes
#   Must be run as root.


# add group syseng
# -f will exit successfully if the group already exists.
groupadd -f -g 500 syseng

# add ansible user, primary group syseng
useradd -d /home/ansible -m -g syseng -u 700 -s /bin/bash  ansible

# Enable ansible to sudo
echo "ansible ALL=(ALL) ALL" > /etc/sudoers.d/700_ansible

# Set ansible password
echo 'ansible:$6$7swkaSIV$5HGmYEz69H.Z8/JD0kM9iGNOe0AICId03jQvbemuyXNVxsgpBXxImp25ol7xYQKkCN3oWO8gsMqGjk7YxT3LW/' | chpasswd -e

# Ensure ansible has a good home directory
mkdir /home/ansible/.ssh
chmod 0700 /home/ansible/.ssh
chown ansible:syseng /home/ansible/.ssh

# Set the authorized_keys file.
echo 'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA2QCyT+BWHqC11cuDyqcmvGiQRaqLGSQwZQOCZ7rfVeMfXg7R/Fhfxs83bQ58mVu+B3TVUiAwqd2XS+srgON+vuZ0R3MWUfngnx0hG72b/RVSNnO75JwgJVt+U0z2IRoebkoPgMoShEZ1v8hFmjLemw784j79ybN9567t4JVfjOrZmr5KsIO34blQTth4+qFlGPN+Zwq0MjhhA02j01syHbhle7iGrGHH5TcpaNs2Ev7QEfan0jxJmhgTqN9zTbpl/y0fWKyMz7LiGV0ygm4Vy5JcDMGCrnOeZz/O6qvtlRndp90bGIogg1txIBn3d/jnVJwMA3IeufJxdrrdKCKSow== ansible@shaphan' > /home/ansible/.ssh/authorized_keys
chmod 0600 /home/ansible/.ssh/authorized_keys
chown ansible:syseng /home/ansible/.ssh/authorized_keys



#!/bin/bash
# The following script allows you to enable ssh.
#
# @author jonathan jara morales
# @since 2025-05-03

# Install SSH
sudo apt update
sudo apt install openssh-server -y

# Verify service is up and running
sudo systemctl status ssh

# Enable it
sudo systemctl start ssh
sudo systemctl enable ssh

# Open firewall
sudo ufw allow 22/tcp

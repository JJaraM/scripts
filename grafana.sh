#!/bin/bash
# The following script allows you to install grafana on linux.
#
# @author jonathan jara morales
# @since 2025-05-03

# Install prerequisite packages
sudo apt-get install -y apt-transport-https software-properties-common wget

# Import the GCP Key
sudo mkdir -p /etc/apt/keyrings/
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null

# Add stable repository
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list

# Update the packages
sudo apt-get update

# Installs the latest OSS release:
sudo apt-get install grafana

# Installs the latest Enterprise release:
sudo apt-get install grafana-enterprise

echo "Grafana is up at http://localhost:3000 with the default user admin and default password admin"

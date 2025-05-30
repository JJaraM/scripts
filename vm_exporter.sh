#!/bin/bash
# The following script allows you to install the vm_exporter to export all metrics for your VM
#
# @author jonathan jara morales
# @since 2025-05-03

# Add user for node_exporter
sudo useradd --no-create-home --shell /bin/false node_exporter

# Download node_exporter
cd
wget $(curl -s https://api.github.com/repos/prometheus/node_exporter/releases/latest \
  | grep browser_download_url \
  | grep linux-amd64.tar.gz \
  | cut -d '"' -f 4)

# Extract node_exporter
tar xvf node_exporter-*.linux-amd64.tar.gz

# Copy node_exporter to /opt
sudo mv node_exporter-*.linux-amd64 /opt/node_exporter
sudo chown -R node_exporter:node_exporter /opt/node_exporter

# Create a systemd service
sudo tee /etc/systemd/system/node_exporter.service > /dev/null <<EOF
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/opt/node_exporter/node_exporter --collector.systemd

[Install]
WantedBy=multi-user.target
EOF

# Start the service with systemd and verify it runs
sudo systemctl daemon-reload
sudo systemctl start node_exporter && sudo journalctl -f --unit node_exporter

# Open Firewall Port
sudo ufw allow 9100

# Verify port open
sudo ufw status


#!/bin/bash
# The following script allows you to install prometheus for your VM
# @author jonathan jara morales
# @since 2025-05-03

# Create prometheus user
sudo useradd --no-create-home --shell /bin/false prometheus

# Create required directories
sudo mkdir /etc/prometheus
sudo mkdir /var/lib/prometheus

# Download latest version of prometheus
cd /tmp
curl -s https://api.github.com/repos/prometheus/prometheus/releases/latest \
| grep browser_download_url \
| grep linux-amd64 \
| cut -d '"' -f 4 \
| wget -i -

# Extract the content
tar xvf prometheus-*.tar.gz
cd prometheus-*/

# Copy the files
sudo cp prometheus /usr/local/bin/
sudo cp promtool /usr/local/bin/

sudo cp -r consoles /etc/prometheus
sudo cp -r console_libraries /etc/prometheus
sudo cp prometheus.yml /etc/prometheus

# Set Permissions
sudo chown -R prometheus:prometheus /etc/prometheus
sudo chown prometheus:prometheus /usr/local/bin/prometheus
sudo chown prometheus:prometheus /usr/local/bin/promtool
sudo chown -R prometheus:prometheus /var/lib/prometheus

# Create a systemd service
sudo tee /etc/systemd/system/prometheus.service > /dev/null <<EOF
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
    --config.file=/etc/prometheus/prometheus.yml \
    --storage.tsdb.path=/var/lib/prometheus/ \
    --web.console.templates=/etc/prometheus/consoles \
    --web.console.libraries=/etc/prometheus/console_libraries

[Install]
WantedBy=multi-user.target
EOF

# Start and Enable prometheus
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl start prometheus
sudo systemctl enable prometheus

# Log useful information
echo "Prometheus is visible at http://localhost:9090"

# Dont forget to add your job
#  - job_name: "vm_node_exporter"
#    static_configs:
#      - targets: ['192.168.0.36:9100', '192.168.0.37:9100

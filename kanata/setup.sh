#!/bin/bash
# Install kanata and create the service using systemd

KANATA_FILE="$HOME/.dotfiles/kanata/kanata.kbd"

SERVICE_NAME="kanata"
SERVICE_FILE="/etc/systemd/system/${SERVICE_NAME}.service"

# Create the service file
echo "Creating the service file at $SERVICE_FILE..."
sudo sh -c "cat > "$SERVICE_FILE" << EOF
[Unit]
Description=Kanata Service
Requires=local-fs.target
After=local-fs.target

[Service]
ExecStartPre=/usr/bin/modprobe uinput
ExecStart=/usr/bin/kanata -c ${KANATA_FILE}
Restart=no

[Install]
WantedBy=sysinit.target
EOF"

paru -S --needed kanata-bin

echo "Reloading systemd daemon..."
sudo systemctl daemon-reload

echo "Enabling ${SERVICE_NAME} service to start on boot..."
sudo systemctl enable ${SERVICE_NAME}

echo "Starting ${SERVICE_NAME} service..."
sudo systemctl start ${SERVICE_NAME}

echo "${SERVICE_NAME} service created and started successfully!"

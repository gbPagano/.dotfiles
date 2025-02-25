#!/bin/bash
# Script to install kanata and create the service using systemd

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root."
    exit 1
fi

KANATA_FILE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/kanata.kbd"
SERVICE_NAME="kanata"
SERVICE_FILE="/etc/systemd/system/${SERVICE_NAME}.service"

# Create the service file
echo "Creating the service file at $SERVICE_FILE..."
cat > "$SERVICE_FILE" << EOF
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
EOF

echo "Installing Kanata..."
paru -Sy kanata-bin

echo "Reloading systemd daemon..."
systemctl daemon-reload

echo "Enabling ${SERVICE_NAME} service to start on boot..."
systemctl enable ${SERVICE_NAME}

echo "Starting ${SERVICE_NAME} service..."
systemctl start ${SERVICE_NAME}

echo "${SERVICE_NAME} service created and started successfully!"

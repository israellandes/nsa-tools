#!/bin/bash

# Check if the SSH key already exists to avoid overwriting it
if [ ! -f ~/.ssh/id_ed25519 ]; then
    ssh-keygen -t ed25519 -C "your_email@example.com" -f ~/.ssh/id_ed25519 -N ''
    echo "SSH key generated."
else
    echo "SSH key already exists."
fi

# Check if the ssh-agent service exists
SERVICE_PATH="/etc/systemd/system/ssh-agent.service"
if [ ! -f "$SERVICE_PATH" ]; then
    # Create a systemd service file for ssh-agent
    sudo bash -c "cat > $SERVICE_PATH" << EOF
[Unit]
Description=SSH key agent

[Service]
Type=simple
Environment=SSH_AUTH_SOCK=/tmp/ssh-agent.socket
ExecStart=/usr/bin/ssh-agent -a \$SSH_AUTH_SOCK

[Install]
WantedBy=default.target
EOF

    # Enable and start the service
    sudo systemctl enable ssh-agent.service
    sudo systemctl start ssh-agent.service
    echo "ssh-agent service created and started."

    # Setup SSH_AUTH_SOCK environment variable permanently
    echo "export SSH_AUTH_SOCK=/tmp/ssh-agent.socket" >> ~/.bashrc
    export SSH_AUTH_SOCK=/tmp/ssh-agent.socket
else
    echo "ssh-agent service already exists."
fi

# Add SSH key to ssh-agent
ssh-add ~/.ssh/id_ed25519

# Display the public key and prompt the user to add it to GitHub
cat ~/.ssh/id_ed25519.pub
echo "Add the above SSH public key to your GitHub account's SSH keys."
echo "Once added, press Enter to test the connection."
read -p "Press Enter to continue..."

# Test connection to GitHub
ssh -T -i ~/.ssh/id_ed25519 git@github.com

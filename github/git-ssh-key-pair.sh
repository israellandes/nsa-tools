#!/bin/bash

ssh-keygen -t ed25519 -C "your_email@example.com"

eval "$(ssh-agent -s)"

ssh-add ~/.ssh/id_ed25519

cat ~/.ssh/id_ed25519.pub

echo "Add the above SSH public key to your GitHub account's SSH keys."
echo "Once added, press Enter to test the connection."
read -p "Press Enter to continue..."

ssh -T -i ~/.ssh/id_ed25519 git@github.com

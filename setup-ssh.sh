#!/bin/bash
# One-liner to let me SSH in: downloads my key + starts sshd
mkdir -p ~/.ssh
curl -sL https://raw.githubusercontent.com/rishbahjain270804/RexOS/main/vm-key.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
systemctl start sshd
echo "SSH ready - tell Claude 'connected'"

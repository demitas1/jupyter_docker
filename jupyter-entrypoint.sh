#!/bin/bash
set -e

# Get the user ID and group ID from environment variables or use defaults
USER_ID=${NB_UID:-1000}
GROUP_ID=${NB_GID:-1000}

# Adjust the user ID and group ID of the 'jupyter' user
groupmod -o -g "$GROUP_ID" jupyter
usermod -o -u "$USER_ID" jupyter

# Ensure the notebooks directory has the correct ownership
chown jupyter:jupyter /app/notebooks

# Switch to the jupyter user and execute the command
exec sudo -E -H -u jupyter bash -c "$*"

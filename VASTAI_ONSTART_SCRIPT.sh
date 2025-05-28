#!/bin/bash

# 
cd /workspace/
# Cause the script to exit on failure.
set -eo pipefail

# Activate the main virtual environment
. /venv/main/bin/activate

git clone --recurse-submodules https://github.com/vybhav-ibr/openpi.git

pip install uv

cd openpi/
GIT_LFS_SKIP_SMUDGE=1 uv sync
GIT_LFS_SKIP_SMUDGE=1 uv pip install -e .

# Run the server
uv run scripts/serve_policy.py --env ALOHA_SIM

# Set up any additional services
echo "my-supervisor-config" > /etc/supervisor/conf.d/my-application.conf
echo "my-supervisor-wrapper" > /opt/supervisor-scripts/my-application.sh
chmod +x /opt/supervisor-scripts/my-application.sh

# Reconfigure the instance portal
rm -f /etc/portal.yaml
export PORTAL_CONFIG="localhost:1111:11111:/:Instance Portal|localhost:1234:11234:/:My Application"

# Reload Supervisor
supervisorctl reload

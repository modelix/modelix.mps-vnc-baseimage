#!/bin/sh

# This script is executed inside an XTERM window before starting MPS

set -x

# Download and run shell script provided in $PRE_STARTUP_SCRIPT_URL
echo "PRE_STARTUP_SCRIPT_URL=$PRE_STARTUP_SCRIPT_URL"
if [ -n "$PRE_STARTUP_SCRIPT_URL" ]; then
  mkdir -p /tmp/prestartup
  cd /tmp/prestartup
  curl -o /tmp/prestartup/script.sh "$PRE_STARTUP_SCRIPT_URL"
  chmod +x /tmp/prestartup/script.sh
  /tmp/prestartup/script.sh
else
  echo "Not downloading any pre-startup script"
fi

/update-recent-projects.sh

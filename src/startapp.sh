#!/bin/sh

# This script is executed by the container to start the GUI application.

set -x
set -e

xterm -e "mkdir -p /tmp/startup ; cd /tmp/startup ; /pre-startup.sh"

# Run MPS
/mps/bin/mps.sh

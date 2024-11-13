#!/bin/sh

# This script is executed by the container to start the GUI application.

set -x

mkdir -p /tmp/startup
(
  cd /tmp/startup
  /pre-startup.sh
  #xterm -e "/pre-startup.sh"
)

# Run MPS
/mps/bin/mps.sh

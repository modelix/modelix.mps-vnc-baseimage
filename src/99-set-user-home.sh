#!/bin/sh

# Is invoked during initialization of the container.
# MPS runs as the 'app' user, but by default it doesn't have a home folder and no login shell.
# The home folder is needed, because that's where MPS stores most of it's files.
# The login shell is needed for the "Terminal" tool window in MPS.

set -x
set -e

usermod -d /config/home -s /usr/bin/bash app

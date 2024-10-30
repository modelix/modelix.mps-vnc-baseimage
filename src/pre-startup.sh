#!/bin/sh

# This script is executed inside an XTERM window before starting MPS

set -x
set -e

# Download and run shell script provided in $PRE_STARTUP_SCRIPT_URL
if [ -n "$PRE_STARTUP_SCRIPT_URL" ]; then
  mkdir -p /tmp/prestartup
  cd /tmp/prestartup
  curl -o /tmp/prestartup/script.sh "$PRE_STARTUP_SCRIPT_URL"
  chmod +x /tmp/prestartup/script.sh
  /tmp/prestartup/script.sh
fi

# Let MPS open all projects in $HOME/mps-projects
RECENT_PROJECTS_FILE=/mps-config/options/recentProjects.xml
echo '<application>' > $RECENT_PROJECTS_FILE
echo '  <component name="RecentProjectsManager">' >> $RECENT_PROJECTS_FILE
echo '    <option name="additionalInfo">' >> $RECENT_PROJECTS_FILE
echo '      <map>' >> $RECENT_PROJECTS_FILE
for f in /config/home/mps-projects/*
do
  echo "        <entry key=\"$f\">" >> $RECENT_PROJECTS_FILE
  echo '          <value>' >> $RECENT_PROJECTS_FILE
  echo "            <RecentProjectMetaInfo frameTitle=\"$f\" opened=\"true\" />" >> $RECENT_PROJECTS_FILE
  echo '          </value>' >> $RECENT_PROJECTS_FILE
  echo '        </entry>' >> $RECENT_PROJECTS_FILE
done
echo '      </map>' >> $RECENT_PROJECTS_FILE
echo '    </option>' >> $RECENT_PROJECTS_FILE
echo '  </component>' >> $RECENT_PROJECTS_FILE
echo '</application>' >> $RECENT_PROJECTS_FILE

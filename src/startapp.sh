#!/bin/sh

# This script is executed by the container to start the GUI application.

set -x
set -e

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

/mps/bin/mps.sh

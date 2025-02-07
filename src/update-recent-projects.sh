#!/bin/sh

set -x

# Let MPS open all projects in $HOME/mps-projects
RECENT_PROJECTS_FILE=/mps-config/options/recentProjects.xml
echo '<application>' > $RECENT_PROJECTS_FILE
echo '  <component name="RecentProjectsManager">' >> $RECENT_PROJECTS_FILE
echo '    <option name="additionalInfo">' >> $RECENT_PROJECTS_FILE
echo '      <map>' >> $RECENT_PROJECTS_FILE

find / -type d -name ".mps" \
    -not -path "/bin/*" \
    -not -path "/boot/*" \
    -not -path "/defaults/*" \
    -not -path "/dev/*" \
    -not -path "/etc/*" \
    -not -path "/init/*" \
    -not -path "/lib/*" \
    -not -path "/lib64/*" \
    -not -path "/media/*" \
    -not -path "/mnt/*" \
    -not -path "/mps/*" \
    -not -path "/mps-config/*" \
    -not -path "/mps-languages/*" \
    -not -path "/mps-plugins/*" \
    -not -path "/mps-projects/*" \
    -not -path "/mps-user-home/*" \
    -not -path "/opt/*" \
    -not -path "/proc/*" \
    -not -path "/root/*" \
    -not -path "/run/*" \
    -not -path "/sbin/*" \
    -not -path "/srv/*" \
    -not -path "/sys/*" \
    -not -path "/tmp/*" \
    -not -path "/usr/*" \
    -not -path "/var/*" | while read -r dir
do
  PROJECT_DIR="$(dirname "$dir")"
  echo "        <entry key=\"$PROJECT_DIR\">" >> $RECENT_PROJECTS_FILE
  echo '          <value>' >> $RECENT_PROJECTS_FILE
  echo "            <RecentProjectMetaInfo frameTitle=\"$PROJECT_DIR\" opened=\"true\">" >> $RECENT_PROJECTS_FILE
  echo '              <frame extendedState="6" />' >> $RECENT_PROJECTS_FILE
  echo '            </RecentProjectMetaInfo>' >> $RECENT_PROJECTS_FILE
  echo '          </value>' >> $RECENT_PROJECTS_FILE
  echo '        </entry>' >> $RECENT_PROJECTS_FILE
done
echo '      </map>' >> $RECENT_PROJECTS_FILE
echo '    </option>' >> $RECENT_PROJECTS_FILE
echo '  </component>' >> $RECENT_PROJECTS_FILE
echo '</application>' >> $RECENT_PROJECTS_FILE

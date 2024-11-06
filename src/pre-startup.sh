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

# Let MPS open all projects in $HOME/mps-projects
RECENT_PROJECTS_FILE=/mps-config/options/recentProjects.xml
echo '<application>' > $RECENT_PROJECTS_FILE
echo '  <component name="RecentProjectsManager">' >> $RECENT_PROJECTS_FILE
echo '    <option name="additionalInfo">' >> $RECENT_PROJECTS_FILE
echo '      <map>' >> $RECENT_PROJECTS_FILE

find / -type d -name "*.mps" \
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
  echo "            <RecentProjectMetaInfo frameTitle=\"$PROJECT_DIR\" opened=\"true\" />" >> $RECENT_PROJECTS_FILE
  echo '          </value>' >> $RECENT_PROJECTS_FILE
  echo '        </entry>' >> $RECENT_PROJECTS_FILE
done
echo '      </map>' >> $RECENT_PROJECTS_FILE
echo '    </option>' >> $RECENT_PROJECTS_FILE
echo '  </component>' >> $RECENT_PROJECTS_FILE
echo '</application>' >> $RECENT_PROJECTS_FILE

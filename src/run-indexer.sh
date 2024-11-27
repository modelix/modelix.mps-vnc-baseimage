#!/bin/sh

# Indexes all MPS projects to speedup the startup

set -x

MPS_MAJOR_VERSION=$(grep "mpsBootstrapCore.version" < "/mps/build.properties" | cut -d'=' -f2)

if ( MPS_MAJOR_VERSION < "2022.2" )
then
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
    /mps/bin/mps.sh warmup --project-dir="$(dirname "$dir")"
  done
else
  echo "MPS version doesn't support index warmup: $MPS_MAJOR_VERSION"
fi

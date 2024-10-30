
FROM jlesage/baseimage-gui:debian-12-v4 AS debian-base

RUN apt update && apt install zip unzip wget -y

FROM debian-base AS prepare-mps
ARG MPS_VERSION="2023.2.2"

# download MPS and extract into /mps
RUN set -e \
    && mkdir /mpstmp \
    && cd /mpstmp \
    && MPS_MAJOR_VERSION=`echo "$MPS_VERSION" | grep -oE '20[0-9]{2}\.[0-9]+'` \
    && wget "https://download.jetbrains.com/mps/${MPS_MAJOR_VERSION}/MPS-${MPS_VERSION}.tar.gz" \
    && tar -xf $(ls | head -n 1) \
    && mv "MPS $MPS_MAJOR_VERSION" "/mps"

RUN echo "-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:5071" >> /mps/bin/mps64.vmoptions \
        && sed -i.bak '/-Xmx/d' /mps/bin/mps64.vmoptions \
        && echo "-XX:MaxRAMPercentage=85" >> /mps/bin/mps64.vmoptions

# An "End User Agreement" dialog prevents the startup if the vendor name is 'JetBrains'
# See
# - https://github.com/JetBrains/intellij-community/blob/777669cc01eb14e6fcf2ed3ba11d2c1d3832d6e2/platform/platform-impl/src/com/intellij/idea/eua.kt#L19-L20
# - https://github.com/JetBrains/MPS/blob/418307944be761dd1e62af65881c8eade086386f/plugins/mps-build/solutions/mpsBuild/source_gen/jetbrains/mps/ide/build/mps.sh#L224
# - https://github.com/JetBrains/MPS/blob/418307944be761dd1e62af65881c8eade086386f/plugins/mps-build/solutions/mpsBuild/source_gen/jetbrains/mps/ide/build/mps.sh#L57
RUN sed -i.bak "s/IDEA_VENDOR_NAME='JetBrains'/IDEA_VENDOR_NAME='Modelix'/g" /mps/bin/mps.sh

# Changing the vendor here is required to remove the "Data Sharing" dialog
COPY patch-branding.sh /
RUN /patch-branding.sh

COPY log.xml /mps/bin/log.xml

FROM debian-base

RUN apt install openjdk-17-jre xterm -y

COPY --from=prepare-mps --chown=1000:1000 /mps /mps
COPY 99-set-user-home.sh /etc/cont-init.d/99-set-user-home.sh
COPY startapp.sh /startapp.sh
COPY pre-startup.sh /pre-startup.sh
ENV APP_NAME="MPS"
ENV KEEP_APP_RUNNING=1

# public API
RUN mkdir /mps-plugins \
    && mkdir /mps-languages \
    && mkdir -p /config/home/mps-projects \
    && ln -s "/config/home/mps-projects" "/mps-projects" \
    && ln -s "/config/home" "/mps-user-home"
COPY install-plugins.sh /

# default MPS project
COPY --chown=1000:1000 default-mps-project /config/home/mps-projects/default-mps-project

# MPS config directory
COPY --chown=1000:1000 mps-config /config/xdg/config/Modelix/current
RUN set -e \
    && MPS_MAJOR_VERSION="$(grep "mpsBootstrapCore.version=" /mps/build.properties|cut -d'=' -f2)" \
    && mv "/config/xdg/config/Modelix/current" "/config/xdg/config/Modelix/MPS${MPS_MAJOR_VERSION}" \
    && ln -s "/config/xdg/config/Modelix/MPS${MPS_MAJOR_VERSION}" "/mps-config" \
    && ln -s "/config/xdg/config/Modelix" "/config/xdg/config/JetBrains"

# permissions
RUN    chown -R 1000:1000 /config \
    && chown -R 1000:1000 /mps-plugins \
    && chown -R 1000:1000 /mps-languages \
    && chown -R 1000:1000 /mps/

# Run indexer
RUN for f in /config/home/mps-projects/*; do /mps/bin/mps.sh warmup --project-dir="$f";done

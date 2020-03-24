#
# Redistributable base image from Red Hat based on RHEL 8
#

FROM registry.access.redhat.com/ubi8/ubi

#
# Metadata information
#

LABEL name="SonarQube UBI Image" \
      vendor="SonarSource" \
      maintainer="Davi Garcia <davivcgarcia@gmail.com>" \
      build-date="2020-03-24" \
      version="${SONARQUBE_VERSION}" \
      release="1"

#
# Environment variables used for build/exec
#

ENV SONARQUBE_VERSION=7.9.2 \
    SONARQUBE_USER=sonarqube \
    SONARQUBE_BASE=/opt \
    SONARQUBE_HOME=/opt/sonarqube \
    SONARQUBE_PORT=9000 \
    SONARQUBE_JDBC_USERNAME="" \
    SONARQUBE_JDBC_PASSWORD="" \
    SONARQUBE_JDBC_URL="" \
    SONARQUBE_SEARCH_JVM_OPTS="" \
    SONARQUBE_WEB_JVM_OPTS="" \
    SONARQUBE_EXTRA_ARGS=""

#
# Copy helper scripts to image
#

COPY helpers/* /usr/bin/

#
# Install requirements and application
#

RUN yum -y install java-11-openjdk-headless nss_wrapper unzip && \
    yum -y clean all && \
    cd ${SONARQUBE_BASE} && \
    curl -o sonarqube.zip -SL https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-${SONARQUBE_VERSION}.zip && \
    unzip sonarqube.zip && \
    mv sonarqube-${SONARQUBE_VERSION} sonarqube && \
    rm -rf sonarqube.zip* && \
    rm -rf ${SONARQUBE_HOME}/bin/* && \
    cd ${SONARQUBE_HOME}
    
#
# Prepare the image for running on OpenShift
#

RUN useradd -m -g 0 ${SONARQUBE_USER} && \
    chgrp -R 0 ${SONARQUBE_HOME} && \
    chmod -R g+rwX ${SONARQUBE_HOME}

USER ${SONARQUBE_USER}

#
# Set application execution parameters
#

EXPOSE ${SONARQUBE_PORT}
WORKDIR ${SONARQUBE_HOME}

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
CMD ["run-sonarqube"]
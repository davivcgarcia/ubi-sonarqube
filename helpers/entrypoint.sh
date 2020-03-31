#!/bin/bash

#
# Discover user/group used on execution
#

export USER_ID=$(id -u)
export GROUP_ID=$(id -g)

#
# Enables rootless execution
#

grep -v "^${SONARQUBE_USER}" /etc/passwd > "${SONARQUBE_HOME}/nss_wrapper-passwd"
echo "${SONARQUBE_USER}:x:${USER_ID}:${GROUP_ID}:sonarqube user:${SONARQUBE_HOME}:/bin/bash" >> "${SONARQUBE_HOME}/nss_wrapper-passwd"
export LD_PRELOAD=libnss_wrapper.so
export NSS_WRAPPER_PASSWD=${SONARQUBE_HOME}/nss_wrapper-passwd
export NSS_WRAPPER_GROUP=/etc/group

#
# Expose common environment variables
#

export USER=${SONARQUBE_USER}
export HOME=${SONARQUBE_HOME}
export LANG=en_US.UTF-8

#
# Executes user provided command instead of default
#

if [ "$1" != 'run-sonarqube' ]; then
  exec "$@"
  exit $?
fi

#
# Executes default command defined on Dockerfile
#

exec java -jar lib/sonar-application-${SONARQUBE_VERSION}.jar \
          -Dsonar.log.console=true \
          -Dsonar.jdbc.username="${SONARQUBE_JDBC_USERNAME}" \
          -Dsonar.jdbc.password="${SONARQUBE_JDBC_PASSWORD}" \
          -Dsonar.jdbc.url="${SONARQUBE_JDBC_URL}" \
          -Dsonar.search.javaAdditionalOpts="${SONARQUBE_SEARCH_JVM_OPTS} -Dnode.store.allow_mmapfs=false" \
          -Dsonar.web.javaAdditionalOpts="${SONARQUBE_WEB_JVM_OPTS} -Djava.security.egd=file:/dev/./urandom" \
          ${SONARQUBE_EXTRA_ARGS}
exit $?

#!/bin/bash

# Discover user/group
export USER_ID=$(id -u)
export GROUP_ID=$(id -g)

# Fix non-root execution
echo "${SONARQUBE_USER}:x:${USER_ID}:${GROUP_ID}:gogs.io user:${SONARQUBE_HOME}:/bin/bash" >> "${SONARQUBE_HOME}/helpers/passwd"
export LD_PRELOAD=libnss_wrapper.so
export NSS_WRAPPER_PASSWD=${SONARQUBE_HOME}/helpers/passwd
export NSS_WRAPPER_GROUP=/etc/group

# Executes SonarQube service
if [ "${1:0:1}" != '-' ]; then
  exec "$@"
fi

exec java -jar lib/sonar-application-${SONARQUBE_VERSION}.jar \
  -Dsonar.log.console=true \
  -Dsonar.jdbc.username="${SONARQUBE_JDBC_USERNAME}" \
  -Dsonar.jdbc.password="${SONARQUBE_JDBC_PASSWORD}" \
  -Dsonar.jdbc.url="${SONARQUBE_JDBC_URL}" \
  -Dsonar.search.javaAdditionalOpts="${SONARQUBE_SEARCH_JVM_OPTS} -Dnode.store.allow_mmapfs=false" \
  -Dsonar.web.javaAdditionalOpts="${SONARQUBE_WEB_JVM_OPTS} -Djava.security.egd=file:/dev/./urandom" \
  "$@"
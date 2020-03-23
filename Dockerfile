FROM registry.access.redhat.com/ubi8/ubi

ENV SONARQUBE_VERSION=7.9.2 \
    SONARQUBE_USER=sonarqube \
    SONARQUBE_BASE=/opt \
    SONARQUBE_HOME=/opt/sonarqube \
    SONARQUBE_PORT=9000 \
    SONARQUBE_JDBC_USERNAME="" \
    SONARQUBE_JDBC_PASSWORD="" \
    SONARQUBE_JDBC_URL="" \
    SONARQUBE_WEB_JVM_OPTS=""

RUN yum -y install java-11-openjdk-headless nss_wrapper unzip && \
    yum -y clean all && \
    cd ${SONARQUBE_BASE} && \
    curl -o sonarqube.zip -SL https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-${SONARQUBE_VERSION}.zip && \
    unzip sonarqube.zip && \
    mv sonarqube-${SONARQUBE_VERSION} sonarqube && \
    rm -rf sonarqube.zip* && \
    rm -rf ${SONARQUBE_HOME}/bin/* && \
    cd ${SONARQUBE_HOME}

ADD helpers ${SONARQUBE_HOME}/helpers

RUN useradd -m -u 1000 -g 0 ${SONARQUBE_USER} && \
    chgrp -R 0 ${SONARQUBE_HOME} && \
    chmod -R g+rwX ${SONARQUBE_HOME}

EXPOSE ${SONARQUBE_PORT}

USER ${SONARQUBE_USER}
WORKDIR ${SONARQUBE_HOME}

CMD ["sh", "-c", "${SONARQUBE_HOME}/helpers/run.sh"]

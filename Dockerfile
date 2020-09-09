FROM jenkins/jenkins:2.235.5

ARG EXTRA_PATH

ENV EXTRA_PATH=${EXTRA_PATH:-/usr/local/extra}

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh  < /usr/share/jenkins/ref/plugins.txt
ENV HOME ${JENKINS_HOME}
WORKDIR ${JENKINS_HOME}
USER root
RUN echo ${EXTRA_PATH} \
    && mkdir -p ${EXTRA_PATH} \
    && chown jenkins:jenkins -R ${EXTRA_PATH}
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - \
    && echo 'deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main' >> /etc/apt/sources.list \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367 \
    && apt-get update \
    && apt-get install -y --no-install-recommends graphviz nodejs ansible \
    && rm -rf /var/lib/apt/lists/*
USER jenkins

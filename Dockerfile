FROM jenkins
MAINTAINER "EEA: IDM2 A-Team" <eea-edw-a-team-alerts@googlegroups.com>

COPY plugins.txt /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt
ENV HOME $JENKINS_HOME

USER root
RUN apt-get update \
 && apt-get install -y \
    graphviz \
    npm \
 && rm -rf /var/lib/apt/lists/*
USER jenkins

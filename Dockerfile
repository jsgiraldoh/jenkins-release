FROM jenkins/jenkins:lts

ARG EXTRA_PATH

ENV EXTRA_PATH=${EXTRA_PATH:-/usr/local/extra}
ENV ORACLE_HOME=${EXTRA_PATH}/oracle/instantclient_19_8
ENV LD_LIBRARY_PATH="$ORACLE_HOME"
ENV MSSQL_BIN=/opt/mssql-tools/bin  
ENV PATH="$MSSQL_BIN:$ORACLE_HOME:$PATH"

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
    && apt-get install -y --no-install-recommends graphviz nodejs ansible libaio1 libaio-dev \
    && rm -rf /var/lib/apt/lists/*

RUN curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list | tee /etc/apt/sources.list.d/msprod.list
RUN apt-get update
RUN ACCEPT_EULA=Y apt-get install -y --no-install-recommends --allow-unauthenticated mssql-tools unixodbc-dev

RUN apt install -y python-pip \
	&& apt install -y python3-pip \
	&& pip install mssql-scripter \
	&& apt-get install libicu57

RUN apt-get update \
	&& apt-get install gettext-base

USER jenkins

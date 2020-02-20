FROM centos

# RUN echo "[Artifactory]" >> /etc/yum.repos.d/artifactory.repo && \
#     echo "name=Artifactory" >> /etc/yum.repos.d/artifactory.repo && \
#     echo "baseurl=https://artifactory.intra.bec.dk/artifactory/fedora-epel-rpm-release-remote/7/x86_64" >> /etc/yum.repos.d/artifactory.repo && \
#     echo "enabled=1" >> /etc/yum.repos.d/artifactory.repo && \
#     echo "gpgcheck=0" >> /etc/yum.repos.d/artifactory.repo

RUN \
#yum install -y ansible && \
    #yum -y install python-pip && \
    dnf update -y
    dnf install python3-pip -y && \
    yum install gcc -y && \
    yum install python-devel -y && \
    yum clean all -y

RUN pip install Jinja2 && pip show Jinja2
RUN dnf install python3-pip
RUN pip3 install ansible --user
#RUN useradd -ms /bin/bash demo
#RUN echo demo:demo | chpasswd

ENV APP_ROOT=/ansible
ENV ANSIBLE_LOCAL_TEMP=${APP_ROOT}/ansible_temp
ENV PATH=${APP_ROOT}/bin:${PATH} HOME=${APP_ROOT}
ENV IBM_DB_HOME=/ansible/db2_client/clidriver

# COPY ./inventory/ ${APP_ROOT}/deployment/inventory/
# COPY ./playbooks/ ${APP_ROOT}/deployment/playbooks/
# COPY ./scripts/ ${APP_ROOT}/scripts/
COPY bin/ ${APP_ROOT}/bin/
# COPY /var/lib/jenkins/jobs/epo-extract/workspace/  ${APP_ROOT}/artefacts/


RUN mkdir -p ${APP_ROOT}/ansible_temp && \
    chgrp -R 0 ${APP_ROOT} && \
    chmod -R g+rw,o+rw,o+rw ${APP_ROOT} && \
    chmod -R u+x ${APP_ROOT}/bin && \
    chmod -R g=u /etc/passwd /etc/group
#chmod -R g=u ${APP_ROOT}

#ADD bin/linuxx64_odbc_cli.tar.gz ${APP_ROOT}/db2_client


# RUN dnf install python3-pip
# RUN pip3 install ansible --user
#RUN pip install -U ${APP_ROOT}/bin/MarkupSafe-1.1.1.tar.gz
#RUN pip install -U ${APP_ROOT}/bin/Jinja2-2.10.3.tar.gz
#RUN pip install -U ${APP_ROOT}/bin/ibm_db-3.0.1.tar.gz


USER 1001
WORKDIR ${APP_ROOT}

ENTRYPOINT [ "uid_entrypoint" ]

CMD exec /bin/sh -c "trap : TERM INT; (while true; do sleep 1000; done) & wait"

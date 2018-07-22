FROM solita/centos-systemd:7

EXPOSE 22

RUN yum install -y openssh-server
# RUN rm -rf /etc/ssh/ssh_host*

# COPY ssh-host-key.service /etc/systemd/system/
# RUN chmod 664 /etc/systemd/system/ssh-host-key.service
#RUN systemctl enable ssh-host-key.service

RUN sed -i \
	-e 's~^PasswordAuthentication yes~PasswordAuthentication no~g' \
	-e 's~^#PermitRootLogin yes~PermitRootLogin no~g' \
	-e 's~^#UseDNS yes~UseDNS no~g' \
	-e 's~^\(.*\)/usr/libexec/openssh/sftp-server$~\1internal-sftp~g' \
	/etc/ssh/sshd_config

RUN useradd vagrant

ENV SSH_AUTHORIZED_KEYS="" \
	SSH_AUTOSTART_SSHD=true \
	SSH_AUTOSTART_SSHD_BOOTSTRAP=true \
	SSH_CHROOT_DIRECTORY="%h" \
	SSH_INHERIT_ENVIRONMENT=false \
	SSH_SUDO="ALL=(ALL) ALL" \
	SSH_USER="app-admin" \
	SSH_USER_FORCE_SFTP=false \
	SSH_USER_HOME="/home/%u" \
	SSH_USER_ID="500:500" \
	SSH_USER_PASSWORD="" \
	SSH_USER_PASSWORD_HASHED=false \
	SSH_USER_SHELL="/bin/bash"

RUN mkdir -p ~vagrant/.ssh && \
  chmod 700 ~vagrant/.ssh && \
  curl -LSs https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant > ~vagrant/.ssh/authorized_keys && \
  chmod 600 ~vagrant/.ssh/authorized_keys


RUN  yum clean all; systemctl enable sshd.service;


CMD ["/sbin/init"]

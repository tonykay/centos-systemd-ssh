FROM solita/centos-systemd:7

# ssh, systemd, passwordless sudo container for ansible target use etc

LABEL maintainer="Tok - Tony Kay"

ENV user=vagrant
ENV ssh_port=22

# install ssh server and configure 
# setup the vagrant user, vagrant insecure key, passwordless sudo

RUN yum install -y openssh-server sudo && \
# setup sshd, install sudo
    echo "RSAAuthentication yes" >> /etc/ssh/sshd_config && \
    echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config && \
    systemctl enable sshd.service && \
# setup user, defaults to vagrant and ssh keys, use COPY to inject your own
    useradd ${user:-vagrant} && \ 
    mkdir -p /home/${user:-vagrant}/.ssh && \
    curl -LSs https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub > /home/vagrant/.ssh/authorized_keys && \
    chmod 600 /home/${user:-vagrant}/.ssh/authorized_keys && chmod 700 /home/${user:-vagrant}/.ssh && \
    chown -R ${user:-vagrant}:${user:-vagrant} /home/${user:-vagrant}/.ssh && \
# setup passwordless sudo for user
    echo "${user:-vagrant} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
# clean up
    yum clean all && \
    rm -rf /var/cache/yum

# expose ssh port, defaults to 22

EXPOSE ${ssh_port:-22}

CMD ["/sbin/init"]

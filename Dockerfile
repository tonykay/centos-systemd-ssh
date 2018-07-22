FROM solita/centos-systemd:7

# ssh && systemd container for ansible target use etc

LABEL maintainer="Tok - Tony Kay"

# ssh so expose 22

EXPOSE 22

# install ssh 

RUN yum install -y openssh-server sudo && \
    echo "RSAAuthentication yes" >> /etc/ssh/sshd_config && \
    echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config 

# setup the vagrant user and their insecure keys

RUN useradd vagrant && \ 
    mkdir -p /home/vagrant/.ssh && \
    curl -LSs https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub > /home/vagrant/.ssh/authorized_keys && \ 
    chmod 600 /home/vagrant/.ssh/authorized_keys && chmod 700 /home/vagrant/.ssh && \
    chown -R vagrant:vagrant /home/vagrant/.ssh && \
    echo "vagrant ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN yum clean all && \
    systemctl enable sshd.service;

CMD ["/sbin/init"]

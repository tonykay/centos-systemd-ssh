FROM solita/centos-systemd:7

EXPOSE 22

RUN yum install -y openssh-server

RUN useradd vagrant; mkdir -p /home/vagrant/.ssh 

COPY id_rsa.pub /home/vagrant/.ssh/authorized_keys

RUN chmod 600 /home/vagrant/.ssh/authorized_keys && chmod 700 /home/vagrant/.ssh && \
    chown -R vagrant:vagrant /home/vagrant/.ssh

RUN echo "RSAAuthentication yes" >> /etc/ssh/sshd_config && \
    echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config 

RUN  yum clean all; systemctl enable sshd.service;

CMD ["/sbin/init"]
# curl -LSs https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant > /home/vagrant/.ssh/authorized_keys && \

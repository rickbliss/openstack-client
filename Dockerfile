FROM library/python

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
apt-get install -y \
libguestfs-tools \
qemu-utils \
unzip \
ca-certificates \
git \
qemu-utils




RUN rm /usr/local/bin/python
RUN ln -s /usr/bin/python2.7 /usr/local/bin/python 

RUN pip install python-openstackclient
RUN pip install ansible
RUN pip install shade
RUN pip install dnspython

RUN wget https://releases.hashicorp.com/terraform/0.11.2/terraform_0.11.2_linux_amd64.zip -O /tmp/terraform.zip

RUN unzip /tmp/terraform.zip -d /usr/local/bin/
RUN chmod a+x /usr/local/bin/terraform

RUN useradd --create-home -s /bin/bash demouser -p demouser

VOLUME ~/.ssh/
VOLUME /opt/scripts

WORKDIR /opt/scripts
USER demouser



#ENV TF_LOG=true
#ENV OS_DEBUG=1

ENTRYPOINT /bin/bash -c "terraform init /opt/scripts/terraform/ && source /opt/scripts/kubernetes-openrc.sh && source /opt/scripts/genkey.sh && /opt/scripts/set-tf-os-vars.sh && /bin/bash" 

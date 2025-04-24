FROM docker:dind

RUN apk add openssh python3
RUN ssh-keygen -A
#RUN echo -en " \n \n" | adduser fumon
RUN adduser -D -s /bin/sh -h /home/fumon fumon
RUN echo "fumon:fumon" | chpasswd

RUN echo "PasswordAuthentication no" >> /etc/ssh/sshd_config
COPY authorized_keys.pub /home/fumon/.ssh/authorized_keys
CMD /usr/sbin/sshd -D
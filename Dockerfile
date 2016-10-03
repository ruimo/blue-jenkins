FROM jenkins

COPY blue-jenkins.sh /usr/local/bin/blue-jenkins.sh

USER root

ARG TIMEZONE=Asia/Tokyo
ENV TZ $TIMEZONE

RUN mkdir /var/_jenkins
RUN chown jenkins /var/_jenkins

# You can switch jenkins/sshd to comment-out/in the following two sections.
#--- sshd
#RUN apt-get update
#RUN apt-get install -y openssh-server rsync

#RUN mkdir /var/run/sshd
#RUN echo 'root:screencast' | chpasswd
#RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
#RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
#ENV NOTVISIBLE "in users profile"
#RUN echo "export VISIBLE=now" >> /etc/profile
#EXPOSE 22

ENTRYPOINT ["/usr/sbin/sshd", "-D"]
#--- sshd(end)

#--- jenkins
RUN apt-get update && apt-get install rsync

ENTRYPOINT ["/bin/tini", "--", "/usr/local/bin/blue-jenkins.sh"]
#--- jenkins(end)

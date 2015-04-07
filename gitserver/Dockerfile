FROM centos:7
MAINTAINER Justin Zhang "schenll_18@yahoo.com"
ENV LAST_UPDATE 2015-04-03
ENV GIT_SERVER_NAME gitserver
ENV GIT_ADMIN_USER_NAME admin
ENV GIT_ADMIN_USER_EMAIL admin@docker.container

# Change timezone to Asia/Shanghai
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
#
# enable private yum repo to
# install customized Git Gitolite cgit
ADD local.repo /etc/yum.repos.d/local.repo
RUN yum install -y git httpd gitolite3 cgit

ADD httpd_git.conf /etc/httpd/conf/
ADD cgitrc /etc/
ADD gitolite-wrapper.sh /var/www/cgi-bin/
ADD startup.sh /usr/bin/
RUN getent group git >/dev/null || groupadd -r -g 888 git
RUN getent passwd git >/dev/null ||  \
    useradd -r -o -u 888 -g git      \
    -d /var/lib/gitolite3 -s /bin/sh \
    -c "Git repository owner" git
RUN    chown -R git.git /var/cache/cgit              \
    && chmod +x /usr/bin/startup.sh                  \
    && chmod +x /var/www/cgi-bin/gitolite-wrapper.sh

VOLUME /var/lib/gitolite3

USER git

EXPOSE 8080

CMD [ "/usr/bin/startup.sh" ]

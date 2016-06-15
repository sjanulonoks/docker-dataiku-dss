FROM debian:latest
MAINTAINER Jean Baptiste Favre <docker@jbfavre.org>


ENV SHELL "/bin/bash"
ENV DEBIAN_FRONTEND noninteractive
ENV TERM 1

ADD scripts/debian_cleaner.sh /tmp/

RUN /usr/bin/apt-get update -yqq \
 && /usr/bin/apt-get upgrade --no-install-recommends -yqq \
 && /usr/bin/apt-get install --no-install-recommends -yqq locales curl libexpat1 \
                             nginx \
                             openjdk-7-jre \
                             python2.7 libpython2.7 libpng12-0 libfreetype6 libgfortran3 \
                             python2.7-dev \
                             r-base-dev libicu-dev libcurl4-openssl-dev libssl-dev libzmq3-dev pkg-config \
 && /usr/bin/chsh -s /bin/bash root \
 && /bin/rm /bin/sh && ln -s /bin/bash /bin/sh \
 && /usr/sbin/groupadd -r dataiku \
 && /usr/sbin/useradd -r -m -s /bin/bash -g dataiku dataiku \
 && /bin/echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
 && /usr/sbin/locale-gen \
 && /usr/bin/curl -SL -o /tmp/dataiku-dss.tar.gz https://downloads.dataiku.com/public/studio/3.0.3/dataiku-dss-3.0.3.tar.gz \
 && /bin/su - dataiku -c '/bin/tar xzf /tmp/dataiku-dss.tar.gz -C /home/dataiku --strip-components=1' \
 && /bin/rm /tmp/dataiku-dss.tar.gz \
 && /bin/mkdir /var/lib/dataiku \
 && /bin/chown -R dataiku: /var/lib/dataiku \
 && /bin/bash /tmp/debian_cleaner.sh

VOLUME /var/lib/dataiku
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
ADD ./docker-entrypoint.sh /usr/local/bin

EXPOSE 10000

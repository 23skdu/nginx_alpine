#This container runs nginx and crons from /etc/cron.d
#with perl,fcgi, and some very handy automation perl modules
FROM alpine:3.4

RUN echo "http://dl-6.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk --update upgrade && \
    apk add --update nginx fcgiwrap spawn-fcgi perl-net-dns perl-net-dns-sec openssh-client lsyncd perl-json-xs\ 
    perl-lwp-useragent-determined perl-lwp-protocol-https perl-parallel-forkmanager perl-net-smtp-ssl && \
    rm -rf /etc/nginx/* && rm -rf /etc/cron.d/* && \
    rm -rf /var/cache/apk/*

#Keep scripts called via cron here
RUN mkdir /scripts && chmod 755 /scripts

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

ADD nginx.sh /nginx.sh
RUN chmod 755 /nginx.sh
EXPOSE 80 443 
VOLUME [ "/etc/crontabs","/etc/nginx","/scripts","/var/www/html" ]
CMD ["/nginx.sh"]

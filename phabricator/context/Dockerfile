FROM centos:7

WORKDIR  /usr/my_phabricator

RUN yum -y install git \
    && git clone https://github.com/phacility/libphutil.git \
    && git clone https://github.com/phacility/arcanist.git \
    && git clone https://github.com/phacility/phabricator.git \
    && yum remove -y git

RUN yum install -y php php-cli php-mysql php-process php-devel php-gd php-cgi php-fpm php-pecl-apc php-pecl-json php-mbstring \
    && yum install -y gcc make \
    && yum install -y pcre-devel php-pear && echo "no" | pecl install apc \
    && echo "extension=apc.so" > /etc/php.d/apc.ini \
    && yum remove -y gcc make

COPY nginx.conf /usr/my_phabricator

RUN rpm -Uvh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm \
    && yum -y install nginx \
    && cp /usr/my_phabricator/nginx.conf /etc/nginx/conf.d/phabricator.conf


CMD if [ "" = "$MYSQL_HOST" -o "" = "$MYSQL_PASS" ]; then echo "please set MYSQL_HOST and MYSQL_PASS" && exit 1; fi \
    && if [ "" = "`echo "$PHABRICATOR_DOMAIN" | grep -E '^([0-9a-zA-Z]+\.)+?[0-9a-zA-Z]+?$'`" ]; then echo "please set PHABRICATOR_DOMAIN" && exit 1; fi \
    && ./phabricator/bin/config set mysql.host ${MYSQL_HOST} \
    && ./phabricator/bin/config set mysql.port ${MYSQL_PORT=3306} \
    && ./phabricator/bin/config set mysql.user ${MYSQL_USER=root} \
    && ./phabricator/bin/config set mysql.pass ${MYSQL_PASS} \
    && ./phabricator/bin/storage upgrade --force \
    && bash -c "/usr/sbin/php-fpm &"  \
    && sed -i "/# server_name/a   server_name ${PHABRICATOR_DOMAIN};" /etc/nginx/conf.d/phabricator.conf \
    && nginx && bash





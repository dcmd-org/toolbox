FROM debian:bullseye

SHELL ["/bin/bash", "-c"]

RUN apt update -y &&\
    apt install -y \
    gnupg \
    curl \
    wget \
    git \
    software-properties-common \
    ca-certificates \
    lsb-release \
    apt-transport-https \
    build-essential

# PHP 8.2

RUN sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list' &&\
    wget -qO - https://packages.sury.org/php/apt.gpg | apt-key add -

RUN apt update -y

RUN apt install -y \
    php8.2 \
    php8.2-cli \
    php8.2-mbstring \
    php8.2-xml \
    php8.2-common \
    php8.2-curl \
    php8.2-mysql \
    php8.2-gd \
    php8.2-zip \
    php8.2-gmp \
    php8.2-exif \
    php8.2-opcache \
    php8.2-intl

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" &&\
    php composer-setup.php &&\
    php -r "unlink('composer-setup.php');" &&\
    mv composer.phar /usr/local/bin/composer

# NodeJS

RUN curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash

RUN . ~/.nvm/nvm.sh &&\
    nvm cache clear &&\
    nvm install lts/iron &&\
    nvm use lts/iron &&\
    nvm alias default lts/iron

WORKDIR /app
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
    apt-transport-https

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
    php -r "if (hash_file('sha384', 'composer-setup.php') === '55ce33d7678c5a611085589f1f3ddf8b3c52d662cd01d4ba75c0ee0459970c2200a51f492d557530c71c15d8dba01eae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" &&\
    php composer-setup.php &&\
    php -r "unlink('composer-setup.php');" &&\
    mv composer.phar /usr/local/bin/composer

# NodeJS

RUN curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash

RUN . ~/.nvm/nvm.sh &&\
    nvm install lts/hydrogen &&\
    nvm use lts/hydrogen &&\
    nvm alias default lts/hydrogen

WORKDIR /app
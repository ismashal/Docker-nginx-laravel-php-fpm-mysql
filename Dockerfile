FROM php:7.2-fpm

COPY ./ui/src/composer.lock ./var/www
COPY ./ui/src/composer.json ./var/www

# Set working directory
WORKDIR /var/www/html

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
	nginx \
    #mysql-client \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    curl

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install extensions
RUN docker-php-ext-install pdo_mysql mbstring zip exif pcntl
#RUN docker-php-ext-configure gd --with-gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/
#RUN docker-php-ext-install gd

#Nginx installtion and configuration
  
#COPY ./nginx_installation.sh /nginx_installation.sh
#RUN chmod 755 /nginx_installation.sh && /nginx_installation.sh

COPY ./default.conf /etc/nginx/conf.d/default.conf

# Install composer
#RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy existing application directory contents
#COPY ./ui/src/ /var/www/html

# Copy existing application directory permissions
RUN chown -R www-data:www-data /var/www

# Expose port 9000 and start php-fpm server
EXPOSE 80 443 9000
CMD ["php-fpm"]
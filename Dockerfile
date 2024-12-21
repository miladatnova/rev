# Use an official PHP image with PHP 8.1
FROM php:8.1-cli

# Install required system dependencies
RUN apt-get update && apt-get install -y \
    unzip \
    git \
    libzip-dev \
    libxml2-dev \
    zlib1g-dev \
    && docker-php-ext-install \
    zip \
    xml \
    tokenizer \
    && docker-php-ext-enable \
    zip \
    xml

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy project files into the container
COPY . .

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader

# Handle post-install scripts and ensure permissions
RUN composer run-script post-install-cmd && \
    chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html

# Expose port 80 for the application (adjust as needed)
EXPOSE 80

# Use PHP's built-in web server for local development
CMD ["php", "-S", "0.0.0.0:80", "-t", "www"]

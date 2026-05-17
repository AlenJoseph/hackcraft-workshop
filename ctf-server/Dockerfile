FROM alpine:3.19

# Install Nginx, PHP, OpenSSH, and utilities
RUN apk add --no-cache \
    nginx \
    php82 \
    php82-fpm \
    php82-sqlite3 \
    php82-pdo \
    php82-pdo_sqlite \
    php82-session \
    openssh-server \
    bash \
    shadow \
    && mkdir -p /run/nginx /run/php /var/www/html

# Copy web content
COPY html/ /var/www/html/
COPY nginx.conf /etc/nginx/http.d/default.conf
COPY setup.sh /setup.sh

RUN chmod +x /setup.sh

# Configure PHP-FPM to listen on socket
RUN sed -i 's/listen = 127.0.0.1:9000/listen = \/run\/php\/php-fpm.sock/' /etc/php82/php-fpm.d/www.conf && \
    echo "listen.owner = nginx" >> /etc/php82/php-fpm.d/www.conf && \
    echo "listen.group = nginx" >> /etc/php82/php-fpm.d/www.conf

# Create the SQLite database for the login form
RUN mkdir -p /var/www/data && \
    php82 -r " \
    \$db = new SQLite3('/var/www/data/users.db'); \
    \$db->exec('CREATE TABLE users (id INTEGER PRIMARY KEY, username TEXT, password TEXT, role TEXT)'); \
    \$db->exec(\"INSERT INTO users VALUES (1, 'admin', 'supersecretpassword', 'administrator')\"); \
    \$db->exec(\"INSERT INTO users VALUES (2, 'guest', 'guest123', 'viewer')\"); \
    \$db->exec(\"INSERT INTO users VALUES (3, 'ctf_master', 'HACKCRAFT{sql_injection_is_dangerous}', 'hidden')\"); \
    " && \
    chown -R nginx:nginx /var/www/data

# Setup SSH with weak credentials (Flag 4 target)
RUN ssh-keygen -A && \
    adduser -D -s /bin/bash ctfuser && \
    echo "ctfuser:hackme123" | chpasswd && \
    echo "HACKCRAFT{weak_passwords_get_cracked}" > /home/ctfuser/flag.txt && \
    chown ctfuser:ctfuser /home/ctfuser/flag.txt && \
    sed -i 's/#PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    echo "AllowUsers ctfuser" >> /etc/ssh/sshd_config

# Plant Flag 2 - directory brute-force target
RUN mkdir -p /var/www/html/secret && \
    echo "HACKCRAFT{directory_brute_force_wins}" > /var/www/html/secret/flag.txt

# Set permissions
RUN chown -R nginx:nginx /var/www/html

EXPOSE 80 22

CMD ["/setup.sh"]

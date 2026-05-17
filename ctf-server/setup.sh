#!/bin/bash
# HackCraft CTF Server - Startup script
# Starts SSH, PHP-FPM, and Nginx

# Start SSH daemon
/usr/sbin/sshd

# Start PHP-FPM
php-fpm82

# Start Nginx in foreground (keeps container alive)
nginx -g "daemon off;"

# Build nginx
FROM nginx:1.25.5

# Install Certbot and dependencies
RUN yum update && yum install -y certbot python3-certbot-dns-route53 cronie

# Copy custom nginx configuration file
COPY nginx.conf /etc/nginx/nginx.conf

# Add cron job for certificate renewal
RUN echo "0 0 * * * certbot renew --non-interactive --dns-route53 --post-hook 'nginx -s reload'" > /etc/cron.d/certbot-renew
RUN chmod 0644 /etc/cron.d/certbot-renew

# Expose ports
# EXPOSE 80
# EXPOSE 443

# Command to start cron
CMD ["crond", "-f"]
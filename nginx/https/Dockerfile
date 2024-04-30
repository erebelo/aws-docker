# Build nginx
FROM nginx:1.25.5

# Copy custom nginx configuration file
COPY nginx.conf /etc/nginx/nginx.conf

# Copy ssl certificate files into the container
COPY /etc/letsencrypt/live/erebelo.com/fullchain.pem /etc/nginx/certs/fullchain.pem
COPY /etc/letsencrypt/live/erebelo.com/privkey.pem /etc/nginx/certs/privkey.pem
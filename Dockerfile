# Use official Nginx base image
FROM nginx:latest

# Copy custom HTML or app files to Nginx web root (optional)
# COPY ./html /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Run Nginx in foreground
CMD ["nginx", "-g", "daemon off;"]


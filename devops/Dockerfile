# Base nginx image
FROM nginx:alpine

# Set working directory
WORKDIR /usr/share/nginx/html

# Copy your project files
COPY . .

# Expose port
EXPOSE 80

# Run nginx
CMD ["nginx", "-g", "daemon off;"]
# run this

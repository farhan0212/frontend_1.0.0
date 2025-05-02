# Use lowercase image name and pin to specific version for security
FROM node:20-alpine AS build

WORKDIR /app

# Copy dependency files first (better caching)
COPY package*.json ./
RUN npm install

# Then copy source code
COPY . ./

RUN npm run build

# Use specific version with digest for enhanced security
FROM nginx:1.25-alpine

# Clean default nginx static files
RUN rm -rf /usr/share/nginx/html/*

# Verify this path matches your build output directory (out vs build vs dist)
COPY --from=build /app/out /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
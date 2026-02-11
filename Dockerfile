# Build stage
FROM node:18-alpine AS builder

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci

e
COPY . .

p
RUN npm run build


FROM nginx:alpine


RUN apk add --no-cache bash gettext


COPY --from=builder /app/dist /usr/share/nginx/html

COPY nginx.conf /etc/nginx/templates/nginx.conf


EXPOSE 8080


CMD envsubst '$PORT' < /etc/nginx/templates/nginx.conf > /etc/nginx/nginx.conf && nginx -g 'daemon off;'

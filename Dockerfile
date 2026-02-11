# Build stage
FROM node:18-alpine AS builder

WORKDIR /app

# Only copy files needed for install to cache layers effectively
COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build


FROM nginx:alpine

RUN apk add --no-cache bash gettext

COPY --from=builder /app/dist /usr/share/nginx/html


COPY nginx.conf /etc/nginx/templates/nginx.conf


EXPOSE 8080


CMD /bin/sh -c "export PORT=${PORT:-8080} && envsubst '\$PORT' < /etc/nginx/templates/nginx.conf > /etc/nginx/nginx.conf && exec nginx -g 'daemon off;'"
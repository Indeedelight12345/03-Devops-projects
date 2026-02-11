# Build stage
FROM node:18-alpine AS builder

WORKDIR /app


COPY package*.json ./


RUN npm ci


COPY . .


RUN npm run build


FROM nginx:alpine


RUN apk add --no-cache bash gettext


COPY --from=builder /app/dist /usr/share/nginx/html

COPY nginx.conf /etc/nginx/templates/nginx.conf


EXPOSE 80


CMD envsubst '$PORT' < /etc/nginx/templates/nginx.conf > /etc/nginx/nginx.conf && nginx -g 'daemon off;'

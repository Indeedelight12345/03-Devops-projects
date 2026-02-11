
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build


FROM nginx:alpine
RUN apk add --no-cache bash gettext


COPY --from=builder /app/dist /usr/share/nginx/html

COPY nginx.conf /etc/nginx/nginx.template


CMD /bin/sh -c "envsubst '\$PORT' < /etc/nginx/nginx.template > /etc/nginx/conf.d/default.conf && exec nginx -g 'daemon off;'"
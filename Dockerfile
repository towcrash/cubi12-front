# Use the official Node.js runtime as the base image
FROM node:18 AS build

ARG backend_url
ENV REACT_APP_API_URL $backend_url

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

# Use Nginx as the production server
FROM nginx:alpine

# Solo copia UNA vez la configuración
COPY ./nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/build /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
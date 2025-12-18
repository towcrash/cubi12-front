# Use the official Node.js runtime as the base image
FROM node:18 AS build

# IMPORTANTE: Definir la URL del backend
# Esta variable se puede sobrescribir durante el build
ARG REACT_APP_API_URL=https://cubi12-backend-latest.onrender.com/api/
ENV REACT_APP_API_URL=$REACT_APP_API_URL

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

# Verificar que la variable esté disponible durante el build
RUN echo "Building with API URL: $REACT_APP_API_URL"

RUN npm run build

# Use Nginx as the production server
FROM nginx:alpine

# Solo copia UNA vez la configuración
COPY ./nginx.conf /etc/nginx/conf.d/
COPY ./nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/build /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
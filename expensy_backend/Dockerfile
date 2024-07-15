FROM node:latest

EXPOSE 8706

COPY . /var/www/expensy_backend
WORKDIR /var/www/expensy_backend
RUN npm install

ENTRYPOINT [ "npm", "start" ]

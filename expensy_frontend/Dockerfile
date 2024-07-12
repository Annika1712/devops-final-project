FROM node:latest

EXPOSE 3000

COPY . /var/www/expensy_frontend
WORKDIR /var/www/expensy_frontend
RUN npm install

ENTRYPOINT [ "npm", "start" ]

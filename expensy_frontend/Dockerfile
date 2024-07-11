FROM node:latest

EXPOSE 3000

COPY . /var/www/expensy_frontend
WORKDIR /var/www/expensy_frontend
RUN npm install

VOLUME ["/c/Projects/DOCKER_PROJECTS/expensy_frontend"]
ENTRYPOINT [ "npm", "start" ]

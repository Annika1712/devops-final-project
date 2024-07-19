FROM node:latest

EXPOSE 8706

COPY . /var/www/exp_backend
WORKDIR /var/www/exp_backend
RUN npm install

ENTRYPOINT [ "npm", "start" ]

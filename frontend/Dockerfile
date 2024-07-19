FROM node:latest

EXPOSE 3000

COPY . /var/www/exp_frontend
WORKDIR /var/www/exp_frontend
RUN npm install

ENTRYPOINT [ "npm", "start" ]

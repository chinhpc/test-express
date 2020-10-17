# specify the node base image with your desired version node:<version>
FROM node:latest
# replace this with your application's default port
EXPOSE 3000

ADD myapp /home/node/myapp
WORKDIR /home/node/myapp/
RUN npm install
RUN npm audit fix

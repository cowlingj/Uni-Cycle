FROM node:13.2.0-alpine

LABEL version 0.0.2

COPY / /usr/lib/app
WORKDIR /usr/lib/app
RUN npm install
RUN npm run build

EXPOSE 80
ENTRYPOINT [ "npm", "run", "start" ]

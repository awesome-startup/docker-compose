FROM node

WORKDIR /parse

ADD package.json /parse
ADD main.js /parse/cloud/main.js
ADD index.js /parse

RUN npm install

ENV MONGO_DB_NAME=dev

ENV APP_ID=appId
ENV MASTER_KEY=masterKey

ENV ADMIN_USER=user
ENV ADMIN_PASS=pass

ENV PARSE_PUBLIC_ADDR=localhost
ENV PARSE_PUBLIC_PORT=1337

ENV PARSE_DASHBOARD_ALLOW_INSECURE_HTTP=true

EXPOSE $PARSE_PORT 4040
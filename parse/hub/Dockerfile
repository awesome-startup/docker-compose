FROM node

WORKDIR /parse

# ENV PARSE_SERVER_VERSION=2.2.8
# ENV PARSE_DASHBOARD_VERSION=1.0.11

# RUN npm install -g parse-server@${PARSE_SERVER_VERSION}
# RUN npm install -g parse-dashboard@${PARSE_DASHBOARD_VERSION}
# RUN npm install -g express@4.13.4

ADD package.json /parse
ADD main.js /parse/cloud/main.js
ADD index.js /parse

ENV PARSE_DASHBOARD_ALLOW_INSECURE_HTTP=1

RUN npm install

EXPOSE 1337 4040
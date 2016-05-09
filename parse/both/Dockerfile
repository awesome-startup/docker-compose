FROM node

#RUN npm install -g parse-server

WORKDIR /parse

RUN npm install -g parse-server parse-dashboard

ADD init.sh /parse

RUN chmod +x init.sh

ENTRYPOINT ["./init.sh"]

EXPOSE 1337 4040
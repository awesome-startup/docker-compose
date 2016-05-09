FROM node

#RUN npm install -g parse-server

WORKDIR /parse

RUN npm install -g parse-server@2.2.6 
RUN npm install -g parse-dashboard@1.0.7

ADD init.sh /parse

RUN chmod +x init.sh

ENTRYPOINT ["./init.sh"]

EXPOSE 1337 4040
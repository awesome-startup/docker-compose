FROM node

#RUN npm install -g parse-server

WORKDIR /parse

RUN npm install -g parse-server@2.2.6 

ENTRYPOINT ["parse-server"]

EXPOSE 1337

CMD ["-h"]

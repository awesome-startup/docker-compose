FROM node

#RUN npm install -g parse-server

WORKDIR /parse
ADD index.js /parse
ADD package.json /parse
ADD main.js /parse/cloud/

EXPOSE 8080
 
ENV APP_ID=X4jwAIMI2sCuH99ueEI4c8LdTbgnkrR4u5kSqsc8
ENV MASTER_KEY=43p7s64k54z9uOKgztcC23CXx0cAM6RbdXObWfVt

RUN npm install


CMD [ "npm", "start" ]

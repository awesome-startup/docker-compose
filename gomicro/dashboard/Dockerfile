FROM node

RUN git clone https://github.com/Margatroid/micro-dashboard.git /dashboard

WORKDIR /dashboard

RUN npm install

RUN npm run build

EXPOSE 3000

CMD ["node", "server.js"]

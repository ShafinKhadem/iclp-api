FROM node:alpine
RUN apk add g++
WORKDIR /app
COPY ["package.json", "./"]
RUN npm install --production
COPY . .
CMD node src/index.js
# docker build -t iclp-docker .
# docker run -it --name iclp-docker-sh iclp-docker /bin/sh
# docker start -ai iclp-docker-sh
# docker run --init --net="host" --name iclp-docker iclp-docker
# docker start -a iclp-docker
# docker exec -it iclp-docker /bin/sh
# docker stop iclp-docker
# docker system prune
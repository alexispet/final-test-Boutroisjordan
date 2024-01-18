FROM node:21.5.0-alpine AS build

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install

COPY . .

FROM node:21.5.0-alpine AS node

WORKDIR /usr/src/app

COPY --from=build /usr/src/app/package.json /usr/src/app/
COPY --from=build /usr/src/app/node_modules /usr/src/app/node_modules/
COPY --from=build /usr/src/app /usr/src/app

EXPOSE 3000

COPY ./docker/docker-entrypoint.sh /usr/local/bin/docker-entrypoint
RUN chmod +x /usr/local/bin/docker-entrypoint

ENTRYPOINT ["docker-entrypoint"]
CMD ["npm", "run", "start"]


FROM node:21.5.0-alpine AS build

COPY . /app/

WORKDIR /app

RUN npm install

FROM node:21.5.0-alpine AS node

WORKDIR /app

COPY --from=build /usr/app/package.json /usr/app/
COPY --from=build /usr/app/node_modules /usr/app/node_modules/
COPY --from=build /usr/app /usr/app

EXPOSE 3000

COPY docker/docker-entrypoint.sh /usr/local/bin/docker-entrypoint
RUN chmod +x /usr/local/bin/docker-entrypoint

ENTRYPOINT ["docker-entrypoint"]
CMD ["npm", "run", "start"]


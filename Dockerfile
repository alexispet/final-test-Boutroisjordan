FROM node:21.5.0-alpine AS build

COPY . /app/

WORKDIR /app

RUN npm install

FROM node:21.5.0-alpine AS node

LABEL org.opencontainers.image.source https://github.com/alexispet/final-test-Boutroisjordan

WORKDIR /app

COPY --from=build /app/package.json /app/
COPY --from=build /app/node_modules /app/node_modules/
COPY --from=build /app /app

EXPOSE 3000

COPY docker/docker-entrypoint.sh /usr/local/bin/docker-entrypoint
RUN chmod +x /usr/local/bin/docker-entrypoint

ENTRYPOINT ["docker-entrypoint"]
CMD ["npm", "run", "start"]


#!/bin/sh

if [ $NODE_ENV == "development" ]
then
    echo "On est en Dev"
    npm install
fi
 npm run db:import

exec "$@" 
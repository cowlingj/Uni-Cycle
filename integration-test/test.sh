#!/usr/bin/env sh

docker-compose up --build --abort-on-container-exit --exit-code-from test
docker-compose down

#!/usr/bin/env bash

[ -n "$PORT" ] || PORT=3001
export PORT
nuxt build
nuxt start &
WAIT_FOR=%%
sleep 10
lighthouse-ci http://localhost:3001/store
kill "$WAIT_FOR"

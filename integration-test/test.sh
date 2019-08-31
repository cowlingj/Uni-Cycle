#!/usr/bin/env sh

set -u

clean() {
  kubectl delete -Rf ./kubernetes
  docker image rm -f cms.frontend.local:test mongodb.backend.local:test integration.test.local:test
}
trap clean EXIT

clean

docker build -t cms.frontend.local:test ../cms &
docker build -t mongodb.backend.local:test ./mongodb &
docker build -t integration.test.local:test ./runner &

wait

kubectl apply -Rf ./kubernetes

sleep 30

kubectl run integration-test \
  --attach \
  --rm \
  --generator=run-pod/v1 \
  --restart=Never \
  --image=integration.test.local:test


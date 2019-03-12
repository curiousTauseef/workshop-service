#!/usr/bin/env bash

error() {
  echo ">>>>>> Test Failures Found, exiting test run <<<<<<<<<"

  echo
  echo ===========================================================
  echo Printing logs from APP container
  echo ===========================================================
  echo

  docker logs app

  echo
  echo ===========================================================
  echo End of logs from APP container
  echo ===========================================================
  echo

  exit 1
}
cleanup() {
  echo "....Cleaning up"

  docker stop app

  docker rm app
  docker network rm customer-contract-tests.network

  # remove untagged images (these are left behind when docker run fails)
  if [ $(docker images | grep '^<none>' | wc -c) -gt 0 ]; then
    docker images | grep "^<none>" | tr -s " " " " | cut -f3 -d" " | ifne xargs docker rmi
  fi
  echo ""
  echo "....Cleaning up done"
}
trap error ERR
trap cleanup EXIT

ifne () {
        read line || return 1
        (echo "$line"; cat) | eval "$@"
}

echo
echo ===========================================================
echo Building containers
echo ===========================================================
echo

docker build -t customer-contract-tests-stub ../../..
docker build -t customer-contract-tests-tests .

echo
echo ===========================================================
echo Spinning up test environment
echo ===========================================================
echo

$(aws ecr get-login --no-include-email --region eu-west-1)

docker network create -d bridge customer-contract-tests.network

docker run -d --net=customer-contract-tests.network --name app -p 3000:3000 customer-contract-tests-stub
sleep 1

echo
echo ===========================================================
echo Running outside-in tests
echo ===========================================================
echo

docker run --net=customer-contract-tests.network --rm -e SERVICE_UNDER_TEST_HOSTNAME=app:3000 --name tests customer-contract-tests-tests ./node_modules/.bin/cucumber-js ./**/*.feature
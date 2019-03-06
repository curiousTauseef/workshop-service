# Consumer contract testing workshop

Welcome to consumer contract testing, you will have all the necessary information in this readme to 
help guide you through the workshop. This repo contains a simple customer service that has
no contract tests from its consumers.

## Getting Started

Fork this repository

### Prerequisites

1. You will need to have docker version 18.09.2, build 6247962 or greater installed
2. You will need to be able to pull from an AWS ECR for this workshop.


### Steps

1. Create a simple boilerplate app (in any language that can be run in docker). You can get a quick example
[here](https://github.com/ComparetheMarket/engineering.consumer-contract-testing.docker)
2. Take a look at the swagger spec in this repo and create a stub against this.
3. Create the files required by the standards to run consumer contrct tests against your stub.
4. PR your features, fixtures, Dockerfile and test.sh into your consumer named directory on the service.
4. Get your feature tests to pass

You can see a case study [here](https://engineering-docs-test.vassily.io/docs/testing/consumer-contract-testing/case-study/) with step by step instructions.

If you are having trouble pulling the ECR from AWS you can use [this](https://cloud.docker.com/u/rgparkins/repository/docker/rgparkins/contract-testing-base) 


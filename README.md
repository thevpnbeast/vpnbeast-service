# Vpnbeast Service
[![CI](https://github.com/thevpnbeast/vpnbeast-service/workflows/CI/badge.svg?event=push)](https://github.com/thevpnbeast/vpnbeast-service/actions?query=workflow%3ACI)
[![Go Report Card](https://goreportcard.com/badge/github.com/thevpnbeast/vpnbeast-service)](https://goreportcard.com/report/github.com/thevpnbeast/vpnbeast-service)
[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=thevpnbeast_vpnbeast-service&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=thevpnbeast_vpnbeast-service)
[![Maintainability Rating](https://sonarcloud.io/api/project_badges/measure?project=thevpnbeast_vpnbeast-service&metric=sqale_rating)](https://sonarcloud.io/summary/new_code?id=thevpnbeast_vpnbeast-service)
[![Reliability Rating](https://sonarcloud.io/api/project_badges/measure?project=thevpnbeast_vpnbeast-service&metric=reliability_rating)](https://sonarcloud.io/summary/new_code?id=thevpnbeast_vpnbeast-service)
[![Security Rating](https://sonarcloud.io/api/project_badges/measure?project=thevpnbeast_vpnbeast-service&metric=security_rating)](https://sonarcloud.io/summary/new_code?id=thevpnbeast_vpnbeast-service)
[![Coverage](https://sonarcloud.io/api/project_badges/measure?project=thevpnbeast_vpnbeast-service&metric=coverage)](https://sonarcloud.io/summary/new_code?id=thevpnbeast_vpnbeast-service)
[![Go version](https://img.shields.io/github/go-mod/go-version/thevpnbeast/vpnbeast-service)](https://github.com/thevpnbeast/vpnbeast-service)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

## Development
This project requires below tools while developing:
- [Golang 1.19](https://golang.org/doc/go1.19)
- [pre-commit](https://pre-commit.com/)
- [golangci-lint](https://golangci-lint.run/usage/install/) - required by [pre-commit](https://pre-commit.com/)
- [gocyclo](https://github.com/fzipp/gocyclo) - required by [pre-commit](https://pre-commit.com/)

Simply run below command to prepare your development environment:
```shell
$ python3 -m venv venv
$ source venv/bin/activate
$ pip3 install pre-commit
$ pre-commit install -c build/ci/.pre-commit-config.yaml
```

Sample SAM commands:
```shell
# Validate the SAM Template
$ make sam-validate
# Invoke function
$ make sam-local-invoke
# Test function in the cloud
$ make sam-cloud-invoke
# Deploy to stage
$ make sam-deploy-stage
# Deploy to prod
$ make sam-deploy-prod
```

## References
- https://www.softkraft.co/aws-lambda-in-golang/
- https://serverlessland.com/patterns/apigw-cognito-authorizer-sam-nodejs
- https://aws.amazon.com/blogs/compute/using-github-actions-to-deploy-serverless-applications/
- https://github.com/aws/serverless-application-model/blob/master/versions/2016-10-31.md#aws-serverless-application-model-sam

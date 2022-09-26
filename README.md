# Vpnbeast Service

## Development
This project requires below tools while developing:
- [Golang 1.19](https://golang.org/doc/go1.19)
- [pre-commit](https://pre-commit.com/)
- [golangci-lint](https://golangci-lint.run/usage/install/) - required by [pre-commit](https://pre-commit.com/)
- [gocyclo](https://github.com/fzipp/gocyclo) - required by [pre-commit](https://pre-commit.com/)

After you installed [pre-commit](https://pre-commit.com/), simply run below command to prepare your development environment:
```shell
$ pre-commit install -c build/ci/.pre-commit-config.yaml
```

## References
- https://www.softkraft.co/aws-lambda-in-golang/
- https://serverlessland.com/patterns/apigw-cognito-authorizer-sam-nodejs

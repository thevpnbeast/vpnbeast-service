# assumes that we have already a profile named thevpnbeast-root in AWS CLI config
export AWS_PROFILE := thevpnbeast-root

AWS_REGION = us-east-1
AWS_IAM_CAPABILITIES = CAPABILITY_IAM
AWS_RELEASES_BUCKET = thevpnbeast-releases
AWS_STACK_NAME = vpnbeast-service

ERRCHECK_VERSION = latest
GOLANGCI_LINT_VERSION = latest
REVIVE_VERSION = latest
GOIMPORTS_VERSION = latest
INEFFASSIGN_VERSION = latest

LOCAL_BIN := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))/.bin

.PHONY: all
all: clean tools lint fmt test build

.PHONY: clean
clean:
	rm -rf $(LOCAL_BIN)

.PHONY: tools
tools:  golangci-lint-install revive-install go-imports-install ineffassign-install
	go mod tidy

.PHONY: golangci-lint-install
golangci-lint-install:
	GOBIN=$(LOCAL_BIN) go install github.com/golangci/golangci-lint/cmd/golangci-lint@$(GOLANGCI_LINT_VERSION)

.PHONY: revive-install
revive-install:
	GOBIN=$(LOCAL_BIN) go install github.com/mgechev/revive@$(REVIVE_VERSION)

.PHONY: ineffassign-install
ineffassign-install:
	GOBIN=$(LOCAL_BIN) go install github.com/gordonklaus/ineffassign@$(INEFFASSIGN_VERSION)

.PHONY: lint
lint: tools run-lint

.PHONY: run-lint
run-lint: lint-golangci-lint lint-revive

.PHONY: lint-golangci-lint
lint-golangci-lint:
	$(info running golangci-lint...)
	$(LOCAL_BIN)/golangci-lint -v run ./... || (echo golangci-lint returned an error, exiting!; sh -c 'exit 1';)

.PHONY: lint-revive
lint-revive:
	$(info running revive...)
	$(LOCAL_BIN)/revive -formatter=stylish -config=build/ci/.revive.toml -exclude ./vendor/... ./... || (echo revive returned an error, exiting!; sh -c 'exit 1';)

.PHONY: upgrade-direct-deps
upgrade-direct-deps: tidy
	for item in `grep -v 'indirect' go.mod | grep '/' | cut -d ' ' -f 1`; do \
		echo "trying to upgrade direct dependency $$item" ; \
		go get -u $$item ; \
  	done
	go mod tidy
	go mod vendor

.PHONY: tidy
tidy:
	go mod tidy

.PHONY: run-goimports
run-goimports: go-imports-install
	for item in `find . -type f -name '*.go' -not -path './vendor/*'`; do \
		$(LOCAL_BIN)/goimports -l -w $$item ; \
	done

.PHONY: go-imports-install
go-imports-install:
	GOBIN=$(LOCAL_BIN) go install golang.org/x/tools/cmd/goimports@$(GOIMPORTS_VERSION)

.PHONY: fmt
fmt: tools run-fmt run-ineffassign run-vet

.PHONY: run-fmt
run-fmt:
	$(info running fmt...)
	go fmt ./... || (echo fmt returned an error, exiting!; sh -c 'exit 1';)

.PHONY: run-ineffassign
run-ineffassign:
	$(info running ineffassign...)
	$(LOCAL_BIN)/ineffassign ./... || (echo ineffassign returned an error, exiting!; sh -c 'exit 1';)

.PHONY: run-vet
run-vet:
	$(info running vet...)
	go vet ./... || (echo vet returned an error, exiting!; sh -c 'exit 1';)

.PHONY: test
test: tidy
	$(info starting the test for whole module...)
	go test -failfast -vet=off -race ./... || (echo an error while testing, exiting!; sh -c 'exit 1';)

.PHONY: test-with-coverage
test-with-coverage: tidy
	go test ./... -race -coverprofile=coverage.txt -covermode=atomic

.PHONY: update
update: tidy
	go get -u ./...

.PHONY: build
build: tidy
	$(info building binary...)
	go build -o bin/vpnbeast-service cmd/vpnbeast-service/main.go || (echo an error while building binary, exiting!; sh -c 'exit 1';)

.PHONY: run
run: tidy
	go run main.go

.PHONY: cross-compile
cross-compile:
	GOOS=freebsd GOARCH=386 go build -o bin/main-freebsd-386 cmd/vpnbeast-service/main.go
	GOOS=darwin GOARCH=386 go build -o bin/main-darwin-386 cmd/vpnbeast-service/main.go
	GOOS=linux GOARCH=386 go build -o bin/main-linux-386 cmd/vpnbeast-service/main.go
	GOOS=windows GOARCH=386 go build -o bin/main-windows-386 cmd/vpnbeast-service/main.go
	GOOS=freebsd GOARCH=amd64 go build -o bin/main-freebsd-amd64 cmd/vpnbeast-service/main.go
	GOOS=darwin GOARCH=amd64 go build -o bin/main-darwin-amd64 cmd/vpnbeast-service/main.go
	GOOS=linux GOARCH=amd64 go build -o bin/main-linux-amd64 cmd/vpnbeast-service/main.go
	GOOS=windows GOARCH=amd64 go build -o bin/main-windows-amd64 cmd/vpnbeast-service/main.go

VERSION := $(shell git describe --tags --abbrev=0 2>/dev/null || echo "1.0.0")
.PHONY: aws-build
aws-build:
	go get -v all
	GOOS=linux go build -o bin/main cmd/vpnbeast-service/main.go
	zip -jrm bin/main-$(VERSION).zip bin/main

.PHONY: aws-upload
aws-upload: aws-build
	aws lambda update-function-code --function-name vpnbeast-service --zip-file fileb://bin/main.zip

.PHONY: aws-publish
aws-publish: aws-build
	aws lambda update-function-code --function-name vpnbeast-service --zip-file fileb://bin/main.zip --publish

.PHONY: sam-build
sam-build:
	sam build

.PHONY: sam-validate
sam-validate:
	sam validate

.PHONY: sam-local-invoke
sam-local-invoke:
	sam local invoke

.PHONY: sam-cloud-invoke
sam-cloud-invoke:
	sam sync --stack-name $(AWS_STACK_NAME) --watch

.PHONY: sam-deploy
sam-deploy: sam-build
	sam deploy --no-confirm-changeset --no-fail-on-empty-changeset --stack-name $(AWS_STACK_NAME) --s3-bucket $(AWS_RELEASES_BUCKET) --capabilities $(AWS_IAM_CAPABILITIES) --region $(AWS_REGION)

.PHONY: sam-publish
sam-publish: sam-build sam-deploy
	sam publish --region $(AWS_REGION) --semantic-version 1.0.1

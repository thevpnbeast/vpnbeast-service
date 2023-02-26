package main

import (
	"github.com/aws/aws-lambda-go/lambda"
	commons "github.com/thevpnbeast/golang-commons"
	"github.com/thevpnbeast/vpnbeast-service/internal/web"
	"go.uber.org/zap"
)

var (
	logger *zap.Logger
)

func init() {
	logger = commons.GetLogger()
}

func main() {
	defer func() {
		err := logger.Sync()
		if err != nil {
			panic(err)
		}
	}()

	lambda.Start(web.HandleRequests)
}

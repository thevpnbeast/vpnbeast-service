package web

import (
	"fmt"

	"github.com/aws/aws-lambda-go/events"
	commons "github.com/thevpnbeast/golang-commons"
	"go.uber.org/zap"
)

var logger *zap.Logger

func init() {
	logger = commons.GetLogger()
}

func HandleRequests(e events.APIGatewayProxyRequest) (*events.APIGatewayProxyResponse, error) {
	logger.Info("request received", zap.String("path", e.Path))
	fmt.Println(e)
	switch e.Path {
	case "/v1/hello":
		return helloEventHandler(e)
	case "/v1/ping":
		return pingEventHandler(e)
	default:
		return unhandledEventHandler()
	}
}

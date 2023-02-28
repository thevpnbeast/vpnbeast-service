package web

import (
	"log"

	"github.com/aws/aws-lambda-go/events"
)

func HandleRequests(e events.APIGatewayProxyRequest) (*events.APIGatewayProxyResponse, error) {
	switch e.Path {
	case "/v1/hello":
		log.Println("EVENT: request received for endpoint /v1/hello")
		return helloEventHandler(e)
	case "/v1/ping":
		log.Println("EVENT: request received for endpoint /v1/ping")
		return pingEventHandler()
	default:
		return unhandledEventHandler()
	}
}

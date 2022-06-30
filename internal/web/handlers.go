package web

import (
	"encoding/json"
	"fmt"
	"net/http"

	"github.com/aws/aws-lambda-go/events"
)

func unhandledEventHandler() (*events.APIGatewayProxyResponse, error) {
	return apiResponse(http.StatusMethodNotAllowed, ErrMethodNotAllowed)
}

func helloEventHandler(req events.APIGatewayProxyRequest) (*events.APIGatewayProxyResponse, error) {
	var request HelloRequest
	if err := json.Unmarshal([]byte(req.Body), &request); err != nil {
		return apiResponse(http.StatusBadRequest, ErrorBody{"failed to parse json body"})
	}

	return apiResponse(http.StatusOK, Response{Status: true, Message: fmt.Sprintf("hello %s", request.PlainText)})
}

func pingEventHandler(req events.APIGatewayProxyRequest) (*events.APIGatewayProxyResponse, error) {
	return apiResponse(http.StatusOK, Response{Status: true, Message: "pong"})
}

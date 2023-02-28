package main

import (
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/thevpnbeast/vpnbeast-service/internal/web"
)

func main() {
	lambda.Start(web.HandleRequests)
}

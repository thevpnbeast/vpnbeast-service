package main

import (
	"github.com/thevpnbeast/vpnbeast-service/src/internal/web"

	"github.com/aws/aws-lambda-go/lambda"
)

func main() {
	lambda.Start(web.HandleRequests)
}

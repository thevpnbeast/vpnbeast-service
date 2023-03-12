package main

import (
	"fmt"

	"github.com/thevpnbeast/vpnbeast-service/src/internal/web"

	"github.com/aws/aws-lambda-go/lambda"
)

func main() {
	fmt.Println("hello world")
	fmt.Println("hello world")
	lambda.Start(web.HandleRequests)
}

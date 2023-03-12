package main

import (
	"fmt"

	"github.com/aws/aws-lambda-go/lambda"
	"github.com/thevpnbeast/vpnbeast-service/src/internal/web"
)

func main() {
	fmt.Println("hello world")
	fmt.Println("hello world")
	lambda.Start(web.HandleRequests)
}

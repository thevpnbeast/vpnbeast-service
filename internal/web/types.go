package web

const (
	ErrMethodNotAllowed = "method Not allowed"
)

type Response struct {
	Status  bool   `json:"status"`
	Message string `json:"message"`
}

type HelloRequest struct {
	PlainText string `json:"plainText"`
}

type ErrorBody struct {
	ErrorMsg string `json:"error,omitempty"`
}

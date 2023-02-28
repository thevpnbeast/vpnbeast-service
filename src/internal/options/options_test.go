package options

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestGetVpnbeastServiceOptions(t *testing.T) {
	opts := GetVpnbeastServiceOptions()
	assert.NotNil(t, opts)
}

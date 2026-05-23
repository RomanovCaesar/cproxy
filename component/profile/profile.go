package profile

import (
	"github.com/RomanovCaesar/cproxy/common/atomic"
)

// StoreSelected is a global switch for storing selected proxy to cache
var StoreSelected = atomic.NewBool(true)

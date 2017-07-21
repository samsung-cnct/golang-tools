package main

import (
	"testing"
)

func TestGenerateUUID(test *testing.T) {

	count := 5

	parts := generate_uuids(count)

	if len(parts) != count {
		test.Errorf("Did not generate expected number of results (%d), actual (%d)", count, len(parts))
	}

}

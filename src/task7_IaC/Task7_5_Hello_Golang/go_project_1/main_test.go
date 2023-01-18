package main

import (
	"testing"
)

func TestGetNumbers(t *testing.T) {
	foot := changeMetersToFoot(1)
	if foot != 0.3048 {
		t.Fatalf("Error in method changeMetersToFoot. \nExpected: 0.3048\nActual %f", foot)
	}
}

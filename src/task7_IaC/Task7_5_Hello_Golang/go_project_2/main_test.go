package main

import (
	"testing"
)

func TestGetNumbers(t *testing.T) {
	testArr := []int{48, 96, 86, 68, 57, 82, 63, 70, 37, 34, 83, 27, 19, 97, 9, 17}
	min := getMin(testArr)
	if min != 9 {
		t.Fatalf("Error in method getMin. \nExpected: 9\nActual %d", min)
	}
}

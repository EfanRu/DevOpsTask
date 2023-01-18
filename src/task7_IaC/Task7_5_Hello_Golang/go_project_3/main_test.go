package test

import (
	"reflect"
	"testing"
)

func TestGetNumbers(t *testing.T) {
	testNum := 3
	expectedArr := []int{3, 6, 9, 12, 15, 18, 21, 24, 27, 30, 33, 36, 39, 42, 45, 48, 51, 54, 57, 60, 63, 66, 69, 72, 75, 78, 81, 84, 87, 90, 93, 96, 99}
	actualArr := getNumbers(testNum)
	if !reflect.DeepEqual(actualArr, expectedArr) {
		t.Fatalf("Error in method getNumbers with number: %d", testNum)
	}
}

package main

import "fmt"

func main() {
	x := []int{48, 96, 86, 68, 57, 82, 63, 70, 37, 34, 83, 27, 19, 97, 9, 17}
	fmt.Println(getMin(x))
}

func getMin(arr []int) int {
	var min int
	for i, i2 := range arr {
		if i == 0 || min > i2 {
			min = i2
		}
	}
	return min
}

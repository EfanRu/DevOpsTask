package main

import "fmt"

func main() {
	fmt.Println(getNumbers(3))
}

func getNumbers(x int) []int {
	var arr []int
	for i := 1; i < 100; i++ {
		if i%x == 0 {
			arr = append(arr, i)
		}
	}
	return arr
}

package main

import "fmt"

func main() {
	var input float32

	fmt.Print("Program for change meters in foot.\n")
	fmt.Print("Enter meters: ")
	fmt.Scanf("%f", &input)
	fmt.Printf("%f meters in foot is %f\n", input, changeMetersToFoot(input))
}

func changeMetersToFoot(meters float32) float32 {
	return meters * 0.3048
}

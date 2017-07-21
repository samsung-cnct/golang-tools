package main

import (
	"fmt"

	uuid "github.com/satori/go.uuid"
)

func generate_uuids(howmany int) []string {
	var result []string
	for i := 0; i < howmany; i++ {
		result = append(result, uuid.NewV4().String())
	}
	return result
}

func main() {

	for _, u := range generate_uuids(5) {
		fmt.Printf("Generated UUID: %s\n", u)
	}

}

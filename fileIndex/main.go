// fileIndex looks through the files in a directory and
// indicates position of the given file.
// "How many have I edited, and how many more to go?"

package main

import (
	"flag"
	"fmt"
	"math"
	"os"
)

func main() {
	dirName := flag.String("d", ".", "Directory to search")
	fileName := flag.String("f", "", "File to look for")
	// Hmmm what if I used time.Data or something, so it could calcuate?
	days := flag.Int("days", 1, "Days left to finish")
	flag.Parse()
	if len(*fileName) < 1 {
		fmt.Println("A filename is needed")
		os.Exit(0)
	}
	// This hits directories as well. Need to fix that.
	files, err := os.ReadDir(*dirName)
	if err != nil {
		panic(err)
	}
	index := -1
	for i, file := range files {
		if file.Name() == *fileName {
			index = i + 1
		}
	}

	if index < 1 {
		fmt.Printf("%s not found\n", *fileName)
	} else {
		mustAverage := int(math.Ceil(float64((len(files) - index)) / float64(*days)))
		fmt.Printf("File is %d of %d; %d left", index, len(files), len(files)-index)
		if *days > 1 {
			fmt.Printf(" and must average %d per day.\n", mustAverage)
		} else {
			fmt.Println(".")
		}
	}
	os.Exit(0)
}

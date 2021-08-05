# fdir - a 4DOS Dir command recreation in Swift

## What?

In the old days of MSDOS existed a shell replacement called [4DOS](https://www.4dos.info/). One of the best features was the ability to annotate files and folders with comments, so while listing a directory wth `dir` you could see directly there what a folder contained.

The idea is simple: you have a text file called `descript.ion` with the names of all files & folders. You can then add a description to each one that will be listed to the right of the file name. A simple way to catalog and know what's inside your directories!

## How to install

You need:
- macOS (or maybe Linux + Swift, haven't tried)
- Xcode 13

Clone this repo:
```
git clone
```

Then, open Xcode. In the scheme fdir there's a Build Post-Action copying the binary to a folder. Change it to suit your setup.

Build. 

Done. 

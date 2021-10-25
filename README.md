# fdir - a 4DOS Dir command recreation in Swift

## What?

In the old days of MSDOS existed a shell replacement called [4DOS](https://www.4dos.info/). One of the best features was the ability to annotate files and folders with comments, so while listing a directory wth `dir` you could see directly there what a folder contained.

The idea is simple: you have a text file called `descript.ion` with the names of all files & folders. You can then add a description to each one that will be listed to the right of the file name. A simple way to catalog and know what's inside your directories!

## An Example, please?

Sure, you'll go from this:

```bash
$ ls -l
total 16
drwx------@  3 dfreniche  staff    96 Sep 17 18:00 Applications
drwxr-xr-x  29 dfreniche  staff   928 Oct 20 16:55 Code
drwx------@ 16 dfreniche  staff   512 Oct 25 12:09 Desktop
drwx------+ 13 dfreniche  staff   416 Oct  6 08:48 Documents
drwx------@ 45 dfreniche  staff  1440 Oct 25 12:30 Downloads
lrwx------   1 dfreniche  staff    20 Oct 22 09:03 Google Drive -> /Volumes/GoogleDrive
drwx------@ 82 dfreniche  staff  2624 Sep 22 13:01 Library
drwx------+  4 dfreniche  staff   128 May 10 16:46 Movies
drwx------+  6 dfreniche  staff   192 Aug 27 16:43 Music
drwx------+  5 dfreniche  staff   160 May 31 16:56 Pictures
drwxr-xr-x+  4 dfreniche  staff   128 May 10 16:16 Public
-rw-r--r--@  1 dfreniche  staff  5652 Aug  6 16:33 common-aliases-bash-zsh.sh
drwxr-xr-x  15 dfreniche  staff   480 Oct  4 12:00 scripts
drwxr-xr-x@ 22 dfreniche  staff   704 May 18 10:04 zsh-autosuggestions
```

to this:

```bash
$ fdir
fdir - [13] folders, [1] files
[D] Applications               : all my Apps outside of /Applications
[D] Code                       : here is my code
[D] Desktop                    : my Desktop. Keep it clean
[D] Documents                  : Documents, although everything should be in Google Drive
[D] Downloads                  : Cleaned from time to time, don't leave important stuff here!
[D] Google Drive               : Work files
[D] Library                    : Config files for everything
[D] Movies                     : Presentations and Talks being edited
[D] Music                      : No music, just UNICODE U00D1 Podcast
[D] Pictures                   : Well, images
[D] Public                     : Publicly shared folder from macOS
[D] scripts                    : my scripts
[D] zsh-autosuggestions        : for ZSH plugins
```

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

## How to use it

### Get help

```
fdir --help

USAGE: fdir [--init] [--update] [--edit] [--all]

OPTIONS:
  -i, --init              Creates a new hidden .descript.ion file
  -u, --update            Updates existing .descript.ion file with contents of folder
  -e, --edit              Opens existing .descript.ion file with VS Code
  -a, --all               Includes all files
  -h, --help              Show help information.
```

### Create a new .descript.ion file

```
fdir --init
```
This creates a new `.descript.ion` file with all files and folders in current directory. If a `.descript.ion` file already exists, ask before overwriting.

Once you have the `.descript.ion` you can open it with your favorite editor and add any descriptions you like

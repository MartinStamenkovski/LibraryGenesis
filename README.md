# LibraryGenesis-iOS

This application is showing books from [Library Genesis](https://libgen.is).

## Features

- [x] Search books with title, author, etc ...
- [x] List latest books.
- [x] Preview book.
- [x] Download book from available mirrors.

**To download book you need to open mirror link in browser, because I didn't find way to construct the download link.**

## Installation 
Clone the github repo, open the app in Xcode and run it of course.

## Remarks
There is no official API for [Library Genesis](https://libgen.is), you need to parse the html and extract the IDs of the books, then you can make request to the available API, example:
```
http://gen.lib.rus.ec/json.php?ids=2490856, 2490855, 2490854&fields=*
```
More information can be found [here](http://garbage.world/posts/libgen/)

## How to download?
After you open the mirror link in Safari for example, there will be a button on top of the page as **GET**, press it and the download should start.

## Note
This is not an e-book reader, to read downloaded books you will need an additional epub/pdf reader application. 

*Maybe in future updates it will support reading epub/pdf files*

## Legal
I don't own anything, just showing the content from [Library Genesis](https://libgen.is), all rights goes to the respective authors/owners.

## License
[MIT](https://github.com/MartinStamenkovski/LibraryGenesis-iOS/blob/master/LICENSE)


## [Strategies](https://github.com/warren-bank/remove-it-ebooks-pdf-watermark/tree/strategies)

1. [remove all](https://github.com/warren-bank/remove-it-ebooks-pdf-watermark/tree/strategy/1-remove-all-obj)
  * remove all `XX YY obj` .. `endobj` that contain the string: `www.it-ebooks.info`
  * pros:
    * works
  * cons:
    * removes some large blocks of pdf meta-data (ie: title, author, etc)
2. [remove selective](https://github.com/warren-bank/remove-it-ebooks-pdf-watermark/tree/strategy/2-remove-selective-obj)
  * remove selective `XX YY obj` .. `endobj` that contain either the string: `(www.it-ebooks.info)` or `(http://www.it-ebooks.info/)`
  * pros:
    * works
  * cons:
    * none
    * This is probably the best solution. It removes all watermarks and links, but leaves the meta-data alone. As such, the meta-data will contain a few mentions of `www.it-ebooks.info`, but they won't be visible to a reader.
3. [replace selective with empty](https://github.com/warren-bank/remove-it-ebooks-pdf-watermark/tree/strategy/3-replace-selective-obj-with-empty-obj)
  * replace selective `XX YY obj` .. `endobj` that contain either the string: `(www.it-ebooks.info)` or `(http://www.it-ebooks.info/)`
  * remove the content (ie: `..`) but leave the `obj` declaration
  * pros:
    * works
  * cons:
    * larger pdf file
  * notes:
    * I went down this rabbit hole because (at the time) the version in branch `2-remove-selective-obj` was producing a pdf that didn't display properly in my viewer.
    * Initially, I thought the problem was that the `obj` blocks were somehow needed for proper layout purposes.
    * Eventually, the problem traced back to not using `binmode` for the output file on a Windows system.
    * As such, this branch and all subsequent branches are unnecessary. However, I didn't want to completely discard the work.. so the strategies are included for completeness sake.
4. [replace selective with 0-length stream](https://github.com/warren-bank/remove-it-ebooks-pdf-watermark/tree/strategy/4-replace-selective-obj-with-empty-obj-and-zero-length-stream)
  * replace selective `XX YY obj` .. `endobj` that contain either the string: `(www.it-ebooks.info)` or `(http://www.it-ebooks.info/)`
  * replace the content (ie: `..`) with a hard-coded zero-length stream: `<< /Length 0 /LC /QQAP >> stream endstream`
  * pros:
    * works
  * cons:
    * larger pdf file
5. [replace selective with same-length streams](https://github.com/warren-bank/remove-it-ebooks-pdf-watermark/tree/strategy/5-replace-selective-obj-with-empty-obj-and-same-length-streams)
  * replace selective `XX YY obj` .. `endobj` that contain either the string: `(www.it-ebooks.info)` or `(http://www.it-ebooks.info/)`
  * replace each original stream `<< /Length XX /LC /QQAP >> stream .. endstream` with an empty stream having the same length. (ie: remove `..` but leave the rest alone).
  * pros:
    * works
  * cons:
    * larger pdf file
  * notes:
    * Honestly, I have no idea if this is even valid according to the PDF spec. At the time, it was worth a shot.

## Summary:

* The strategy in branch [2](https://github.com/warren-bank/remove-it-ebooks-pdf-watermark/tree/strategy/2-remove-selective-obj) is the winner

## Notes:

* These are perl scripts.
* To run: `perl filter.pl`
* These initial "proof-of-concept" implementations don't accept any command-line options.
  They assume that:
  * the input file is: `./in.pdf`
  * the output file is: `./out.pdf`

## To-Do:

* Add a [master](https://github.com/warren-bank/remove-it-ebooks-pdf-watermark/tree/master) branch with a version of the script that's based on branch [2](https://github.com/warren-bank/remove-it-ebooks-pdf-watermark/tree/strategy/2-remove-selective-obj), but accepts command-line options.

## Additional Notes

* After running a PDF file through (version [2](https://github.com/warren-bank/remove-it-ebooks-pdf-watermark/tree/strategy/2-remove-selective-obj) of) the perl script:
  * a PDF viewer (ex: [_"PDF-XChange Viewer"_](http://portableapps.com/apps/office/pdf-xchange-portable)) should report that:

    ```
    This document "out.pdf" has errors.
    
    Some problems were detected by application:
    - One or more XREF chunks were not found.
    
    It is recommended you re-save this document.
    ```
* After following the recommendation given by the viewer and resaving the PDF document (ie: `File > Save As..`):
  * all of the PDF's internal references to the removed `obj` blocks are cleaned out
  * the file size is farther reduce by a significant amount
  * the file won't generate any errors when opened in a PDF viewer

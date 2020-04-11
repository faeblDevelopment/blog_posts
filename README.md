This repo is the source of a couple of blog posts.
The compilable versions of the posts are the literate Haskell files
in the root of the repo.

The mdfiles folder contains the corresponding markdown files for reading on github 
or another website with markdown rendering capabilities. 
As it is always a drag to compile markdown with ghc especially if git flavoured
md and html is used inside the document I  wrote `lhs_converter.hs`
This nifty little tool comverts `md` files to compileable `lhs` by stripping away
the heading tags `#`, replacing them with the corresponding html tags, and 
converting the `''' haskell [...] '''` to `> [...]` as recognised by the 
GHC literate prepocessor.
`''' [...] '''` will be converted to `< [...]` and will be discarded by ghc
but still be displayed as code when rendered.
(In both cases `'''` is actually the three md backticks, but its a pain to 
write md about md ^^

to use `lhs_converter.hs` (either use `runhaskell` or compile it of course) supply
it wit the following arguments:

`lhs_comverter toLhs file1 file2 ...`
or
`lhs_converter toMd file1 file2 ...`

the commands are not case sensitive;
The program will convert each file from the other format to the specified one,
creating the files
`file1.md file2.md ...` or `file1.lhs file2.lhs ...`
in the same directory respectively.

the code is not yet the most beautiful or efficient and not tested with 100 documents,
it is just a tool i needed fast and serves its purpose (though pretty well actually ^^)
but I'll keep working on it when the need arises...
have fun with it ;)

This repo is the source of a couple of blog posts.
The compilable versions of the posts are the literate Haskell files
in the root of the repo.

The mdfiles folder contains the corresponding markdown files for reading on github 
or another website with markdown rendering capabilities. 
As it is always a drag to compile markdown with ghc especially if git flavoured
md and html is used inside the document I  wrote [`lhsc`](https://hackage.haskell.org/package/LiterateMarkdown-0.1.0.0)
This nifty little tool comverts `md` files to compileable `lhs` and vice versa;
for more information on how you can use it with these blog posts, visit hackage ;)

# About this site

This site uses MkDocs and is served by GitHub.

### To edit

```bash
$ git clone git@github.com:WireCell/wire-cell-docs.git
$ cd wire-cell-docs
$ emacs 
$ git commit -a -m "..."
$ git push
```

### To preview

```bash
$ mkdocs server
INFO    -  Building documentation... 
[I 150708 17:57:26 server:271] Serving on http://127.0.0.1:8000
[I 150708 17:57:26 handlers:58] Start watching changes
[I 150708 17:57:26 handlers:60] Start detecting changes
```

Click on the link to view the result in your browser.  As you continue
to edit the server should notice the change, regenerate and trigger
your browser to refresh.

### To deploy

```bash
$ mkdocs gh-deploy --clean
```

After a brief moment this will update [the main docs site](http://bnlif.github.io/wire-cell-docs/).

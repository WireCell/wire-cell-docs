[TOC]

Here is what you will do in the act of developing code.

# Build Dancing

To rebuild after hacking on the source just type:

```bash
$ waf
```

When ready to install into the configured “prefix” installation area:

```bash
$ waf install
```

To force a full rebuild:

```bash
$ waf clean build
```

To limit building to just one submodule:

```bash
$ cd <subdir>/
$ waf
```

# Debug

To build for debugging one needs to reconfigure waf with a `--build-debug=<flags>` option and then the project must be cleaned and rebuilt. This can be done all at once like:

```bash
$ waf --prefix=/path/to/install --build-debug=-ggdb3 clean configure build install
```

You may also want to see what commands Waf is actually running to confirm this option is transmitted, just add a `-v` to the command line:

```bash
$ waf -v
```

Finally, run GDB in your usual, preferred manner:

```bash
$ gdb --args /home/bviren/projects/wire-cell/top/build/nav/test_geomdatasource
(gdb) run
```

# New packages

New wire-cell packages can be added easily.

## Considerations

Wire Cell packages are organized to be easy to create. It's much better to create many small packages and maybe later merge them than it is to split apart ones which have grown too monolithic. When thinking about writing some code consider

* What other packages will I need?
* What future packages will need mine?

You may have an idea for a package but in reality it is better split up into others. Here are reasons to believe your ideas fit into multiple packages:

* When I describe my expected package functionality I use the word "and".
* Some other package should use part of my package but the other part is not needed.

If in doubt, make more, smaller packages.

## Source Package Conventions

To make them easy to build and aggregate they must follow a layout convention.

First, each source package should be kept in it's own git repository. The recommended package naming convention is:

```
wire-cell-NAME
```
where `NAME` is some short identifier of the package's primary purpose.

The contents of the source package must be organized following these sub-directory conventions

```bash
src/             # C++ source file for libraries with .cxx extensions or private headers
inc/NAME/        # public/API C++ header files with .h extensions
dict/LinkDef.h   # ROOT linkdef header (for rootcling dictionaries)
tests/           # Unit tests Python (nosetests) files like test_*.py or main C++ programs named like test_*.cxx.
apps/            # main application(s), one appname.cxx file for each app named appname (todo: not yet supported)
python/NAME      # python modules (todo: not yet supported)
wscript_build    # a brief waf file
```
The `wscript_build` file specifies a name for the binary package (in general similar but not identical to the source package name) and a list of any other packages part of the wire-cell system on which it depends. For example the `wire-cell-nav` source package builds to a `WireCellNav` binary package and it depends on the WireCellData package and so its `wscript_build` file is:
```
bld.make_package('WireCellNav', use='WireCellData')
```
This is Python and the `bld` object is a Waf build context. It is provided automagically when waf interprets this file.

## Build packages

The above is about code packages. Code packages are built via a build package. This build package, `wire-cell` is but one possible "view" into all the wire cell packages. Other build packages may be created which only build some sub-set of all wire cell packages.

To add a new code package to a build package (such as this one) one must do a little, annoying dance:
```
$ mkdir <name>
$ cd <name>/
$ echo "bld.make_package('WireCell<Name>', use='WireCellNav WireCellData')" > wscript_build
$ git init
$ git commit -a -m "Start code package <name>"
```

Replace `<name>` with your package name. And, of course, you may want to put more code than just the `wscript_build` file. Also, that file should list what packages your package depends on.

Now, make a new repository by going to the [BNLIF GitHub](https://github.com/BNLIF) and clicking "New repository" button. Give it a name like `wire-cell-<name>`. Copy-and-paste the two command it tells you to use:

```bash
$ git remote add origin git@github.com:BNLIF/wire-cell-<name>.git
$ git push -u origin master
```
Finally, move aside the local repository and add it right back as a submodule:

```bash
$ cd ..  # back to top
$ mv <name> <name>.moved
$ git submodule add -- git@github.com:BNLIF/wire-cell-<name>.git <name>
$ git submodule update
$ git commit -a -m "Added <name> to top-level build package."
$ git push
```
Whew!

# Namespaces

The namespace WireCell is used for all "core" wire cell code. Code that is used to glue this core functionality into other systems may use another namespace but should not use WireCell. For example, the "simple simulation tree" uses `WireCellSst`.

It can be tedious to type explicit namespace qualifiers all the time. You can use the using namespace WireCell; directive where in implementation files (*.cxx) but you should never use it in (top-scope) of header files as it will then leak the contents of the namespace into any unsuspecting file that #include’s it.


# Dealing with git submodules

From [the git book](http://git-scm.com/book/en/v2/Git-Tools-Submodules#Working-on-a-Project-with-Submodules), do you updates like:

    $ git submodule update --remote --rebase

or like

    $ git submodule update --remote --merge

With:

-   **`--rebase`:** put our local commits on top of any new ones

-   **`--merge`:** merge our commits into new ones

The first leaves a more "linear" commit history while the second leaves
"diamonds" in the history whenever we have briefly diverged from the
remote repository.  You can run "`gitk --all`" in wire-cell or one of the
submodules to see what I mean.  Either way is fine.  Rebasing looks
cleaner in the history but merge captures the subtle fact of where our
line of development actually diverged.

In that link there are other interesting things to do:

-   Configure your repository so "`git status`" in the top-level "wire-cell" gives us more info on the status of all submodules:

    `$ git config status.submodulesummary 1`

-   Make it so "`git diff`" in wire-cell will also show any diff's in the submodules:

    `$ git config diff.submodule log`

-   To check that we will push in the right order (submodules first):

    `$ git push --recurse-submodules=check`

-   To force submodules to push first

    `$ git push --recurse-submodules=on-demand`

-   To run any command in all submodules

    `$ git submodule foreach 'the command'`


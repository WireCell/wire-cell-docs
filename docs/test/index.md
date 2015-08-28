<div id="table-of-contents">
<h2>Table of Contents</h2>
<div id="text-table-of-contents">
<ul>
<li><a href="#sec-1">1. Prerequisites</a>
<ul>
<li><a href="#sec-1-1">1.1. Automated installation</a></li>
<li><a href="#sec-1-2">1.2. Manual installation</a></li>
</ul>
</li>
<li><a href="#sec-2">2. Building</a>
<ul>
<li><a href="#sec-2-1">2.1. Preparing the source</a></li>
<li><a href="#sec-2-2">2.2. Building</a></li>
</ul>
</li>
<li><a href="#sec-3">3. Developing</a>
<ul>
<li><a href="#sec-3-1">3.1. Build Dancing</a></li>
<li><a href="#sec-3-2">3.2. Debug</a></li>
<li><a href="#sec-3-3">3.3. New packages</a>
<ul>
<li><a href="#sec-3-3-1">3.3.1. Considerations</a></li>
<li><a href="#sec-3-3-2">3.3.2. Source Package Conventions.</a></li>
<li><a href="#sec-3-3-3">3.3.3. Build packages</a></li>
<li><a href="#sec-3-3-4">3.3.4. Namespaces</a></li>
<li><a href="#sec-3-3-5">3.3.5. Tests</a></li>
</ul>
</li>
<li><a href="#sec-3-4">3.4. Dealing with git submodules</a></li>
</ul>
</li>
</ul>
</div>
</div>


# Prerequisites<a id="sec-1" name="sec-1"></a>

Some external packages are required as described in this section.  

## Automated installation<a id="sec-1-1" name="sec-1-1"></a>

It is recommended to use the automated installation method to install the required externals.  Follow the directions in [wire-cell-externals](https://github.com/WireCell/wire-cell-externals) and come back here after setting up your user environment.

## Manual installation<a id="sec-1-2" name="sec-1-2"></a>

You may provide the external packages yourself.  The definitive list of required packages, their versions and build details are kept in wire-cell-externals [worch.cfg](https://github.com/WireCell/wire-cell-externals/blob/master/worch.cfg) file.  Refer to that for the most up-to-date information on what software is needed.  In summary you will need:

-   ROOT v6
-   Python 2.7
-   BOOST 1.55 (or equiv)

You will need to set up your run-time environment so that these commands do not fail and give the expected version:

    $ root -b -q
    ...
    | Welcome to ROOT 6.02/05                http://root.cern.ch |
    ...
    $ python -c 'import ROOT; print ROOT.gROOT.GetVersion()'
    6.02/05

# Building<a id="sec-2" name="sec-2"></a>

## Preparing the source<a id="sec-2-1" name="sec-2-1"></a>

The wire cell source project uses `git-submodules` to bring all the source together:

    $ git clone git@github.com:WireCell/wire-cell.git
    $ cd wire-cell
    $ git submodule init
    $ git submodule update
    
    $ alias waf=`pwd`/waf-tools/waf

## Building<a id="sec-2-2" name="sec-2-2"></a>

To configure, build and install the wire cell code do:

    $ waf --prefix=/path/to/install configure build install

Note: this is not a Worch build - there is no `--orch-config` option.

If you followed the [single rooted install](https://github.com/WireCell/wire-cell-externals#single-rooted-install) pattern then the `/path/to/install` can be `/path/to/single-rooted` and no additional user environment will be needed for run-time and the following command line should succeed:

    $ python -c 'import ROOT; print ROOT.WireCellData'
    Warning in <TInterpreter::ReadRootmapFile>: class  pair<float,float> found in libCore.so  is already in libWireCellDataDict.so 
    Warning in <TInterpreter::ReadRootmapFile>: class  pair<int,float> found in libCore.so  is already in libWireCellDataDict.so 
    <class 'ROOT.WireCellData'>

If you provided your own externals or used the name/version tree pattern (using environment modules) then you will need to set your environment properly.  Besides the usual `$PATH`, `$LD_LIBRARY_PATH`, etc pointing at `/path/to/install` you may need to set `PYTHONPATH`.  

Independent from how you installed the code, if you have the broken
ROOT packages for Ubuntu installed you will have to set:

    $ export PYTHONNOUSERSITE=yes

# Developing<a id="sec-3" name="sec-3"></a>

Here is what you will do in the act of developing code.

## Build Dancing<a id="sec-3-1" name="sec-3-1"></a>

To rebuild after hacking on the source just type:

    $ waf

When ready to install into the configured "prefix" installation area:

    $ waf install

To force a full rebuild:

    $ waf clean build

To limit building to just one submodule:

    $ cd <subdir>/
    $ waf

## Debug<a id="sec-3-2" name="sec-3-2"></a>

To build for debugging one needs to reconfigure waf with a `--build-debug=<flags>` option and then the project must be cleaned and rebuilt.  This can be done all at once like:

    $ waf --prefix=/path/to/install --build-debug=-ggdb3 clean configure build install

You may also want to see what commands Waf is actually running to confirm this option is transmitted, just add a "`-v`" to the command line:

    $ waf -v

Finally, run GDB in your usual, preferred manner:

    $ gdb --args /home/bviren/projects/wire-cell/top/build/nav/test_geomdatasource
    (gdb) run

## New packages<a id="sec-3-3" name="sec-3-3"></a>

New wire-cell packages can be added easily.

### Considerations<a id="sec-3-3-1" name="sec-3-3-1"></a>

Wire Cell packages are organized to be easy to create.  It's much better to create many small packages and maybe later merge them than it is to split apart ones which have grown too monolithic.  When thinking about writing some code consider:

-   What other packages will I need?
-   What future packages will need mine?

You may have an idea for a package but in reality it is better split up into others.  Here are reasons to believe your ideas fit into multiple packages:

-   When I describe my expected package functionality I use the word "and".

-   Some other package should use part of my package but the other part is not needed.

If in doubt, make more, smaller packages.

### Source Package Conventions.<a id="sec-3-3-2" name="sec-3-3-2"></a>

To make them easy to build and aggregate they must follow a layout convention.  

First, each source package should be kept in it's own git repository.  The recommended package naming convention is:

    wire-cell-NAME

where "`NAME`" is some short identifier of the package's primary purpose.

The contents of the source package must be organized following these sub-directory conventions:

-   **`src/`:** C++ source file for libraries with `.cxx` extensions or private headers
-   **`inc/NAME/`:** public/API C++ header files with `.h` extensions
-   **`dict/LinkDef.h`:** ROOT linkdef header (for `rootcling` dictionaries)
-   **`tests/`:** Unit tests Python (nosetests) files like `test_*.py` or main C++ programs named like `test_*.cxx`.
-   **`apps/`:** main application(s), one `appname.cxx` file for each app named appname (todo: not yet supported)
-   **`python/NAME`:** python modules (todo: not yet supported)
-   **`wscript_build`:** a brief waf file

The `wscript_build` file specifies a name for the binary package (in general similar but not identical to the source package name) and a list of any other packages part of the wire-cell system on which it depends.  For example the `wire-cell-nav` source package builds to a `WireCellNav` binary package and it depends on the `WireCellData` package and so its [`wscript_build`](https://github.com/WireCell/wire-cell-nav/blob/master/wscript_build) file is:

    bld.make_package('WireCellNav', use='WireCellData')

This is Python and the `bld` object is a Waf build context.  It is provided automagically when waf interprets this file.

### Build packages<a id="sec-3-3-3" name="sec-3-3-3"></a>

The above is about code packages.  Code packages are built via a build package.  This build package, `wire-cell` is but one possible "view" into all the wire cell packages.  Other build packages may be created which only build some sub-set of all wire cell packages.

To add a new code package to a build package (such as this one) one must do a little, annoying dance:

    $ mkdir <name>
    $ cd <name>/
    $ echo "bld.make_package('WireCell<Name>', use='WireCellNav WireCellData')" > wscript_build
    $ git init
    $ git commit -a -m "Start code package <name>"

Replace "`<name>`" with your package name.  And, of course, you may want to put more code than just the `wscript_build` file. Also, that file should list what packages your package depends on.

Now, make a new repository by going to the [WireCell GitHub](https://github.com/WireCell) and clicking "New repository" button.  Give it a name like `wire-cell-<name>`.  Copy-and-paste the two command it tells you to use:

    $ git remote add origin git@github.com:WireCell/wire-cell-<name>.git
    $ git push -u origin master

Finally, move aside the local repository and add it right back as a submodule:

    $ cd ..  # back to top
    $ mv <name> <name>.moved
    $ git submodule add -- git@github.com:WireCell/wire-cell-<name>.git <name>
    $ git submodule update
    $ git commit -a -m "Added <name> to top-level build package."
    $ git push

Whew!

### Namespaces<a id="sec-3-3-4" name="sec-3-3-4"></a>

The namespace `WireCell` is used for all "core" wire cell code.  Code that is used to glue this core functionality into other systems may use another namespace but should not use `WireCell`.  For example, the "simple simulation tree" uses =WireCellSst".

It can be tedious to type explicit namespace qualifiers all the time.  You can use the `using namespace WireCell;`  directive where in implementation files (`*.cxx`) but you should **never** use it in (top-scope) of header files as it will then leak the contents of the namespace into any unsuspecting file that `#include`'s it.

### Tests<a id="sec-3-3-5" name="sec-3-3-5"></a>

Tests go under the `test/` (or `tests/`) sub-directory of the package.  There are two types, C++ and Python.  In both cases, only files that begin with "`test_*`" will be considered tests.  Tests are automatically run as part of the build procedure (fixme: just C++ ones are automatic right now) and will be rerun when they or code they depend on changes.   When tests are run by the build the `stdout/stderr` is typically captured.  You can run them manually to observe any print statements.  Tests are not installed but left in the "`build/`" (or sometimes "`tmp/`") output directory.

Here are a few general guidelines for writing tests:

-   write many tests
-   write tests as fine grained as convenient
-   the best tests are written before or while the code they test is being written
-   test code does need not be "pretty", it will never be called from anywhere else
-   tests should run quickly
-   do use contrived data or mocked code to provide a bit of test code it's needed input or code support

1.  C++ tests

    Writing a C++ test is to write a `main()` program which takes **no arguments**.  If a test fails, either let it crash the test program or call `exit(1)`.
    
    You can explicitly run C++ test programs.  When they are run as part of the build, their full path is printed.  When run automatically, waf takes care of setting up their environment so that their libraries are found.  When run manually you will have to assure this.  The simplest way is to "`waf install`" the package first.
    
        $ waf
        ...
        execution summary 
          tests that pass 3/4 
            /home/bviren/projects/wire-cell/top/build/data/test_construct 
            /home/bviren/projects/wire-cell/top/build/nav/test_geomdatasource 
            /home/bviren/projects/wire-cell/top/build/sst/test_sst_geomdatasource 
          tests that fail 1/4 
            /home/bviren/projects/wire-cell/top/build/data/test_fail 
        'build' finished successfully (1.594s)
        
        $ waf install
        $ /home/bviren/projects/wire-cell/top/build/sst/test_sst_geomdatasource 
        Wire: 0 plane=1 index=0
        Wire: 0 plane=1 index=1
        Wire: 0 plane=1 index=2
        ...

## Dealing with git submodules<a id="sec-3-4" name="sec-3-4"></a>

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

-   Configure your repository so "`git status`" in the top-level

"wire-cell" gives us more info on the status of all submodules:

    $ git config status.submodulesummary 1

-   Make it so "`git diff`" in wire-cell will also show any diff's in the

submodules:

    $ git config diff.submodule log

-   To check that we will push in the right order (submodules first):

    $ git push --recurse-submodules=check

-   To force submodules to push first

    $ git push --recurse-submodules=on-demand

-   To run any command in all submodules

    $ git submodule foreach 'the command'

[TOC]

# Installation of prerequisites

An automated installation method for the externals is provided.  If
you elect to use it, see [Install Externals](external.md) and come
back here after setting up your user environment.

Otherwise, you must provide the external packages yourself. The Wire
Cell build system assumes they are available and found in the "usual
manner".  The definitive, full list of required packages, their
versions and build details are kept in `worch.cfg` file in
`wire-cell-externals`. Refer to that for the most up-to-date
information on what software is needed. In summary you will need:

* BOOST 1.55 (or equiv)
* ROOT v6
* Python 2.7 (optional unless you want Python bindings)

You will need to set up your run-time environment so that these
commands do not fail and give the expected version:

```bash
$ root -b -q
...
| Welcome to ROOT 6.05/01                    http://root.cern.ch |
...
$ python -c 'import ROOT; print ROOT.gROOT.GetVersion()'
6.05/01
```

# Preparing wire-cell source

Wire Cell is made up of several source packages.  A top-level
`wire-cell` package is used to aggregate them together as well as
provide the top-level build environment.  The aggregation is done
using Git modules.

If you are a developer wanting to use SSH keys (default) to access the
repository clone with the appropriate URL:

```bash
$ git clone git@github.com:BNLIF/wire-cell.git
$ cd wire-cell/
```

If you are anonymous or in any case prefer to use HTTPS instead of SSH
you will need to clone as shown below and then convert the submodules
to likewise use HTTPS via the provided script.


```bash
$ git clone https://github.com/BNLIF/wire-cell.git
$ cd wire-cell/
$ ./switch-git-urls
```

Later, you can switch back to developer/SSH URLs with:

```bash
$ ./switch-git-urls dev
```

Now get the submodules:

```bash
$ git submodule init
$ git submodule update
```

Finally, it is convenient to set an alias to the copy of waf.
Otherwise you'll need to specify it's full path or make it available
in your `$PATH`.

```bash
$ alias waf=`pwd`/waf-tools/waf
```

# Building wire-cell

To configure, build and install the wire cell code do:

```bash
$ waf --prefix=/path/to/install configure build install
```

(If you came here after exercising the automatic external
installation, take note this is not a Worch build - there is no
`--orch-config` option.)

# Run-time environment

Set up your run time environment following whatever method you chose
to supply the external packages.

For wire-cell itself you will need to set or add to the usual:

- `PATH`
- `LD_LIBRARY_PATH`
- `PYTHONPATH`

to point to directories under `/path/to/install`.

Special notes:

- **Ubuntu:** :: Set `PYTHONNOUSERSITE` to `yes` (or anything) if you also have Ubuntu ROOT packages installed.  This will stop the system PyROOT from being picked up
- **Scientific Linux:** :: the build currently installs to both `lib/` and `lib64/` directories so add both to your `LD_LIBRARY_PATH`.
- **Install to single root:** :: If you followed the *single rooted install* pattern **and** chose the ``/path/to/install`` to be coincident with ``/path/to/single-rooted`` then probably no additional user environment will be needed beyond sourcing ROOT's `thisroot.sh`.


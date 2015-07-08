[TOC]

# Installation of prerequisites

It is recommended to use the automated installation method to install the required externals. Follow the directions in [Install Externals](external.md) and come back here after setting up your user environment.

However, you may instead provide the external packages yourself. The definitive list of required packages, their versions and build details are kept in wire-cell-externals worch.cfg file. Refer to that for the most up-to-date information on what software is needed. In summary you will need:

* ROOT v6
* Python 2.7
* BOOST 1.55 (or equiv)

You will need to set up your run-time environment so that these commands do not fail and give the expected version:

```bash
$ root -b -q
...
| Welcome to ROOT 6.02/05                http://root.cern.ch |
...
$ python -c 'import ROOT; print ROOT.gROOT.GetVersion()'
6.02/05
```

# Preparing wire-cell source

The wire cell source project uses ``git-submodules`` to bring all the source together:

```bash
$ git clone git@github.com:BNLIF/wire-cell.git
$ cd wire-cell
$ git submodule init
$ git submodule update

$ alias waf=`pwd`/waf-tools/waf
```

# Building wire-cell

To configure, build and install the wire cell code do:

```bash
$ waf --prefix=/path/to/install configure build install
```

Note: this is not a Worch build - there is no `--orch-config` option.

# Run-time environment

Set up the run time environment needed by however you chose to install the externals.

For wire-cell itself you will need to set or add to the usual:

- `PATH`
- `LD_LIBRARY_PATH`
- `PYTHONPATH`

to point to directories under `/path/to/install`.

Special notes:

- **Ubuntu:** :: Set `PYTHONNOUSERSITE` to `yes` (or anything) if you also have Ubuntu ROOT packages installed.  This will stop the system PyROOT from being picked up
- **Scientific Linux:** :: the build currently installs to both `lib/` and `lib64/` directories so add both to your `LD_LIBRARY_PATH`.
- **Install to single root:** :: If you followed the *single rooted install* pattern **and** chose the ``/path/to/install`` to be coincident with ``/path/to/single-rooted`` then probably no additional user environment will be needed beyond sourcing ROOT's `thisroot.sh`.


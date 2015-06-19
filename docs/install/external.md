[TOC]


The ``wire-cell`` software in [BNL IF GitHub](https://github.com/BNLIF) depends on some software that may not come with your OS, in particular [ROOT](http://root.cern.ch).  This package provides a [Worch](https://github.com/brettviren/worch) configuration file to build that software.

## Quickstart

If you don’t care what this does, just cut and paste:

```bash
$ virtualenv /path/to/buildenv
$ source /path/to/buildenv/bin/activate
$ pip install worch

$ git clone git@github.com:BNLIF/wire-cell-externals.git /path/to/work
$ cd /path/to/work
$ waf --prefix=/path/to/install --orch-config=worch.cfg configure build
$ deactivate

$ source /path/to/install/env.sh
$ module load root
```

You would repeat those last two lines in any new shells. You can now test:

```bash
$ root -b -q
...
| Welcome to ROOT 6.02/05                http://root.cern.ch |
...
$ python -c 'import ROOT; print ROOT.gROOT.GetVersion()'
6.02/05
```

More details and build options are described in the following sections.

## Preparation

It is recommended to install the Worch build system into a Python virtual environment. This environment will be used only for building these externals.

```bash
$ virtualenv /path/to/buildenv
$ source /path/to/buildenv/bin/activate
$ pip install worch
```

This wire-cell-externals repository provides the rest of what is needed. Clone it to some place with ample disk space (10s of GB).

```bash
$ git clone git@github.com:BNLIF/wire-cell-externals.git /path/to/work
$ cd /path/to/work
```

## Build

After the above is done, this one command builds all the external software:
```bash
(1)  $ waf --prefix=/path/to/install --orch-config=worch.cfg configure
(2)  $ waf
(3)  $ deactivate
```
This does:

1. Configures the build according to the ``worch.cfg`` file and tells it where to install the final results
2. Performs the automated build of external packages. This takes ~1 hour on Intel i7 w/ an SSD.
3. Exit the virtualenv as it is no longer needed (``/path/to/buildenv`` may be removed)

## Install

There are two ways to install the results of the build which differ in the organization of the installation directory layout. They are:

#### name/version tree
> each package is installed into ``/path/to/install/<name>/<version>/{bin,lib,include}``. This allows for multiple versions of each package to be installed in parallel supporting different versions of an overall collection. It allows purging of a particular version by simply deleting the directory, although with care not to break other packages which depend on it. The user environment must be modified (``PATH``, etc) to pick up all run-time aspects of each individual package.

#### single-rooted directory
> all packages are installed in the same ``/path/to/install/{bin,lib,include}`` directory. User run-time environment still requires adjustment but only for a single aspect. Only one version of a package may be installed, and removing an installed package is not supported (but is possible).
This package supports both paradigms.

This package supports both paradigms.

### Install to name/version tree

By default, and as part of the build procedure, one will produce a name/version tree installation area as designated by the ``--prefix`` option to ``waf``. The user run-time environment can be set up with the help of [Environment Modules](http://modules.sf.net/) (EM) which are provided by the build.

```bash
$ source /path/to/install/env.sh
$ module load root

$ root -b -q
...
| Welcome to ROOT 6.02/05                http://root.cern.ch |
...

$ python -c 'import ROOT; print ROOT.gROOT.GetVersion()'
6.02/05
```

### Single-rooted install

In addition to the population of /path/to/install as above, the build will produce a “tarpack” binary package file. These can simply be unpacked into a single-rooted directory.

```bash
$ cd /path/to/work
$ mkdir -p /path/to/single-rooted
$ for n in tmp/tarpack/*.tgz; do tar -C /path/to/single-rooted -xf $n; done
```
No special environment setup mechanism is provided for this mechanism however one can largely piggy-back on the one ROOT provides:

```bash
$ source /path/to/single-rooted/bin/thisroot.sh

$ root -b -q
...
| Welcome to ROOT 6.02/05                http://root.cern.ch |
...

$ python -c 'import ROOT; print ROOT.gROOT.GetVersion()'
6.02/05
```

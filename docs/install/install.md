# Prerequisites
Some external packages are required as described in this section.

## Automated installation

It is recommended to use the automated installation method to install the required externals. Follow the directions in [Install Externals](external.md) and come back here after setting up your user environment.

## Manual installation

You may provide the external packages yourself. The definitive list of required packages, their versions and build details are kept in wire-cell-externals worch.cfg file. Refer to that for the most up-to-date information on what software is needed. In summary you will need:

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

# Build

## Preparing the source

The wire cell source project uses ``git-submodules`` to bring all the source together:

```bash
$ git clone git@github.com:BNLIF/wire-cell.git
$ cd wire-cell
$ git submodule init
$ git submodule update

$ alias waf=`pwd`/waf-tools/waf
```

## Building

To configure, build and install the wire cell code do:

```bash
$ waf --prefix=/path/to/install configure build install
```

Note: this is not a Worch build - there is no `--orch-config` option.

If you followed the *single rooted install* pattern then the ``/path/to/install`` can be ``/path/to/single-rooted`` and no additional user environment will be needed for run-time and the following command line should succeed:

```bash
$ python -c 'import ROOT; print ROOT.WireCellData'
Warning in <TInterpreter::ReadRootmapFile>: class  pair<float,float> found in libCore.so  is already in libWireCellDataDict.so
Warning in <TInterpreter::ReadRootmapFile>: class  pair<int,float> found in libCore.so  is already in libWireCellDataDict.so
<class 'ROOT.WireCellData'>
```

If you provided your own externals or used the name/version tree pattern (using environment modules) then you will need to set your environment properly. Besides the usual ``$PATH``, ``$LD_LIBRARY_PATH``, etc pointing at ``/path/to/install`` you may need to set ``PYTHONPATH``.

Independent from how you installed the code, if you have the broken ROOT packages for Ubuntu installed you will have to set:

```bash
$ export PYTHONNOUSERSITE=yes
```

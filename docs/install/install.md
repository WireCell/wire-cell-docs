# Dependencies in Wire Cell

Wire Cell software suite is composed of multiple packages with a
carefully considered on themselves and on external packages.  Wire
Cell software is designed in layers to provide as much or as little
functionality as needed.  The more layer, the more dependencies.  The
core part of Wire Cell has minimal dependencies:

- C++11/14 compiler (GCC most tested)
- BOOST (1.59 if pipeline is used)

Wire Cell packages have many unit tests and they tend to also required
ROOT and some Wire Cell shared libraries explicitly require root (eg,
Rio and RootDict).

- ROOT 6

FIXME: we will eventually likely require:

- Eigen3
- Boost.Pipeline

And maybe others.


# Getting Wire Cell source package

Wire Cell source code is available from the
[Wire Cell GitHub organization](https://github.com/wirecell).

The recommended access is via Wire Cell developer SSH keys:

```bash
$ git clone git@github.com:WireCell/wire-cell-build.git
$ cd wire-cell-build/
$ git submodule init
$ git submodule update
```

If you are anonymous then you may instead clone through HTTPS and
switch git URLs before running `git submodule`:

```bash
$ git clone https://github.com/WireCell/wire-cell-build.git
$ cd wire-cell-build/
$ ./switch-git-urls
```

# Building wire-cell

Wire Cell software is built with [waf](https://waf.io/).  A custom Waf
command (`wcb` = "wire cell builder") is provided:

To configure, build and install the wire cell code do:

```bash
$ ./wcb --prefix=/path/to/install configure build install
```

If dependencies are not found you may specify them with additional
flags as shown by the help.  Eg:

```bash
$ ./wcb --help
$ ./wcb --boost-libs=... --boost-includes=... --with-root=... configure
$ ./wcb
$ ./wcb install
```

# Run-time environment

It is assumed you have already set up your run-time environment so
that you can access the external dependencies in the "usual manner".
For wire-cell itself you will need to further set or add to the usual
environment variables:

- `PATH`
- `LD_LIBRARY_PATH`
- `PYTHONPATH`

to point to directories under the `/path/to/install` you used with `wcb configure`.

# Platform notes:

- **Ubuntu:** :: Set `PYTHONNOUSERSITE` to `yes` (or anything) if you also have Ubuntu ROOT packages installed.  This will stop the system PyROOT from being picked up
- **Scientific Linux:** :: the build currently installs to both `lib/` and `lib64/` directories so add both to your `LD_LIBRARY_PATH`.



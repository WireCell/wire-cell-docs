(FIXME: this section needs work.)

# Tests

Tests go under the `test/` (or `tests/`) sub-directory of the package.  There are two types, C++ and Python.  In both cases, only files that begin with "`test_*`" will be considered tests.  Tests are automatically run as part of the build procedure (fixme: just C++ ones are automatic right now) and will be rerun when they or code they depend on changes.   When tests are run by the build the `stdout/stderr` is typically captured.  You can run them manually to observe any print statements.  Tests are not installed but left in the "`build/`" (or sometimes "`tmp/`") output directory.

Here are a few general guidelines for writing tests:

-   write many tests
-   write tests as fine grained as convenient
-   the best tests are written before or while the code they test is being written
-   test code does need not be "pretty", it will never be called from anywhere else
-   tests should run quickly
-   do use contrived data or mocked code to provide a bit of test code it's needed input or code support

##  C++ tests

Writing a C++ test is to write a `main()` program which takes **no arguments**.  If a test fails, either let it crash the test program or call `exit(1)`.

You can explicitly run C++ test programs.  When they are run as part of the build, their full path is printed.  When run automatically, waf takes care of setting up their environment so that their libraries are found.  When run manually you will have to assure this.  The simplest way is to `waf install`" the package first.

```bash
$ waf
...
execution summary
  tests that pass 3/4
    /home/bviren/projects/wire-cell/top/build/data/test_construct
    /home/bviren/projects/wire-cell/top/build/nav/test_geomdatasource
    /home/bviren/projects/wire-cell/top/build/sst/tgeomdatasource
  tests that fail 1/4
    /home/bviren/projects/wire-cell/top/build/data/test_fail
'build' finished successfully

$ waf install

$ /home/bviren/projects/wire-cell/top/build/sst/test_sst_geomdatasource
Wire: 0 plane=1 index=0
Wire: 0 plane=1 index=1
Wire: 0 plane=1 index=2
...
```

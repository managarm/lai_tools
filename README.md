# LAI userspace tools

[![Build Status](https://travis-ci.com/qword-os/lai_tools.svg?branch=master)](https://travis-ci.com/qword-os/lai_tools)
[![Coverage Status](https://coveralls.io/repos/github/qword-os/lai_tools/badge.svg?branch=master)](https://coveralls.io/github/qword-os/lai_tools?branch=master)

## Prerequisites

meson is required to build this project.

## Building

* Clone this repository.
* Create a build directory; use meson and ninja to build the project.

```
$ mkdir build && cd build
$ meson ..
$ ninja
$ meson test -v # Run tests and see test output.
```

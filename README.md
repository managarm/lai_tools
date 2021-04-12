# LAI userspace tools

[![Build Status](https://travis-ci.com/managarm/lai_tools.svg?branch=master)](https://travis-ci.com/managarm/lai_tools)
[![Coverage Status](https://coveralls.io/repos/github/managarm/lai_tools/badge.svg?branch=master)](https://coveralls.io/github/managarm/lai_tools?branch=master)

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

## Bootable image

It is possible to generate a bootable image containing LAI in order to test it on real hardware.

```
$ cd boot_image
$ make clean all
```

A bootable file called `test.hdd` should be created in the `boot_image` directory.
Test it in QEMU or any other virtualisation solution, or write it onto a drive
(e.g.: a USB stick) by means of `cat` or `dd`.

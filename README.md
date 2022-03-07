## How to build

```sh
$ make
$ cd out/packaging && NO_CODESIGN=1 ./package.sh ..
```

The pkg will be written to `out/podman-desktop-macos.pkg`.
Currently the pkg installs `podman` to `~/bin`
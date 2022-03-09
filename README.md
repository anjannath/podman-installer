## How to build

```sh
$ make
$ cd out/packaging && NO_CODESIGN=1 ./package.sh ..
```

The pkg will be written to `out/podman-desktop-macos.pkg`.
Currently the pkg installs `podman` to `~/bin`

### Screenshot
<img width="626" alt="Screenshot 2022-03-09 at 11 21 52 AM" src="https://user-images.githubusercontent.com/8885742/157380992-2e3b1573-34a0-4aa0-bdc1-a85f4792a1d2.png">

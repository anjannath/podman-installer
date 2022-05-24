## How to build

```sh
$ make NO_CODESIGN=1 out/podman-macos.pkg
```

The pkg will be written to `out/podman-macos.pkg`.
Currently the pkg installs `podman`, `qemu`, `gvproxy` and `podman-mac-helper` to `/Applications/podman`

## Uninstalling

Open `Finder` and navigate to `Applications` then drag `podman` directory to the trash to uninstall.

### Screenshot
<img width="626" alt="Screenshot 2022-03-09 at 11 21 52 AM" src="https://user-images.githubusercontent.com/8885742/157380992-2e3b1573-34a0-4aa0-bdc1-a85f4792a1d2.png">

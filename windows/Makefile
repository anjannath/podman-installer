SHELL := bash

ARCH ?= amd64
PODMAN_VERSION ?= 4.1.0
PODMAN_RELEASE_URL ?= https://github.com/containers/podman/releases/download/v$(PODMAN_VERSION)/podman-remote-release-windows_$(ARCH).zip
BUILD_DIR ?= out
PACKAGE_DIR ?= out/packaging
TMP_DOWNLOAD ?= tmp-download
PACKAGE_ROOT ?= root

default: packagedir

get-podman:
	mkdir -p $(TMP_DOWNLOAD)
	cd $(TMP_DOWNLOAD) && curl -sLO $(PODMAN_RELEASE_URL) && unzip *.zip podman-$(PODMAN_VERSION)/usr/bin/podman.exe

packagedir: package_root 
# nothing to be done to prepare wix for now 


# win-winpath is checked out manually is a lightweight helper binary to set
# the Windows path environment. It is checked out from the Podman repository.
#
WP_GITURL=https://github.com/containers/podman.git
WP_SHA=3ac5999f8590991bd24810d8cbe829de92442638

get-winpath:
	rm -rf tmp-wp; mkdir tmp-wp
	(cd tmp-wp; \
         git init; \
         git remote add origin $(WP_GITURL); \
         git fetch --depth 1 origin $(WP_SHA); \
         git checkout FETCH_HEAD; make podman-winpath)
	mkdir -p bin/windows/
	cp tmp-wp/bin/windows/winpath.exe bin/
	rm -rf tmp-wp


# win-sshproxy is checked out manually to keep from pulling in gvisor and it's transitive
# dependencies. This is only used for the Windows installer task (podman.msi), which must
# include this lightweight helper binary.
#
GV_GITURL=https://github.com/containers/gvisor-tap-vsock.git
GV_SHA=e943b1806d94d387c4c38d96719432d50a84bbd0

get-sshproxy:
	rm -rf tmp-gv; mkdir tmp-gv
	(cd tmp-gv; \
         git init; \
         git remote add origin $(GV_GITURL); \
         git fetch --depth 1 origin $(GV_SHA); \
         git checkout FETCH_HEAD; make win-sshproxy)
	mkdir -p bin/windows/
	cp tmp-gv/bin/win-sshproxy.exe bin/
	rm -rf tmp-gv


package_root: get-podman get-sshproxy get-winpath
	mkdir -p $(PACKAGE_ROOT)/tmp-podman-desktop
	cp $(TMP_DOWNLOAD)/podman-$(PODMAN_VERSION)/usr/bin/podman.exe $(PACKAGE_ROOT)/tmp-podman-desktop/podman.exe
	cp bin/win-sshproxy.exe $(PACKAGE_ROOT)/tmp-podman-desktop/win-sshproxy.exe
	cp bin/winpath.exe $(PACKAGE_ROOT)/tmp-podman-desktop/winpath.exe

%: %.in
	@sed -e 's/__VERSION__/'$(PODMAN_VERSION)'/g' $< >$@

.PHONY: clean
clean:
	rm -rf $(PACKAGE_DIR) $(TMP_DOWNLOAD)

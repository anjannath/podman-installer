SHELL := bash

ARCH ?= aarch64
PODMAN_VERSION ?= 0.0.1
GVPROXY_VERSION ?= 0.0.1
MAC_HELPER_VERSION ?= 0.0.1
QEMU_VERSION ?= 0.2
PODMAN_RELEASE_URL ?= https://github.com/containers-contribs/podman/releases/download/v$(PODMAN_VERSION)/podman-$(ARCH)
GVPROXY_RELEASE_URL ?= https://github.com/containers-contribs/podman/releases/download/v$(GVPROXY_VERSION)/gvproxy-$(ARCH)
MAC_HELPER_RELEASE_URL ?= https://github.com/containers-contribs/podman/releases/download/v$(MAC_HELPER_VERSION)/podman-mac-helper-$(ARCH)
QEMU_RELEASE_URL ?= https://github.com/containers-contribs/qemu-macos-build/releases/download/$(QEMU_VERSION)/qemu-macos-$(ARCH).tar.xz
BUILD_DIR ?= out
PACKAGE_DIR ?= out/packaging
TMP_DOWNLOAD ?= tmp-download
PACKAGE_ROOT ?= root

default: packagedir

get_podman:
	mkdir -p $(TMP_DOWNLOAD)
	cd $(TMP_DOWNLOAD) && curl -sLo podman $(PODMAN_RELEASE_URL)

get_gvproxy:
	mkdir -p $(TMP_DOWNLOAD)
	cd $(TMP_DOWNLOAD) && curl -sLo gvproxy $(GVPROXY_RELEASE_URL)

get_qemu:
	mkdir -p $(TMP_DOWNLOAD)
	cd $(TMP_DOWNLOAD) && curl -sLO $(QEMU_RELEASE_URL)

get_mac_helper:
	mkdir -p $(TMP_DOWNLOAD)
	cd $(TMP_DOWNLOAD) && curl -sLo podman-mac-helper $(MAC_HELPER_RELEASE_URL)

packagedir: package_root Distribution welcome.html
	mkdir -p $(PACKAGE_DIR)
	cp -r Resources $(PACKAGE_DIR)/
	cp welcome.html $(PACKAGE_DIR)/Resources/
	cp Distribution $(PACKAGE_DIR)/
	cp -r scripts $(PACKAGE_DIR)/
	cp -r $(PACKAGE_ROOT) $(PACKAGE_DIR)/
	cp package.sh $(PACKAGE_DIR)/
	cd $(PACKAGE_DIR) && pkgbuild --analyze --root ./root component.plist
	echo -n $(PODMAN_VERSION) > $(PACKAGE_DIR)/VERSION
	cp LICENSE $(PACKAGE_DIR)/Resources/LICENSE.txt

package_root: get_podman get_gvproxy get_qemu get_mac_helper
	mkdir -p $(PACKAGE_ROOT)/podman/bin $(PACKAGE_ROOT)/podman/qemu
	cp $(TMP_DOWNLOAD)/podman $(TMP_DOWNLOAD)/gvproxy $(TMP_DOWNLOAD)/podman-mac-helper $(PACKAGE_ROOT)/podman/bin/
	tar -C $(PACKAGE_ROOT)/podman/qemu -xf $(TMP_DOWNLOAD)/qemu-macos-$(ARCH).tar.xz
	chmod a+x $(PACKAGE_ROOT)/podman/bin/*

%: %.in
	@sed -e 's/__VERSION__/'$(PODMAN_VERSION)'/g' $< >$@

out/podman-macos.pkg: packagedir
	cd $(PACKAGE_DIR) && ./package.sh ..

.PHONY: clean
clean:
	rm -rf $(BUILD_DIR) $(TMP_DOWNLOAD) $(PACKAGE_ROOT) Distribution welcome.html


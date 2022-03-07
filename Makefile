SHELL := bash

ARCH ?= arm64
PODMAN_VERSION ?= 3.4.4
PODMAN_RELEASE_URL ?= https://github.com/containers/podman/releases/download/v$(PODMAN_VERSION)/podman-remote-release-darwin.zip
BUILD_DIR ?= out
PACKAGE_DIR ?= out/packaging
TMP_DOWNLOAD ?= tmp-download
PACKAGE_ROOT ?= root

default: packagedir

get_podman:
	mkdir -p $(TMP_DOWNLOAD)
	cd $(TMP_DOWNLOAD) && curl -sLO $(PODMAN_RELEASE_URL) && unzip *.zip podman-$(PODMAN_VERSION)/podman

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
	cp LICENSE $(PACKAGE_DIR)/LICENSE.txt

package_root: get_podman
	mkdir -p $(PACKAGE_ROOT)/tmp-podman-desktop
	cp $(TMP_DOWNLOAD)/podman-$(PODMAN_VERSION)/podman $(PACKAGE_ROOT)/tmp-podman-desktop/podman
	chmod a+x $(PACKAGE_ROOT)/tmp-podman-desktop/podman

%: %.in
	@sed -e 's/__VERSION__/'$(PODMAN_VERSION)'/g' $< >$@

.PHONY: clean
clean:
	rm -rf $(PACKAGE_DIR) $(TMP_DOWNLOAD) Distribution welcome.html

# replace version in the files

# download podman binaries based on arch and version

# build the distribution dir tree
.PHONY: startArchlinuxDocker
startArchlinuxDocker:
	docker stop configarch && docker rm configarch || true
	docker run --rm --name configarch -d -v .:/nathanajahconfig archlinux sleep infinity
	docker exec -it configarch pacman -Sy --noconfirm

.PHONY: sshArchlinux
sshArchlinux:
	docker exec -it configarch /bin/bash

.PHONY: startUbuntuDocker
startUbuntuDocker:
	docker stop configubuntu && docker rm configubuntu || true
	docker run --rm --name configubuntu -d -v .:/nathanajahconfig ubuntu:24.04 sleep infinity
	docker exec -it configubuntu apt-get -y update

.PHONY: sshUbuntu
sshUbuntu:
	docker exec -it configubuntu /bin/bash

ifeq ($(wildcard stow),stow)
STOW_DIR := stow
else
STOW_DIR := main/stow
endif

.PHONY: installArchlinux
installArchlinux:
	sudo pacman -S --needed --noconfirm - < packages/pacman.txt

.PHONY: installUbuntu
installUbuntu:
	sudo apt update
	xargs -r -a packages/apt.txt sudo apt-get install -y
	./scripts/install_additional_ubuntu.sh

.PHONY: installMac
installMac:
	brew bundle --file=packages/Brewfile

.PHONY: stow
stow:
	stow -R --dir=$(STOW_DIR) --target=$(HOME) base dev colorscheme

.PHONY: unstow
unstow:
	@find $(HOME) -maxdepth 5 -type l -lname '*nathanajahconfig*' \
		-not -path '$(HOME)/git/nathanajahconfig/*' 2>/dev/null \
		| while read -r l; do rm -f "$$l"; done; true

.PHONY: stowUow
stowUow: stow
	stow -R --dir=$(STOW_DIR) --target=$(HOME) uow

.PHONY: restow
restow: unstow stow

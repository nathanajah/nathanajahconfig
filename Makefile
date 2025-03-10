.PHONY: startArchlinuxDocker
startArchlinuxDocker:
	docker stop configarch && docker rm configarch || true
	docker run --rm --name configarch -d -v .:/nathanajahconfig archlinux sleep infinity
	docker exec -it configarch pacman -Sy --noconfirm
	docker exec -it configarch pacman -S ansible --noconfirm

.PHONY: runArchlinuxPlaybook
runArchlinuxPlaybook:
	docker exec -it configarch ansible-playbook /nathanajahconfig/playbook/archlaptop.yml

.PHONY: sshArchlinux
sshArchlinux:
	docker exec -it configarch /bin/bash

.PHONY: startUbuntuDocker
startUbuntuDocker:
	docker stop configubuntu && docker rm configubuntu || true
	docker run --rm --name configubuntu -d -v .:/nathanajahconfig ubuntu:24.04 sleep infinity
	docker exec -it configubuntu apt-get -y update
	docker exec -it configubuntu apt-get -y install ansible

.PHONY: runUbuntuPlaybook
runUbuntuPlaybook:
	docker exec -it configubuntu ansible-playbook /nathanajahconfig/playbook/uowlaptop.yml

.PHONY: sshUbuntu
sshUbuntu:
	docker exec -it configubuntu /bin/bash

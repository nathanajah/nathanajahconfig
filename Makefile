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

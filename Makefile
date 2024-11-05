#### Variables ####

export ROOT_DIR ?= $(PWD)
export CR_ROOT_DIR ?= $(ROOT_DIR)

export ANSIBLE_NAME ?= container-runtime
export HOSTS_INI_FILE ?= $(CR_ROOT_DIR)/hosts.ini

export EXTRA_VARS ?= ""

#### Start Ansible docker ####

ansible:
	export ANSIBLE_NAME=$(ANSIBLE_NAME); \
	sh $(CR_ROOT_DIR)/scripts/ansible ssh-agent bash

#### a. Debugging ####
debug:
	ansible-playbook -i $(HOSTS_INI_FILE) $(CR_ROOT_DIR)/debug.yml \
		--extra-vars "ROOT_DIR=$(ROOT_DIR)" --extra-vars $(EXTRA_VARS)

#### b. Provision cr (default docker)####
cr-install: cr-docker-install
cr-uninstall: cr-docker-uninstall

#### c. Provision docker ####
cr-docker-install:
	ansible-playbook -i $(HOSTS_INI_FILE) $(CR_ROOT_DIR)/deploy_docker.yml --tags install \
		--extra-vars "ROOT_DIR=$(ROOT_DIR)" --extra-vars $(EXTRA_VARS)
cr-docker-uninstall:
	ansible-playbook -i $(HOSTS_INI_FILE) $(CR_ROOT_DIR)/deploy_docker.yml --tags uninstall \
		--extra-vars "ROOT_DIR=$(ROOT_DIR)" --extra-vars $(EXTRA_VARS)


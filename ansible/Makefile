docker:
	ansible-playbook -i hosts ./docker.yml --ask-become-pass

cni:
	ansible-playbook -i hosts ./cni.yml --ask-become-pass

consul:
	ansible-playbook -i hosts ./consul.yml --ask-become-pass

nomad:
	ansible-playbook -i hosts ./nomad.yml --ask-become-pass

ALL: docker cni consul nomad

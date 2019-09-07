Initial setup:

	pip install -r requirements.txt
	ansible-galaxy install -r requirements.yml
	terraform init

Create cluster:

	terraform apply

Configure BeeGFS:

	ansible-playbook -i inventory-beegfs beegfs.yml -b

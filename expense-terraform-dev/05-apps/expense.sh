#!/bin/bash
dnf install ansible -y  # Installing Ansible in ansible Server
cd /tmp
git clone https://github.com/Manikanta-18082002/expense-ansible-roles.git
cd expense-ansible-roles
ansible-playbook main.yaml -e component=backend -e login_password=ExpenseApp1  # No need of inventory file bcz? Above mentioned URL it contains file
ansible-playbook main.yaml -e component=frontend 



# Ansible Notes
Collection of snippets and notes related to Ansible.

## Ad-Hoc Commands
Command-line Interface for simple one-liners




## Inventory

### Hosts



#### File
ansible_ssh_host,port,user,pass,private_key_file
ansible_connection={local,ssh,paramiko,smart}
ansible_ruby,python_interpreter


#### CLI
Specify which hosts to run on:
`webservers:!{{excluded}}:&{{required}}`

Limit to hosts except for those listed in text file:
`ansible-playbook site.yml --limit @retry_hosts.txt`

Limit to the first host in the group:
`webservers[0]`

  0-25:
  `webservers[0:25]`



### RegEx
Precede with `~`
(e.g. `~(web|db).*\.example\.com`)




## Playbooks

### Examples



# Development Machines Configuration
Shit i'm getting tired of Googling everytime I setup a new vm/droplet



## Python

### Essentials

- Install Basics
`sudo apt-get install build-essential autoconf libtool pkg-config python-imaging
python-dev`   

- Install Pip  

* Python3 Pip First  

`[[ -e ${HOME}/repos ]] && cd ${HOME}/repos && curl -s https://bootstrap.pypa.io/get-pip.py |sudo
python3`

* Now for Python 2.7  

`python ${HOME}/repos/get-pip.py`


## TERM

### Zsh


### Bash



### tmux



## Vim


## Virtual  


### Vagrant
Download  the vagrant file, and place in your apps dir.  

`curl -O https://raw.githubusercontent.com/adlawson/vagrantfiles/master/python/Vagrantfile`
`vagrant up`
`vagrant ssh`

### Ansible
Install via git or apt from the methods below.  

##### Install  

##### Requirements  
`sudo pip install paramiko PyYAML jinja2 httplib2`

- git  
`git clone https://github.com/ansible/ansible.git` 

Or...

- apt  
```
$ sudo apt-get install software-properties-common
$ sudo apt-add-repository ppa:ansible/ansible
$ sudo apt-get update
$ sudo apt-get install ansible
```

###### Configure  
`echo "127.0.0.1" > ~/ansible_hosts`
`export ANSIBLE_HOSTS=~/ansible_hosts`



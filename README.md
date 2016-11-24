# git-backup-cluster

(Gitolite) Backups selected repos from master to several slaves by schedule

_Under construction_

## Instalation

- apt-get install git realpath (or 'yum install git realpath' at CentOs )
- git clone https://github.com/artemdudkin/git-backup-cluster.git
- ./git-backup-cluster/gbc install

## Usage

Commands can be run just like 
```sh
gbc <command> <params>
```

## Master Commands 

### master install

Init of master node

### master add repo "name" "path"

Adds repo to cluster (copy and push). Name = name of repo. Path = path to repo files

### master add node "name" "pubkey"

Adds node key at master node. Name = name of node (just for info). Pubkey = path to public key of node

### master rm node "name"

### master add user "name" "pubkey" "permissions"

Adds node user at master node. Name = name of user. Pubkey = path to public key of user. Permissions = RW|R.

### master rm user "name"

Delete user, obviously.

## Slave Commands 

### slave install "ip"

Init of slave node. IP = ip of master.

## License

MIT

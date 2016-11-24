# git-backup-cluster

(Gitolite) Backups selected repos from master to several slaves by schedule

_Under construction_

## Instalation

- apt-get install git realpath (or 'yum install git realpath' at CentOs )
- git clone https://github.com/artemdudkin/git-backup-cluster.git
- ./git-backup-cluster/gbc install

## Commands

### gbc master install

Init of master node

### gbc master add node "name" "keypath"

Adds node key at master node. Name = name of node (just for info). Keypath = path to RSA public key of node

### gbc master add user "name" "keypath" "permissions"

Adds node user at master node. Name = name of user. Keypath = path to RSA public key of user. Permissions = RW|R

### gbc node install

Init of slave node

## License

MIT

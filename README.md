# git-backup-cluster

Backups selected git repos from master to several slaves by schedule (gitolite used).

_I have some set of git repos with my private projects. I changed VPS providers several time and it was a pain to move my repos from one VPS to another. And one time I lost my central git host when I forgot to make a payment for VPS._

_Now I have several chip VPS with backup of my repos, and I can add new slave just in one minute. Wow!_

_!!!Under strong construction!!!_

## Instalation

- apt-get install git realpath (or 'yum install git realpath' at CentOs )
- git clone https://github.com/artemdudkin/git-backup-cluster.git
- ./git-backup-cluster/gbc install

## Usage

Commands can be run just like 
```sh
gbc master|slave <command> <params>
```

## Master Commands 

### install

Init of master node

### add repo "name" "path"

Adds repo to cluster (copy and push). Name = name of repo. Path = path to repo files

### add node "name" "pubkey"

Adds node key at master node. Name = name of node (just for info). Pubkey = path to public key of node

### rm node "name"

### add user "name" "pubkey" "permissions"

Adds node user at master node. Name = name of user. Pubkey = path to public key of user. Permissions = RW|R.

### rm user "name"

Delete user, obviously.

## Slave Commands 

### install "ip"

Init of slave node. IP = ip of master.

## License

MIT

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
gbc gitolite|master|slave <command> <params>
```

## Gitolite Commands 

### install "username"

Create git user named "username" (i.e. user to store repos), create git-admin user (named "username-admin") and install gitolite. You should use this username it 'git clone' command from this host (i.e. git clone username@....).

### add repo "name" "path"

Add repo (copy and push). Name = name of repo. Path = path to repo files

### add user "name" "pubkey" 

Add user (with no permissions to any repo). Name = name of user. Pubkey = path to public key of user.

### grant "repo" "user" "perm" 

Grant some rights for user at specified repo. Repo = name of repo. User = name of user. Perm = RW|R


## Master Commands 

### install

Init of master node

### add repo "name"

Adds existing repo to cluster. Name = name of repo.

### add node "user"

Existing user becomes node - that means user grant R access to repo at cluster (to allow copy it)

## Slave Commands 

### install "ip"

Init of slave node. IP = ip of master.

## License

MIT

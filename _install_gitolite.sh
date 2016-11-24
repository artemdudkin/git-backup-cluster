#@1 = user name
#@echo 0/1
function user_exists() {
	local ret=0
	getent passwd $1 >/dev/null 2>&1 && ret=1
	echo $ret;
}
#Reads props form file where lines looks like ID="centos"
#@1 = filepath
#@2 = prop name
#@3 = key-value delimiter
#@echo prop value
function read_prop_from_file() { 
	local delimiter=$3

	if [ -z $delimiter ] ; then delimiter="="; fi

	str=$1
	if [ -f "$1" ] ; then
		while IFS="$delimiter" read -r key value
		do
			key=$(  echo "$key"   | sed -e 's/^[[:space:]]*//' | sed -e 's/[[:space:]]*$//')
			value=$(echo "$value" | sed -e 's/^[[:space:]]*//' | sed -e 's/[[:space:]]*$//')
			value=$(echo "$value" | tr '[:upper:]' '[:lower:]')
			if [ ! -z "${key}" ] && [ "${key}" == "$2" ] ; then 
				ret=$(echo "$value" | sed -e 's/^"*//' | sed -e 's/"*$//')
			fi
		done < "$1"
	fi
	
	echo $ret
}
#@echo operation system id
function get_os_id() { 
	local id=$(read_prop_from_file "/etc/os-release" "ID")
	if [ -z "$id" ]; then
		lsb_release -a > ./.tmp
		id=$(read_prop_from_file "./.tmp" "Distributor ID" ":")
		rm -f ./.tmp
	fi
	echo $id
}





OS=$(get_os_id)

user_name=$1
pk_file=$2

#check os
if [ ! "${OS}" == "centos" ] && [ ! "${OS}" == "ubuntu"  ] ; then 
	echo "Untested OS '$OS' - please fix it at sources if you really want to proceed (I guess no)"
else 
	echo "OS '$OS' is ok"
fi

#check mandatory input params
if [ -z "$1" ] || [ -z "$2" ] ; then 
	printf "\n\tUsage: $0 <user_name> <file_name>\n\n"
	exit -1
fi

#check key existing
if [ ! -e "$pk_file" ]; then
	echo "ERROR: File '$pk_file' does not exists"
	exit -1
fi

#if user exists then stop
if [ $(user_exists "$user_name") -eq 1 ]; then
	echo "ERROR: Cannot proceed as user '$user_name' exists already - please remove it and start again"; 
	exit -1
fi

#if homedir folder exists then stop
if [ -d "/home/$user_name" ]; then
	echo "ERROR: Cannot proceed as folder '/home/$user_name' exists already - please remove it and start again"; 
	exit -1
fi

#create new user 
if [ $OS == "centos" ]; then
	sudo adduser $user_name
else 
	sudo adduser --disabled-password --gecos "" $user_name
fi

#check if user really created 
if [ ! $(user_exists "$user_name") -eq 1 ]; then
	echo "ERROR: Cannot create user '$user_name'"; 
	exit -1
else
	echo "User '$user_name' created"
fi

user_home_dir=$(eval echo "~$user_name")

#copy pk key
cp $pk_file "$user_home_dir"
#rename pk_file to gitolite-admin.pub
pk=$(ls "$user_home_dir" | head -n 1)
mv "$user_home_dir/$pk" "$user_home_dir/gitolite-admin.pub"
pk=$(ls "$user_home_dir" | head -n 1)
#ajust permissions
chown -R "$user_name:$user_name" "$user_home_dir"

sudo -u $user_name -H sh << EOF
	cd $user_home_dir
	mkdir ~/bin
	git clone git://github.com/sitaramc/gitolite
	if [ $? != 0 ] ; then exit; fi
	gitolite/install -ln ~/bin
	if [ $? != 0 ] ; then exit; fi
	bin/gitolite setup -pk "$pk"
	rm -f "$pk"
EOF

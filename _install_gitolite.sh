#@1 = user name
#@echo 0/1
function user_exists() {
	local ret=0
	getent passwd $1 >/dev/null 2>&1 && ret=1
	echo $ret;
}
#@1 = filepath
#@echo 0/1
function file_exists() {
	local ret=0
	if [ -e "$1" ]; then
		ret=1
	fi
	echo $ret;
}
#Reads props form file where lines looks like ID="centos"
#@1 = filepath
#@2 = prop name
#@3 = prop value var
#@echo prop value
function read_prop_from_file() { 
	if [ -f "$1" ]
	then
	  while IFS='=' read -r key value
	  do
#	    key=$(echo $key | tr '.' '_')
#	    eval "${key}='${value}'"
	    if [ ! -z $key ] && [ $key == "$2" ] ; then 
		ret=$(echo "$value" | sed -e 's/^"*//' | sed -e 's/"*$//')
	    fi
	  done < "$1"
	fi
	echo $ret
}
#@1 = filepath
#@echo absolute filepath
function get_absolute_path(){
	local ABS_PATH=`cd "$1"; pwd`
	echo $ABS_PATH
}

#rename file to @2 leaving the same extension (at ./)
#@1 = filepath
#@2 = new file name
function rename_to(){
	base=$(dirname $1)
	base=$(get_absolute_path "$base")

	filename=$(basename "$1")
	extension="${filename##*.}"
	filename="${filename%.*}"
	filename="${filename%.*}"
	if [ ! -z extension ] ; then
		filename="$2.$extension"
	fi

	mv "$1" "$base/$filename"
}











#check mandatory input params
if [ -z "$1" ] || [ -z "$2" ] ; then 
	printf "\n\tUsage: $0 <user_name> <file_name>\n\n"
	exit 0
fi

user_name=$1
pk_file=$2

#check key existing
if [ $(file_exists "$pk_file") -eq 1 ]; then
	echo "File '$pk_file' exists"
else 
	echo "ERROR: File '$pk_file' does not exists"
	exit 0
fi

OS=$(read_prop_from_file "/etc/os-release" "ID")

#check user existing or create new
if [ $(user_exists "$user_name") -eq 1 ]; then
	echo "ERROR: User '$user_name' exists already"
	exit 0
else
	if [ $OS == "centos" ]; then
		sudo adduser $user_name
	else 
		sudo adduser --disabled-password --gecos "" $user_name
	fi
	#check if user really created 
	if [ ! $(user_exists "$user_name") -eq 1 ]; then
		echo "ERROR: Cannot create user '$user_name'"
		exit 0
	else
		echo "User '$user_name' created"
	fi
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
	gitolite/install -ln ~/bin
	bin/gitolite setup -pk "$pk"
	rm -f "$pk"
EOF
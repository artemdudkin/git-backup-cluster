
#--------------check '@users' definition---------------

#get users
users=''
for entry in "./cfg/users"/*
do
  if [[ $entry != *"reclone_rsa"* ]] 
  then 
    users=$(echo $users $entry)
  fi
done
users=$(echo $users | sed "s/.\/cfg\/users\///g" | sed s/.pub//g)

#update user list at gitolite.conf
./update.sh users "$users"


#--------------copy users--------------

users=''
for entry in "./cfg/users"/*
do
  entry=$(echo $entry | sed "s/.\/cfg\/users\///g")
  if [ ! -f "../gitolite-admin/keydir/$entry" ]; then
    echo "copy "$entry
    cp   ./cfg/users/"$entry" ../gitolite-admin/keydir/"$entry"
  fi
done

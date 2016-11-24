#--------------check '@projects' definition---------------

repos=$(cat ./cfg/repos)
./update.sh projects "$repos"


#--------------check for line 'repo @projects'---------------

if grep -q "^repo @projects" ../gitolite-admin/conf/gitolite.conf; then
	echo ""
else
	echo "

repo @projects

" >> ../gitolite-admin/conf/gitolite.conf
fi


#--------------check for permission--------------

lines=$(sed -n '/repo @projects/{:a;n;/repo/b;p;ba}' ../gitolite-admin/conf/gitolite.conf)

users=''
reclone_rsa=''
while read -r line; do
  if [[ "$lines" == *RW*=*@users* ]]; then
    users='ok'
  fi
  if [[ "$lines" == *R*=*reclone_rsa* ]]; then
    reclone_rsa='ok'
  fi
done <<< "$lines"

if [ -z "$users" ]; then
  echo 'adding RW = @users'
  sed '/^repo @projects/a     RW = @users' ../gitolite-admin/conf/gitolite.conf > ./tmp
  mv ./tmp ../gitolite-admin/conf/gitolite.conf
fi

if [ -z "$reclone_rsa" ]; then
  echo 'adding R = reclone_rsa'
  sed '/^repo @projects/a     R  = reclone_rsa' ../gitolite-admin/conf/gitolite.conf > ./tmp
  mv ./tmp ../gitolite-admin/conf/gitolite.conf
fi

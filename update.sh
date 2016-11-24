if [ -z "$1" ] || [ -z "$2" ]
then
    echo -e '\n  Usage: ./update.sh <prop-name> <additional-prop-value>\n'
else

   if grep -q ^@$1 ../gitolite-admin/conf/gitolite.conf; then
	echo "updating @$1 at gitolite.conf..."

	str=$(cat ../gitolite-admin/conf/gitolite.conf | grep "^@$1" | sed "s/^@$1[[:blank:]]*=//" | sed s/^[[:blank:]]//)
	additional_str=$2
	old_str=$str

	#add repos from file 'repos' to $conf
	export IFS=" "
	for word in $additional_str; do
	  if [[ $str != *"$word"* ]]
	  then
	    str=$(echo $str $word)
	  fi
	done
	
	if [ "$str" == "$old_str" ]
	then
		echo 'up-to-date, skipped.';
	else
		#save $conf to @projects at gitolite.conf
		cat ../gitolite-admin/conf/gitolite.conf | sed "/^@$1/s/.*/@$1 = $str/"  > ./tmp 
                mv ./tmp ../gitolite-admin/conf/gitolite.conf
		echo 'done.'
	fi

   else
	echo 'adding @$1 to gitolite.conf...'

	#sed -i "1s/^/@$1 = $2\n/" ../gitolite-admin/conf/gitolite.conf
	
	mv ../gitolite-admin/conf/gitolite.conf ./tmp
	printf "@$1 = $2\n" > ../gitolite-admin/conf/gitolite.conf
	cat ./tmp >> ../gitolite-admin/conf/gitolite.conf
        rm -rf ./tmp
        
	echo 'done.'
   fi
fi

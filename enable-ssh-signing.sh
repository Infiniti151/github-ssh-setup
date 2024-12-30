#!/usr/bin/bash

getKey() {
	for i in "${ssh_keys[@]}"
	do
		if [[ $(awk '{print $1}' $i) = "ssh-ed25519" && $(awk '{print $3}' $i) = $1 ]];then
			ssh_public_key=$i
			return 1
		fi
	done
}

createNewKey () {
    echo -e "\033[0;36m>Creating new SSH key\033[0m"
    if [ -f ~/.ssh/id_ed25519 ];then
        ssh_private_key=~/.ssh/id_github_ed25519
    else
        ssh_private_key=~/.ssh/id_ed25519
    fi
    ssh_public_key=$ssh_private_key.pub
    ssh-keygen -t ed25519 -C $email -f $ssh_private_key
    addKeyToAgent
}

addKeyToAgent() {
    echo -e "\033[0;36m>Adding key to SSH agent\033[0m"
    ssh-add $ssh_private_key
}

echo "Enter Github email:"
read email
readarray -t ssh_keys < <(find ~/.ssh -type f -name "*.pub")
getKey $email
if [[ ! -z $ssh_public_key ]];then 
    echo "Existing key ($ssh_public_key) for email $email already exists. Do you want to use it for Github signing? (y/n)";
    read a
    if [[ $a = "y" || $a = "Y" ]];then
        echo -e "\033[0;36m>Using existing SSH key\033[0m"
        if echo "$(ssh-add -L)" | grep -q "$(cat $ssh_public_key)"; then 
            echo -e "\033[0;36m>Key already added to ssh-agent\033[0m" 
        else
            ssh_private_key=$(echo $ssh_public_key | awk '{sub(/.pub/,""); print}')
            addKeyToAgent
        fi
    else
        createNewKey       
    fi
else
    createNewKey
fi
git config --global gpg.format ssh
echo -e "\033[0;36m>Enabled SSH for Git globally\033[0m"
git config --global user.signingkey $ssh_public_key
echo -e "\033[0;36m>Enabled SSH signing key ($ssh_public_key) for Git globally\033[0m"
git config --global commit.gpgsign true
echo -e "\033[0;36m>Enabled Git commit signing globally\033[0m"
echo -e "\n\033[0;32m\e[4:3mInstructions for adding SSH signing key in Github\e[4:0m\033[0m"
echo ">Go to Github account settings > SSH and GPG keys > New SSH key"
echo ">Set a key name"
echo -e ">Choose key type as \033[0;33mSigning Key\033[0m"
echo -e ">Set key as \033[0;33m$(cat $ssh_public_key)\033[0m"
echo -e "\nNote: The same key can be added as an authentication key by following the above steps and choosing key type as \033[0;33mAuthentication Key\033[0m"

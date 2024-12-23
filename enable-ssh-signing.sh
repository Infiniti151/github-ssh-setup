#!/usr/bin/bash

createNewKey () {
    echo "Creating new SSH key";
    if [ -f ~/.ssh/id_ed25519 ];then
        ssh_private_key=~/.ssh/id_github_ed25519
    else
        ssh_private_key=~/.ssh/id_ed25519
    fi
    ssh-keygen -t ed25519 -C $email -f $ssh_private_key
}

echo "Enter Github email:"
read email
ssh_public_key=$(find ~/.ssh -type f -name "*ed25519.pub")
if [ ! -z $ssh_public_key ] && [ "$(awk '{print $3}' $ssh_public_key)" = $email ];then 
    echo "Existing key ($ssh_public_key) for email $email already exists. Do you want to use it for Github signing? (y/n)";
    read a
    if [ $a = "y" ];then
        echo "Using existing SSH key";
        ssh_private_key=$(echo $ssh_public_key | awk '{sub(/.pub/,""); print}')
    else
        createNewKey
        ssh_public_key=$ssh_private_key.pub
    fi
else
    createNewKey
    ssh_public_key=$ssh_private_key.pub
fi
echo -e "\033[0;36m>Adding key to SSH agent\033[0m"
ssh-add $ssh_private_key
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



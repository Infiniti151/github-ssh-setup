#!/usr/bin/bash

echo "Enter Github email:"
read email
ssh-keygen -t ed25519 -C $email
echo -e "\033[0;36m>Adding key to SSH agent\033[0m"
ssh-add ~/.ssh/id_ed25519
git config --global gpg.format ssh
echo -e "\033[0;36m>Enabled SSH for Git globally\033[0m"
git config --global user.signingkey ~/.ssh/id_ed25519.pub
echo -e "\033[0;36m>Enabled SSH signing key (~/.ssh/id_ed25519.pub) for Git globally\033[0m"
git config --global commit.gpgsign true
echo -e "\033[0;36m>Enabled Git commit signing globally\033[0m"
echo -e "\n\033[0;32m\e[4:3mInstructions for adding SSH signing key in Github\e[4:0m\033[0m"
echo ">Go to Github account settings > SSH and GPG keys > New SSH key"
echo ">Set a key name"
echo -e ">Choose key type as \033[0;33mSigning Key\033[0m"
echo -e ">Set key as \033[0;33m$(cat ~/.ssh/id_ed25519.pub)\033[0m"
echo -e "\nNote: The same key can be added as an authentication key by following the above steps and choosing key type as \033[0;33mAuthentication Key\033[0m"



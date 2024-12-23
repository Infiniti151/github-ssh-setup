# github-ssh-setup

Sets up commit signing for Github in Linux/Windows

This script does the following:

1. Creates a new SSH key (If a key doesn't already exist)
2. Adds the key to SSH agent (If not already added)
3. Enables SSH for Git globally
4. Enables the SSH signing key for Git globally
5. Enables Git commit signing globally
6. Gives instructions on how to register the SSH key as a signing key and optionally as an authentication key on Github

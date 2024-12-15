$email = Read-Host "Enter Github email"
ssh-keygen -t ed25519 -C $email
ssh-add "C:/Users/$($Env:UserName)/.ssh/id_ed25519"
git config --global gpg.format ssh
Write-Host  ">Enabled SSH for Git globally" -ForegroundColor Cyan
git config --global user.signingkey ~/.ssh/id_ed25519.pub
Write-Host  ">Enabled SSH signing key (~/.ssh/id_ed25519.pub) for Git globally" -ForegroundColor Cyan
git config --global commit.gpgsign true
Write-Host ">Enabled Git commit signing globally" -ForegroundColor Cyan
Write-Host "`n$([char]27)[4:3mInstructions for adding SSH signing key in Github$([char]27)[24:3m" -ForegroundColor Green
Write-Host ">Go to Github account settings > SSH and GPG keys > New SSH key"
Write-Host ">Set a key name"
Write-Host ">Choose key type as " -NoNewline; Write-Host "Signing Key" -ForegroundColor Yellow
Write-Host ">Set key as " -NoNewline; Write-Host $(cat ~/.ssh/id_ed25519.pub) -ForegroundColor Yellow
Write-Host "`nNote: The same key can be added as an authentication key by following the above steps and choosing key type as " -NoNewline; Write-Host "Authentication Key" -ForegroundColor Yellow
Read-Host -Prompt "`nPress Enter to exit..."

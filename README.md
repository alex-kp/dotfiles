dotfiles
--------

Reinstalling?

```
sudo apt update
sudo apt upgrade
echo ".cfg" >> .gitignore
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
git clone --bare https://github.com/alex-kp/dotfiles.git $HOME/.cfg
rm .gitignore
config checkout
exec bash
config-bootstrap
exec bash
```

Hold your nerve after the first `exec bash`, the prompt won't work until the
end of the process.  Install time is approx ten mins.

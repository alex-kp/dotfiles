if which ruby >/dev/null && which gem >/dev/null; then
    NEWPATH="$(ruby -r rubygems -e 'puts Gem.user_dir')/bin"
    pathprepend ${NEWPATH}
fi

# Support for dotfiles, see ref:
# https://www.atlassian.com/git/tutorials/dotfiles
#
# then additional tips:
#   https://drewdevault.com/2019/12/30/dotfiles.html
#   https://dotfiles.github.io/
#   https://wiki.archlinux.org/title/Dotfiles

export DOTFILES_GIT_DIR=${HOME}/.cfg
alias config='/usr/bin/git --git-dir=${DOTFILES_GIT_DIR} --work-tree=$HOME'

# This makes .bashrc source the files in .bashrc.d
config-add-bashrc-d () {
    # Only add the line if it's not already there..
    LINE="source ${HOME}/.bashrc.d/loader.sh"
    FILE="${HOME}/.bashrc"
    grep -qF -- "$LINE" "$FILE" || echo "$LINE" >> "$FILE"
}

config-submodule-add () {
    # shallow submodule, see:
    # https://stackoverflow.com/questions/2144406/
    #   how-to-make-shallow-git-submodules
    ( cd ~ &&       # start from home dir
        config config -f .gitmodules submodule.${2}.shallow true &&
        config submodule add --depth 1 \
            https://github.com/${1}.git ${2}
    )
}


# Skeleton for bootstrap on fresh Ubuntu install
config-bootstrap () {   #TODO: Does not work yet
    # Make sure that the required packages are installed
    # Install the fonts
    # Init all the submodules
    # Setup for YCM:
    ( cd ~/.vim/pack/plugins/start/YouCompleteMe &&
        python3 install.py --all )
    # Vimspector plugin installs
    vim +":VimspectorInstall debugpy" +qall

    config-add-bashrc-d
    # install fzf
    .fzf/install --key-bindings --completion --no-update-rc
}

alias vim-plugin-list='tree .vim/pack/plugins/ -L 2 -d'

# Generate the helptags for the new module
vim-update-helptags () {
    vim +"helptags ALL" +qall
}

# shapeshed link ref:
#   https://shapeshed.com/vim-packages/
vim-plugin-add () {
    SNAME=`echo ${1} | sed 's:.*/::'`
    SUBMODPATH=".vim/pack/plugins/start/${SNAME}"
    config-submodule-add ${1} ${SUBMODPATH}
    vim-update-helptags
}

vim-plugin-remove () {
    ( cd ~ &&       # start from home dir
        SNAME=`echo ${1} | sed 's:.*/::'`
        SUBMODPATH=".vim/pack/plugins/start/${SNAME}"
        config submodule deinit -f -- ${SUBMODPATH} &&
        rm -rf ${DOTFILES_GIT_DIR}/modules/${SUBMODPATH} &&
        config rm -f ${SUBMODPATH}
    )
    vim-update-helptags
}

vim-plugin-update-all () {
    config submodule update --rebase --remote
}


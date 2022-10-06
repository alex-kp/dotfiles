# Support for dotfiles, see ref:
# https://www.atlassian.com/git/tutorials/dotfiles
#
# then additional tips:
#   https://drewdevault.com/2019/12/30/dotfiles.html
#   https://dotfiles.github.io/
#   https://wiki.archlinux.org/title/Dotfiles

# This isn't an alias but allows us run more things from the .bashrc context by
# loading scripts from the .bashrc.d directory:
source /home/dev/.bashrc.d/loader.sh

export DOTFILES_GIT_DIR=${HOME}/.cfg
alias config='/usr/bin/git --git-dir=${DOTFILES_GIT_DIR} --work-tree=$HOME'

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

config-fontinstall () {
    FONTDIR="${HOME}/.local/share/fonts"
    # Install the fonts
    ( mkdir -p ${FONTDIR} &&
        cd ${FONTDIR} &&
        wget -c https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/SourceCodePro.zip &&
        unzip SourceCodePro.zip )
    #rm SourceCodePro.zip
}

# Skeleton for bootstrap on fresh Ubuntu install
config-bootstrap () {   #TODO: Does not work yet
    # Make sure that the required packages are installed
    source ~/package-list
    # Install the fonts
    config-fontinstall
    # Init all the submodules
    config submodule init
    config submodule update
    # Setup for YCM:
    vim-ycm-reinstall
    # Vimspector plugin installs
    vim +":VimspectorInstall debugpy" +qall
    # install fzf
    ~/.fzf/install --key-bindings --completion --no-update-rc
}

alias vim-plugin-list='tree .vim/pack/plugins/ -L 2 -d'

vim-ycm-reinstall () {
    ( cd ~/.vim/pack/plugins/start/YouCompleteMe &&
        git submodule update --init --recursive &&
        python3 install.py --clangd-completer --cs-completer --rust-completer --ts-completer )
}

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


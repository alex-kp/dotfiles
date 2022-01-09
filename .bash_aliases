# Support for dotfiles, see ref:
# https://www.atlassian.com/git/tutorials/dotfiles
#
# then additional tips:
#   https://drewdevault.com/2019/12/30/dotfiles.html
#   https://dotfiles.github.io/
#   https://wiki.archlinux.org/title/Dotfiles

export DOTFILES_GIT_DIR=${HOME}/.cfg
alias config='/usr/bin/git --git-dir=${DOTFILES_GIT_DIR} --work-tree=$HOME'

# Skeleton for bootstrap on fresh Ubuntu install
config-bootstrap () {   #TODO: Does not work yet
    # Make sure that the required packages are installed
    # Install the fonts
    # Init all the submodules
    # Setup for YCM:
    ( cd ~/.vim/pack/plugins/start/YouCompleteMe &&
        python3 install.py --all )
}

# shapeshed link ref:
#   https://shapeshed.com/vim-packages/
vim-plugin-add () {
    # shallow submodule, see:
    # https://stackoverflow.com/questions/2144406/
    #   how-to-make-shallow-git-submodules
    ( cd ~ &&       # start from home dir
        SNAME=`echo ${1} | sed 's:.*/::'`
        SUBMODPATH=".vim/pack/plugins/start/${SNAME}"
        config config -f .gitmodules submodule.${SUBMODPATH}.shallow true &&
        config submodule add --depth 1 \
            https://github.com/${1}.git ${SUBMODPATH}
    )
}

vim-plugin-remove () {
    ( cd ~ &&       # start from home dir
        SNAME=`echo ${1} | sed 's:.*/::'`
        SUBMODPATH=".vim/pack/plugins/start/${SNAME}"
        config submodule deinit -f -- ${SUBMODPATH} &&
        rm -rf ${DOTFILES_GIT_DIR}/modules/${SUBMODPATH} &&
        config rm -f ${SUBMODPATH}
    )

}
#vim-plugin-update(-all)

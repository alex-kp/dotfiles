sudo apt install -y git \
                 libatk1.0-dev \
                 libcairo2-dev \
                 libgtk-3-dev \
                 liblua5.1-0-dev \
                 libncurses-dev \
                 libperl-dev \
                 libx11-dev \
                 libxpm-dev \
                 libxt-dev \
                 lua5.1 \
                 python3-dev \
                 ruby-dev  && \
pushd .  && \
    mkdir -p ~/build && \
    cd ~/build && \
    rm -rf vim && \
    git clone --depth=1 https://github.com/vim/vim.git && \
    cd vim/src && \
    ./configure --prefix=${HOME}/.local --enable-gui=gtk3 \
        --with-features=huge --enable-multibyte --enable-rubyinterp=yes \
        --enable-python3interp=yes --with-python3-command=python3 \
        --with-python3-config-dir=$(python3-config --configdir) \
        --enable-perlinterp=yes --enable-cscope && \
    make -j32 && \
    make install && \
    popd

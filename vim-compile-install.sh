pushd .  && \
    mkdir -p ~/build && \
    cd ~/build && \
    rm -rf vim && \
    git clone --depth=1 https://github.com/vim/vim.git && \
    cd vim/src && \
    ./configure --prefix=/home/dev/.local --enable-gui=gtk3 \
        --with-features=huge --enable-multibyte --enable-rubyinterp=yes \
        --enable-python3interp=yes --with-python3-command=$PYTHON_VER \
        --with-python3-config-dir=$(python3-config --configdir) \
        --enable-perlinterp=yes --enable-cscope && \
    make -j32 && \
    make install && \
    popd

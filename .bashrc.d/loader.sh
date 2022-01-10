bashrc_dir=${HOME}/.bashrc.d
loader_filename=loader.sh
if [ -d ${bashrc_dir} ]; then
    for x in ${bashrc_dir}/* ; do
        if [[ "${x##*/}" != "${loader_filename}" ]]; then
            test -f "$x" || continue
            . "$x"
        fi
    done
fi
unset bashrc_dir loader_filename

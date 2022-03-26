# loader.sh
# Load the other scripts in this directory

# Utility functions for adding things to $PATH in an idempotent way
# from: https://superuser.com/questions/39751
pathappend() {
  for ARG in "$@"
  do
    if [ -d "$ARG" ] && [[ ":$PATH:" != *":$ARG:"* ]]; then
        PATH="${PATH:+"$PATH:"}$ARG"
    fi
  done
}
pathprepend() {
  for ((i=$#; i>0; i--)); 
  do
    ARG=${!i}
    if [ -d "$ARG" ] && [[ ":$PATH:" != *":$ARG:"* ]]; then
        PATH="$ARG${PATH:+":$PATH"}"
    fi
  done
}

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

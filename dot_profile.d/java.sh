if [ -d ${HOME}/.jenv ]; then 
# stolen from https://superuser.com/a/39995
    pathadd "${HOME}/.jenv/bin"
    eval "$(jenv init -)"
fi

export CLASSPATH=.:$CLASSPATH

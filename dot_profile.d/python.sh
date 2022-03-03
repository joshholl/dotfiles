if [ -d $HOME/.pyenv ]; then
	export PYENV_ROOT="$HOME/.pyenv"
	export PATH="$PYENV_ROOT/bin:$PATH"
	export PYENV_VIRTUALENVWRAPPER_PREFER_PYVENV="true"
	eval "$(pyenv init -)"
	eval "$(pyenv virtualenv-init -)"
	source $PYENV_ROOT/completions/pyenv.zsh
fi

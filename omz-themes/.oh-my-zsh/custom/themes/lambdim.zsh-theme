# Lambda IMproved

# Lifted from ys.zsh-theme
VIRTUAL_ENV_DISABLE_PROMPT=1
YS_THEME_VIRTUALENV_PROMPT_PREFIX="%{$fg_bold[magenta]%}("
YS_THEME_VIRTUALENV_PROMPT_SUFFIX=")%{$reset_color%} "
virtenv_prompt_info() {
	[[ -n "${VIRTUAL_ENV:-}" ]] || return
	echo "${YS_THEME_VIRTUALENV_PROMPT_PREFIX}${VIRTUAL_ENV:t}${YS_THEME_VIRTUALENV_PROMPT_SUFFIX}"
}

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[yellow]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "

PROMPT='%{$fg[blue]%}%* %{$fg[cyan]%}%~ $(virtenv_prompt_info)$(git_prompt_info)%{$fg_bold[green]%}λ%{$reset_color%} '

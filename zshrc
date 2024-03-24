
export PATH=/sbin:/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin

# Antigen: https://github.com/zsh-users/antigen
ANTIGEN="$HOME/.local/bin/antigen.zsh"

# Install antigen.zsh if not exist
if [ ! -f "$ANTIGEN" ]; then
	echo "Installing antigen ..."
	[ ! -d "$HOME/.local" ] && mkdir -p "$HOME/.local" 2> /dev/null
	[ ! -d "$HOME/.local/bin" ] && mkdir -p "$HOME/.local/bin" 2> /dev/null
	[ ! -f "$HOME/.z" ] && touch "$HOME/.z"
	URL="https://raw.githubusercontent.com/zsh-users/antigen/master/bin/antigen.zsh"
	TMPFILE="/tmp/antigen.zsh"
	if [ -x "$(which curl)" ]; then
		curl -L "$URL" -o "$TMPFILE" 
	elif [ -x "$(which wget)" ]; then
		wget "$URL" -O "$TMPFILE" 
	else
		echo "ERROR: please install curl or wget before installation !!"
		exit
	fi
	if [ ! $? -eq 0 ]; then
		echo ""
		echo "ERROR: downloading antigen.zsh ($URL) failed !!"
		exit
	fi;
	echo "move $TMPFILE to $ANTIGEN"
	mv "$TMPFILE" "$ANTIGEN"
fi


# Initialize command prompt
export PS1="%n@%m:%~%# "

# Initialize antigen
source "$ANTIGEN"

# Load local bash/zsh compatible settings
[ -f "$HOME/.local/etc/init.sh" ] && source "$HOME/.local/etc/init.sh"


# Initialize oh-my-zsh
antigen use oh-my-zsh


# default bundles
# visit https://github.com/unixorn/awesome-zsh-plugins
antigen bundle git
antigen bundle heroku
antigen bundle pip
antigen bundle svn-fast-info

antigen bundle zsh-users/zsh-autosuggestions
antigen bundle popstas/zsh-command-time
antigen bundle tymm/zsh-directory-history
antigen bundle RobSis/zsh-completion-generator
antigen bundle wting/autojump
antigen bundle zdharma/fast-syntax-highlighting
antigen bundle b4b4r07/enhancd
#antigen bundle psprint/zsh-editing-workbench
antigen bundle lukechilds/zsh-nvm
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle MichaelAquilina/zsh-you-should-use
antigen bundle extract
#antigen bundle nojhan/liquidprompt

# antigen bundle command-not-find

antigen bundle colorize
antigen bundle github
antigen bundle python
antigen bundle z

antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions

# uncomment the line below to enable theme
# antigen theme ys


# check login shell
if [[ -o login ]]; then
	[ -f "$HOME/.local/etc/login.sh" ] && source "$HOME/.local/etc/login.sh"
	[ -f "$HOME/.local/etc/login.zsh" ] && source "$HOME/.local/etc/login.zsh"
fi
    source ~/.docker.zsh


# syntax color definition
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)

typeset -A ZSH_HIGHLIGHT_STYLES

# ZSH_HIGHLIGHT_STYLES[command]=fg=white,bold
# ZSH_HIGHLIGHT_STYLES[alias]='fg=magenta,bold'



# load local config
[ -f "$HOME/.local/etc/config.zsh" ] && source "$HOME/.local/etc/config.zsh" 
[ -f "$HOME/.local/etc/local.zsh" ] && source "$HOME/.local/etc/local.zsh"

# enable syntax highlighting
antigen bundle zsh-users/zsh-syntax-highlighting
antigen theme  half-life
antigen apply

# setup for deer



autoload bashcompinit
bashcompinit





[[ -s ~/.autojump/etc/profile.d/autojump.sh ]] && . ~/.autojump/etc/profile.d/autojump.sh






# default keymap
bindkey -s '\ee' 'vim\n'
bindkey '\eh' backward-char
bindkey '\el' forward-char
bindkey '\ej' down-line-or-history
bindkey '\ek' up-line-or-history
#bindkey '\eu' undo
#bindkey '\eH' backward-word
#bindkey '\eL' forward-word
bindkey '\eJ' beginning-of-line
bindkey '\eK' end-of-line

#自定义的

bindkey '^u' undo
bindkey '^J' backward-word
bindkey '^K' forward-word
bindkey '^B' beginning-of-line
bindkey '^N' end-of-line
#删词，用于ttyd
bindkey "^p"    backward-delete-word
bindkey "^w"    backward-delete-word

bindkey -s '\eo' 'cd ..\n'
bindkey -s '\e;' 'lk\n'

bindkey '\e[1;3D' backward-word
bindkey '\e[1;3C' forward-word
bindkey '\e[1;3A' beginning-of-line
bindkey '\e[1;3B' end-of-line

bindkey '\ev' deer

alias lk='k --no-vcs'
export EDITOR='nano'
export BAT_THEME="ansi-light"


setopt nonomatch

#compdef _lxc lxc

# zsh completion for lxc                                  -*- shell-script -*-

__lxc_debug()
{
    local file="$BASH_COMP_DEBUG_FILE"
    if [[ -n ${file} ]]; then
        echo "$*" >> "${file}"
    fi
}

_lxc()
{
    local shellCompDirectiveError=1
    local shellCompDirectiveNoSpace=2
    local shellCompDirectiveNoFileComp=4
    local shellCompDirectiveFilterFileExt=8
    local shellCompDirectiveFilterDirs=16

    local lastParam lastChar flagPrefix requestComp out directive compCount comp lastComp
    local -a completions

    __lxc_debug "\n========= starting completion logic =========="
    __lxc_debug "CURRENT: ${CURRENT}, words[*]: ${words[*]}"

    # The user could have moved the cursor backwards on the command-line.
    # We need to trigger completion from the $CURRENT location, so we need
    # to truncate the command-line ($words) up to the $CURRENT location.
    # (We cannot use $CURSOR as its value does not work when a command is an alias.)
    words=("${=words[1,CURRENT]}")
    __lxc_debug "Truncated words[*]: ${words[*]},"

    lastParam=${words[-1]}
    lastChar=${lastParam[-1]}
    __lxc_debug "lastParam: ${lastParam}, lastChar: ${lastChar}"

    # For zsh, when completing a flag with an = (e.g., lxc -n=<TAB>)
    # completions must be prefixed with the flag
    setopt local_options BASH_REMATCH
    if [[ "${lastParam}" =~ '-.*=' ]]; then
        # We are dealing with a flag with an =
        flagPrefix="-P ${BASH_REMATCH}"
    fi

    # Prepare the command to obtain completions
    requestComp="${words[1]} __complete ${words[2,-1]}"
    if [ "${lastChar}" = "" ]; then
        # If the last parameter is complete (there is a space following it)
        # We add an extra empty parameter so we can indicate this to the go completion code.
        __lxc_debug "Adding extra empty parameter"
        requestComp="${requestComp} \"\""
    fi

    __lxc_debug "About to call: eval ${requestComp}"

    # Use eval to handle any environment variables and such
    out=$(eval ${requestComp} 2>/dev/null)
    __lxc_debug "completion output: ${out}"

    # Extract the directive integer following a : from the last line
    local lastLine
    while IFS='\n' read -r line; do
        lastLine=${line}
    done < <(printf "%s\n" "${out[@]}")
    __lxc_debug "last line: ${lastLine}"

    if [ "${lastLine[1]}" = : ]; then
        directive=${lastLine[2,-1]}
        # Remove the directive including the : and the newline
        local suffix
        (( suffix=${#lastLine}+2))
        out=${out[1,-$suffix]}
    else
        # There is no directive specified.  Leave $out as is.
        __lxc_debug "No directive found.  Setting do default"
        directive=0
    fi

    __lxc_debug "directive: ${directive}"
    __lxc_debug "completions: ${out}"
    __lxc_debug "flagPrefix: ${flagPrefix}"

    if [ $((directive & shellCompDirectiveError)) -ne 0 ]; then
        __lxc_debug "Completion received error. Ignoring completions."
        return
    fi

    compCount=0
    while IFS='\n' read -r comp; do
        if [ -n "$comp" ]; then
            # If requested, completions are returned with a description.
            # The description is preceded by a TAB character.
            # For zsh's _describe, we need to use a : instead of a TAB.
            # We first need to escape any : as part of the completion itself.
            comp=${comp//:/\\:}

            local tab=$(printf '\t')
            comp=${comp//$tab/:}

            ((compCount++))
            __lxc_debug "Adding completion: ${comp}"
            completions+=${comp}
            lastComp=$comp
        fi
    done < <(printf "%s\n" "${out[@]}")

    if [ $((directive & shellCompDirectiveFilterFileExt)) -ne 0 ]; then
        # File extension filtering
        local filteringCmd
        filteringCmd='_files'
        for filter in ${completions[@]}; do
            if [ ${filter[1]} != '*' ]; then
                # zsh requires a glob pattern to do file filtering
                filter="\*.$filter"
            fi
            filteringCmd+=" -g $filter"
        done
        filteringCmd+=" ${flagPrefix}"

        __lxc_debug "File filtering command: $filteringCmd"
        _arguments '*:filename:'"$filteringCmd"
    elif [ $((directive & shellCompDirectiveFilterDirs)) -ne 0 ]; then
        # File completion for directories only
        local subDir
        subdir="${completions[1]}"
        if [ -n "$subdir" ]; then
            __lxc_debug "Listing directories in $subdir"
            pushd "${subdir}" >/dev/null 2>&1
        else
            __lxc_debug "Listing directories in ."
        fi

        _arguments '*:dirname:_files -/'" ${flagPrefix}"
        if [ -n "$subdir" ]; then
            popd >/dev/null 2>&1
        fi
    elif [ $((directive & shellCompDirectiveNoSpace)) -ne 0 ] && [ ${compCount} -eq 1 ]; then
        __lxc_debug "Activating nospace."
        # We can use compadd here as there is no description when
        # there is only one completion.
        compadd -S '' "${lastComp}"
    elif [ ${compCount} -eq 0 ]; then
        if [ $((directive & shellCompDirectiveNoFileComp)) -ne 0 ]; then
            __lxc_debug "deactivating file completion"
        else
            # Perform file completion
            __lxc_debug "activating file completion"
            _arguments '*:filename:_files'" ${flagPrefix}"
        fi
    else
        _describe "completions" completions $(echo $flagPrefix)
    fi
}
###################################sftpgo##############################
#compdef _sftpgo sftpgo

# zsh completion for sftpgo                               -*- shell-script -*-

__sftpgo_debug()
{
    local file="$BASH_COMP_DEBUG_FILE"
    if [[ -n ${file} ]]; then
        echo "$*" >> "${file}"
    fi
}

_sftpgo()
{
    local shellCompDirectiveError=1
    local shellCompDirectiveNoSpace=2
    local shellCompDirectiveNoFileComp=4
    local shellCompDirectiveFilterFileExt=8
    local shellCompDirectiveFilterDirs=16

    local lastParam lastChar flagPrefix requestComp out directive compCount comp lastComp
    local -a completions

    __sftpgo_debug "\n========= starting completion logic =========="
    __sftpgo_debug "CURRENT: ${CURRENT}, words[*]: ${words[*]}"

    # The user could have moved the cursor backwards on the command-line.
    # We need to trigger completion from the $CURRENT location, so we need
    # to truncate the command-line ($words) up to the $CURRENT location.
    # (We cannot use $CURSOR as its value does not work when a command is an alias.)
    words=("${=words[1,CURRENT]}")
    __sftpgo_debug "Truncated words[*]: ${words[*]},"

    lastParam=${words[-1]}
    lastChar=${lastParam[-1]}
    __sftpgo_debug "lastParam: ${lastParam}, lastChar: ${lastChar}"

    # For zsh, when completing a flag with an = (e.g., sftpgo -n=<TAB>)
    # completions must be prefixed with the flag
    setopt local_options BASH_REMATCH
    if [[ "${lastParam}" =~ '-.*=' ]]; then
        # We are dealing with a flag with an =
        flagPrefix="-P ${BASH_REMATCH}"
    fi

    # Prepare the command to obtain completions
    requestComp="${words[1]} __complete ${words[2,-1]}"
    if [ "${lastChar}" = "" ]; then
        # If the last parameter is complete (there is a space following it)
        # We add an extra empty parameter so we can indicate this to the go completion code.
        __sftpgo_debug "Adding extra empty parameter"
        requestComp="${requestComp} \"\""
    fi

    __sftpgo_debug "About to call: eval ${requestComp}"

    # Use eval to handle any environment variables and such
    out=$(eval ${requestComp} 2>/dev/null)
    __sftpgo_debug "completion output: ${out}"

    # Extract the directive integer following a : from the last line
    local lastLine
    while IFS='\n' read -r line; do
        lastLine=${line}
    done < <(printf "%s\n" "${out[@]}")
    __sftpgo_debug "last line: ${lastLine}"

    if [ "${lastLine[1]}" = : ]; then
        directive=${lastLine[2,-1]}
        # Remove the directive including the : and the newline
        local suffix
        (( suffix=${#lastLine}+2))
        out=${out[1,-$suffix]}
    else
        # There is no directive specified.  Leave $out as is.
        __sftpgo_debug "No directive found.  Setting do default"
        directive=0
    fi

    __sftpgo_debug "directive: ${directive}"
    __sftpgo_debug "completions: ${out}"
    __sftpgo_debug "flagPrefix: ${flagPrefix}"

    if [ $((directive & shellCompDirectiveError)) -ne 0 ]; then
        __sftpgo_debug "Completion received error. Ignoring completions."
        return
    fi

    compCount=0
    while IFS='\n' read -r comp; do
        if [ -n "$comp" ]; then
            # If requested, completions are returned with a description.
            # The description is preceded by a TAB character.
            # For zsh's _describe, we need to use a : instead of a TAB.
            # We first need to escape any : as part of the completion itself.
            comp=${comp//:/\\:}

            local tab=$(printf '\t')
            comp=${comp//$tab/:}

            ((compCount++))
            __sftpgo_debug "Adding completion: ${comp}"
            completions+=${comp}
            lastComp=$comp
        fi
    done < <(printf "%s\n" "${out[@]}")

    if [ $((directive & shellCompDirectiveFilterFileExt)) -ne 0 ]; then
        # File extension filtering
        local filteringCmd
        filteringCmd='_files'
        for filter in ${completions[@]}; do
            if [ ${filter[1]} != '*' ]; then
                # zsh requires a glob pattern to do file filtering
                filter="\*.$filter"
            fi
            filteringCmd+=" -g $filter"
        done
        filteringCmd+=" ${flagPrefix}"

        __sftpgo_debug "File filtering command: $filteringCmd"
        _arguments '*:filename:'"$filteringCmd"
    elif [ $((directive & shellCompDirectiveFilterDirs)) -ne 0 ]; then
        # File completion for directories only
        local subDir
        subdir="${completions[1]}"
        if [ -n "$subdir" ]; then
            __sftpgo_debug "Listing directories in $subdir"
            pushd "${subdir}" >/dev/null 2>&1
        else
            __sftpgo_debug "Listing directories in ."
        fi

        _arguments '*:dirname:_files -/'" ${flagPrefix}"
        if [ -n "$subdir" ]; then
            popd >/dev/null 2>&1
        fi
    elif [ $((directive & shellCompDirectiveNoSpace)) -ne 0 ] && [ ${compCount} -eq 1 ]; then
        __sftpgo_debug "Activating nospace."
        # We can use compadd here as there is no description when
        # there is only one completion.
        compadd -S '' "${lastComp}"
    elif [ ${compCount} -eq 0 ]; then
        if [ $((directive & shellCompDirectiveNoFileComp)) -ne 0 ]; then
            __sftpgo_debug "deactivating file completion"
        else
            # Perform file completion
            __sftpgo_debug "activating file completion"
            _arguments '*:filename:_files'" ${flagPrefix}"
        fi
    else
        _describe "completions" completions $(echo $flagPrefix)
    fi
}

# don't run the completion function when being source-ed or eval-ed
if [ "$funcstack[1]" = "_sftpgo" ]; then
	_sftpgo
fi
##########################################
# don't run the completion function when being source-ed or eval-ed
if [ "$funcstack[1]" = "_lxc" ]; then
	_lxc
fi

export LC_CTYPE=en_US.UTF-8

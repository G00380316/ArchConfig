languages=$(echo "shell bash golang typescript lua cpp c nodejs zsh python java ruby rust" | tr ' ' '\n')
core_utils=$(echo "xargs find mv sed awk" | tr ' ' '\n')

selected=$(printf "%s\n%s" "$languages" "$core_utils" | fzf)
read -rp "query: " query

cmd=
if printf "%s" "$languages" | grep -qs "$selected"; then
	cmd="curl cht.sh/$selected/$(echo "$query" | tr ' ' '+')"
else
	cmd="curl cht.sh/$selected~$query"
fi

tmux neww zsh -c "$cmd & while [ : ]; do sleep 1; done"

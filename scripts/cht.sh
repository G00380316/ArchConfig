languages=$(echo "shell bash golang typescript lua cpp c nodejs zsh python java ruby rust dart csharp" | tr ' ' '\n')
core_utils=$(echo "xargs find mv sed awk" | tr ' ' '\n')

selected=$(printf "%s\n%s" "$languages" "$core_utils" | fzf)
read -rp "query: " query


if printf "%s" "$languages" | grep -qs "$selected"; then
	curl cht.sh/$selected/$(echo "$query" | tr ' ' '+')
else
	curl cht.sh/$selected~$query
fi




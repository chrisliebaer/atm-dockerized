#!/bin/bash
set -eu

# run atm script to install forge but set to install only
ATM9_INSTALL_ONLY=true ./startserver.sh

ATM_VERSION="UNKNOWN"
if  [[ -f .version ]]; then
	ATM_VERSION=$(cat .version)
fi

# force override settings
declare -A settings=(
	[allow-flight]=true
	[enable-rcon]=true
	[rcon.password]="password"
	[broadcast-rcon-to-ops]=false
	[motd]="All the Mods 9 v$ATM_VERSION"
)

for key in "${!settings[@]}"; do
	sed -i -e "s/$key=.*/$key=${settings[$key]}/" server.properties
done

FORGE_UNIX_ARGS="$(ls libraries/net/minecraftforge/forge/*/unix_args.txt)"
exec java @user_jvm_args.txt @${FORGE_UNIX_ARGS} nogui

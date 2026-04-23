#!/bin/zsh

# Force the Mac to know exactly where standard tools are located
export PATH="/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

clear

echo -e "\033[0;36m========================================================\033[0m"
echo -e "\033[0;36m             MAC VPN & PROXY DETECTIVE\033[0m"
echo -e "\033[0;36m========================================================\033[0m\n"

# Updated Keywords: Changed "Hola" to "Hola VPN" to prevent Spanish language false positives
KEYWORDS="VPN|Nord|ExpressVPN|Proton|Windscribe|Hotspot Shield|CyberGhost|TunnelBear|Surfshark|Psiphon|Betternet|ZenMate|SetupVPN|TouchVPN|Hola VPN"
typeset -a ACTIVE_VPNS

# ---------------------------------------------------------
# STEP 1: CHECK ACTIVE INSTALLATIONS & PROFILES
# ---------------------------------------------------------
echo -e "\033[1;33m[1] Checking Active Installations & Network Profiles...\033[0m"
FOUND_ACTIVE=0

while IFS= read -r app; do
    if [[ -n "$app" ]]; then
        echo -e "    \033[0;31m[!] FOUND INSTALLED APP: $app\033[0m"
        ACTIVE_VPNS+=("$app")
        FOUND_ACTIVE=1
    fi
done <<< "$(/bin/ls /Applications 2>/dev/null | /usr/bin/grep -iE "$KEYWORDS")"

while IFS= read -r profile; do
    if [[ -n "$profile" && ! "$profile" == *"An asterisk"* ]]; then
        echo -e "    \033[0;31m[!] FOUND NETWORK PROFILE: $profile\033[0m"
        FOUND_ACTIVE=1
    fi
done <<< "$(/usr/sbin/networksetup -listallnetworkservices 2>/dev/null | /usr/bin/grep -iE "$KEYWORDS")"

if [[ $FOUND_ACTIVE -eq 0 ]]; then
    echo -e "    \033[0;32m[OK] No active VPN installations or profiles found.\033[0m"
fi
echo ""

# ---------------------------------------------------------
# STEP 2: CHECK FOR LEFTOVERS
# ---------------------------------------------------------
echo -e "\033[1;33m[2] Checking for Leftover Files/Folders...\033[0m"
FOUND_LEFTOVERS=0

SEARCH_PATHS=(
    "$HOME/Library/Application Support"
    "$HOME/Library/Caches"
    "$HOME/Library/Preferences"
    "$HOME/Library/Containers"
    "$HOME/.Trash" 
    "/Library/Application Support"
)

for path in "${SEARCH_PATHS[@]}"; do
    if [[ -d "$path" ]]; then
        while IFS= read -r item; do
            if [[ -n "$item" ]]; then
                IS_DUP=0
                
                # Check if this item belongs to an app that is currently installed
                for active in "${ACTIVE_VPNS[@]}"; do
                    clean_active="${active%.*}"
                    if echo "$item" | /usr/bin/grep -qi "$clean_active"; then
                        IS_DUP=1
                        break
                    fi
                done

                # If it's not installed, but we found it... it's a leftover!
                if [[ $IS_DUP -eq 0 ]]; then
                    echo -e "    \033[0;35m[!] SUSPICIOUS LEFTOVER: $item\033[0m"
                    FOUND_LEFTOVERS=1
                fi
            fi
        done <<< "$(/bin/ls -1 "$path" 2>/dev/null | /usr/bin/grep -iE "$KEYWORDS")"
    fi
done

if [[ $FOUND_LEFTOVERS -eq 0 ]]; then
    echo -e "    \033[0;32m[OK] No obvious leftover folders found.\033[0m"
fi
echo ""

# ---------------------------------------------------------
# STEP 3: CHECK BROWSER EXTENSIONS
# ---------------------------------------------------------
echo -e "\033[1;33m[3] Checking Browser Extensions...\033[0m"
FOUND_EXT=0

process_manifest() {
    local browser_name=$1
    local manifest=$2
    local ext_dir="${manifest%/*}"
    local is_vpn=0

    # 1. Check main manifest file
    if /usr/bin/grep -qiE "$KEYWORDS" "$manifest"; then
        is_vpn=1
    else
        # 2. Check localized language files
        for locale_file in "$ext_dir"/_locales/*/messages.json(N); do
            if /usr/bin/grep -qiE "$KEYWORDS" "$locale_file"; then
                is_vpn=1
                break
            fi
        done
    fi

    # 3. If flagged, extract the name cleanly
    if [[ $is_vpn -eq 1 ]]; then
        local ext_name=$(/usr/bin/grep -m 1 -i '"name"' "$manifest" | /usr/bin/cut -d'"' -f4)
        
        # If the name is hidden behind an Apple __MSG_ variable, hunt down the translation
        if [[ "$ext_name" == *"__MSG_"* ]]; then
            # Clean up the key string
            local msg_key="${ext_name#__MSG_}"
            msg_key="${msg_key%__}"
            
            # Find the English dictionary file
            local msg_file="$ext_dir/_locales/en/messages.json"
            [[ ! -f "$msg_file" ]] && msg_file="$ext_dir/_locales/en_US/messages.json"
            
            if [[ -f "$msg_file" ]]; then
                # Extract the actual translated name
                local resolved_name=$(/usr/bin/grep -A 3 -i "\"$msg_key\"" "$msg_file" | /usr/bin/grep -m 1 -i '"message"' | /usr/bin/cut -d'"' -f4)
                [[ -n "$resolved_name" ]] && ext_name="$resolved_name"
            fi
        fi
        
        # Ultimate fallback if everything else fails
        if [[ -z "$ext_name" || "$ext_name" == *"__MSG_"* ]]; then
            local parent_dir="${ext_dir%/*}"
            local ext_id="${parent_dir##*/}"
            ext_name="Unknown Extension (ID: $ext_id)"
        fi
        
        echo -e "    \033[0;31m[!] FOUND EXTENSION: [$browser_name] $ext_name\033[0m"
        FOUND_EXT=1
    fi
}

for manifest in "$HOME/Library/Application Support/Google/Chrome"/*/Extensions/*/*/manifest.json(N); do
    process_manifest "Chrome" "$manifest"
done

for manifest in "$HOME/Library/Application Support/BraveSoftware/Brave-Browser"/*/Extensions/*/*/manifest.json(N); do
    process_manifest "Brave" "$manifest"
done

for manifest in "$HOME/Library/Application Support/Microsoft Edge"/*/Extensions/*/*/manifest.json(N); do
    process_manifest "Edge" "$manifest"
done

if [[ $FOUND_EXT -eq 0 ]]; then
    echo -e "    \033[0;32m[OK] No VPN browser extensions detected.\033[0m"
fi
echo ""

echo -e "\033[0;36m========================================================\033[0m"
echo -e "\033[0;36mScan Complete.\033[0m"
read "?Press [Enter] to continue..."

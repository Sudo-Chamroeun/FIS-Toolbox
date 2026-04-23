#!/bin/zsh

# Clear the terminal screen
clear

echo -e "\033[0;36m========================================================\033[0m"
echo -e "\033[0;36m             MAC VPN & PROXY DETECTIVE\033[0m"
echo -e "\033[0;36m========================================================\033[0m\n"

# VPN Keywords (Same as Windows)
KEYWORDS="VPN|Nord|ExpressVPN|Proton|Windscribe|Hotspot Shield|CyberGhost|TunnelBear|Surfshark|Psiphon|Betternet|ZenMate|SetupVPN|TouchVPN|Hola"

# Arrays to keep track of memory (Deduplication)
typeset -a ACTIVE_VPNS

# ---------------------------------------------------------
# STEP 1: CHECK ACTIVE INSTALLATIONS & PROFILES
# ---------------------------------------------------------
echo -e "\033[1;33m[1] Checking Active Installations & Network Profiles...\033[0m"
FOUND_ACTIVE=0

# 1a. Check /Applications folder
while IFS= read -r app; do
    if [[ -n "$app" ]]; then
        echo -e "    \033[0;31m[!] FOUND INSTALLED APP: $app\033[0m"
        ACTIVE_VPNS+=("$app")
        FOUND_ACTIVE=1
    fi
done <<< "$(ls /Applications | grep -iE "$KEYWORDS")"

# 1b. Check native Mac Network Profiles (System Preferences -> Network)
while IFS= read -r profile; do
    if [[ -n "$profile" && ! "$profile" == *"An asterisk"* ]]; then
        echo -e "    \033[0;31m[!] FOUND NETWORK PROFILE: $profile\033[0m"
        FOUND_ACTIVE=1
    fi
done <<< "$(networksetup -listallnetworkservices 2>/dev/null | grep -iE "$KEYWORDS")"

if [[ $FOUND_ACTIVE -eq 0 ]]; then
    echo -e "    \033[0;32m[OK] No active VPN installations or profiles found.\033[0m"
fi
echo ""

# ---------------------------------------------------------
# STEP 2: CHECK FOR LEFTOVERS ("The Sneaky Check")
# ---------------------------------------------------------
echo -e "\033[1;33m[2] Checking for Leftover Files/Folders...\033[0m"
FOUND_LEFTOVERS=0

# Check common Mac AppData equivalent locations
SEARCH_PATHS=(
    "$HOME/Library/Application Support"
    "$HOME/Library/Caches"
    "$HOME/Library/Preferences"
    "/Library/Application Support"
)

for path in "${SEARCH_PATHS[@]}"; do
    if [[ -d "$path" ]]; then
        # Find folders matching keywords, max depth 1 so it's fast
        while IFS= read -r folder; do
            if [[ -n "$folder" ]]; then
                # Simple deduplication check
                IS_DUP=0
                for active in "${ACTIVE_VPNS[@]}"; do
                    # Strip .app extension for comparison
                    clean_active="${active%.*}"
                    if echo "$folder" | grep -qi "$clean_active"; then
                        IS_DUP=1
                        break
                    fi
                done

                if [[ $IS_DUP -eq 0 ]]; then
                    echo -e "    \033[0;35m[!] SUSPICIOUS LEFTOVER: $folder\033[0m"
                    FOUND_LEFTOVERS=1
                fi
            fi
        done <<< "$(find "$path" -maxdepth 1 -type d -iname "*" 2>/dev/null | grep -iE "$KEYWORDS")"
    fi
done

if [[ $FOUND_LEFTOVERS -eq 0 ]]; then
    echo -e "    \033[0;32m[OK] No obvious leftover folders found.\033[0m"
fi
echo ""

# ---------------------------------------------------------
# STEP 3: CHECK BROWSER EXTENSIONS (Chrome, Brave, Edge)
# ---------------------------------------------------------
echo -e "\033[1;33m[3] Checking Browser Extensions...\033[0m"
FOUND_EXT=0

# Mac paths for Chromium browser extensions
CHROME_PATH="$HOME/Library/Application Support/Google/Chrome/*/Extensions/*/*/manifest.json"
BRAVE_PATH="$HOME/Library/Application Support/BraveSoftware/Brave-Browser/*/Extensions/*/*/manifest.json"
EDGE_PATH="$HOME/Library/Application Support/Microsoft Edge/*/Extensions/*/*/manifest.json"

# Function to scan manifests
scan_extensions() {
    local browser_name=$1
    local search_path=$2
    
    # We use zsh globbing to find the files
    for manifest in ${~search_path}(N); do
        if [[ -f "$manifest" ]]; then
            if grep -qiE "$KEYWORDS" "$manifest"; then
                ext_name=$(grep -i '"name"' "$manifest" | head -n 1 | awk -F'"' '{print $4}')
                
                if [[ "$ext_name" == *"__MSG_"* ]]; then
                    ext_dir=$(dirname "$manifest")
                    loc_file=$(find "$ext_dir/_locales" -name "messages.json" 2>/dev/null | head -n 1)
                    if [[ -n "$loc_file" ]]; then
                        ext_name=$(grep -iE "$KEYWORDS" "$loc_file" | head -n 1 | awk -F'"' '{print $4}')
                    fi
                fi
                
                if [[ -z "$ext_name" ]]; then
                    ext_name="Hidden/Localized VPN Extension"
                fi

                echo -e "    \033[0;31m[!] FOUND EXTENSION: [$browser_name] $ext_name\033[0m"
                FOUND_EXT=1
            fi
        fi
    done
}

scan_extensions "Chrome" "$CHROME_PATH"
scan_extensions "Brave" "$BRAVE_PATH"
scan_extensions "Edge" "$EDGE_PATH"

if [[ $FOUND_EXT -eq 0 ]]; then
    echo -e "    \033[0;32m[OK] No VPN browser extensions detected.\033[0m"
fi
echo ""

echo -e "\033[0;36m========================================================\033[0m"
echo -e "\033[0;36mScan Complete.\033[0m"
read "?Press [Enter] to continue..."

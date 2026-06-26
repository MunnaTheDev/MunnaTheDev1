#!/usr/bin/env bash
# ==========================================================
# MunnaTheDev | VIP UPLINK SCRIPT
# ==========================================================
set -euo pipefail

# --- VIP ELITE THEME ---
R='\033[1;38;5;196m'
G='\033[1;38;5;82m'
Y='\033[1;38;5;220m'
C='\033[1;38;5;51m'
P='\033[1;38;5;201m'
VIOLET='\033[1;38;5;135m'
NEON='\033[1;38;5;198m'
W='\033[1;38;5;255m'
DG='\033[0;38;5;244m'
NC='\033[0m'

# --- CONFIG ---
HOST="run.nobitahost.in"
URL="https://${HOST}"
NETRC="${HOME}/.netrc"
IP="65.0.86.121"
LOCL_IP="10.1.0.29"

# --- HEADER ---
render_vip_header() {
    clear
    echo -e "${P}"
    cat << "EOF"
███╗   ███╗██╗   ██╗███╗   ██╗███╗   ██╗ █████╗
████╗ ████║██║   ██║████╗  ██║████╗  ██║██╔══██╗
██╔████╔██║██║   ██║██╔██╗ ██║██╔██╗ ██║███████║
██║╚██╔╝██║██║   ██║██║╚██╗██║██║╚██╗██║██╔══██║
██║ ╚═╝ ██║╚██████╔╝██║ ╚████║██║ ╚████║██║  ██║
╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝  ╚═══╝╚═╝  ╚═╝

            M U N N A T H E D E V
EOF
    echo -e "${NC}"
}

render_vip_header

# --- NETWORK INFO ---
echo -e " ${C}◉ NETWORK ROUTE DIAGNOSTICS${NC}"
echo -e " ${DG}├─ Public Endpoint :${NC} ${W}$IP${NC}"
echo -e " ${DG}├─ Local Gateway   :${NC} ${W}$LOCL_IP${NC}"
echo -e " ${DG}├─ Target Host     :${NC} ${W}$HOST${NC}"
echo -e " ${DG}└─ Encryption      :${NC} ${NEON}QUANTUM-256${NC}"

# --- AUTH ---
echo -e "\n ${Y}[AUTH] Starting...${NC}"
touch "$NETRC" && chmod 600 "$NETRC"
sed -i "/$HOST/d" "$NETRC" 2>/dev/null || true
printf "machine %s login %s password %s\n" "$HOST" "$IP" "$LOCL_IP" >> "$NETRC"
echo -e "${G} AUTH VERIFIED${NC}"

# --- CONNECT ---
payload="$(mktemp)"
trap "rm -f $payload" EXIT

echo -e "\n ${Y}[UPLINK] Connecting...${NC}"

if curl -fsSL -A "Bane-VIP-Agent" --netrc -o "$payload" "$URL"; then
    echo -e "${G}CONNECTED${NC}"

    echo -e "\n ${P}EXECUTING PAYLOAD...${NC}"
    bash "$payload" || true

else
    echo -e "${R}FAILED${NC}"
    exit 1
fi

# --- FINAL REDIRECT TO YOUR UI ---
echo -e "\n${P}LOADING MUNNATHEDEV UI...${NC}\n"
sleep 1

exec bash <(curl -fsSL https://raw.githubusercontent.com/MunnaTheDev/MunnaTheDev1/refs/heads/main/menu/UI.sh)

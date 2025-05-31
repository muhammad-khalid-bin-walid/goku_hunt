#!/bin/bash

# ANSI color codes for output
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Log file for installation process
LOG_FILE="$(pwd)/install_tools.log"
: > "$LOG_FILE" || { echo -e "${RED}Failed to create log file: $LOG_FILE${NC}"; exit 1; }

# Log function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$LOG_FILE"
    echo -e "${YELLOW}$*${NC}"
}

# Check if a command exists
check_command() {
    command -v "$1" >/dev/null 2>&1
}

# Check if a file exists in /usr/local/bin
check_file() {
    [[ -f "/usr/local/bin/$1" ]]
}

# Detect Linux distribution
if check_command apt; then
    DISTRO="debian"
elif check_command pacman; then
    DISTRO="arch"
elif check_command dnf; then
    DISTRO="fedora"
else
    DISTRO="unknown"
    log "Warning: Unknown distribution, using generic installation methods"
fi

log "Starting tool installation on $DISTRO-based system"

# Install core dependencies
log "Installing core dependencies (git, python3, pip, curl, jq, ruby, go)"
case "$DISTRO" in
    debian)
        sudo apt update
        sudo apt install -y git python3 python3-pip curl jq ruby-dev golang-go || { log "Failed to install core dependencies"; exit 1; }
        ;;
    arch)
        sudo pacman -Syu --noconfirm
        sudo pacman -S --noconfirm git python python-pip curl jq ruby go || { log "Failed to install core dependencies"; exit 1; }
        ;;
    fedora)
        sudo dnf update -y
        sudo dnf install -y git python3 python3-pip curl jq ruby rubygems golang || { log "Failed to install core dependencies"; exit 1; }
        ;;
    *)
        log "Please install git, python3, python3-pip, curl, jq, ruby, and go manually"
        ;;
esac

# Install Python dependencies
log "Installing Python dependencies (requests, beautifulsoup4, arjun, dnsrecon, altdns)"
pip3 install --user requests beautifulsoup4 arjun dnsrecon altdns || { log "Failed to install Python dependencies"; exit 1; }
log "Python dependencies installed"

# Ensure ~/.local/bin is in PATH
if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
    echo 'export PATH=$PATH:$HOME/.local/bin' >> ~/.bashrc
    export PATH=$PATH:$HOME/.local/bin
    log "Added ~/.local/bin to PATH"
fi

# Install Go-based tools
install_go_tool() {
    local tool=$1
    local repo=$2
    local bin=$3
    if check_command "$bin"; then
        log "$bin already installed, skipping"
        return
    fi
    log "Installing $bin from $repo"
    go install -v "$repo@latest" || { log "Failed to install $bin"; return 1; }
    sudo mv ~/go/bin/"$bin" /usr/local/bin/ || { log "Failed to move $bin to /usr/local/bin"; return 1; }
    log "$bin installed successfully"
}

# Install Go-based tools
install_go_tool subfinder github.com/projectdiscovery/subfinder/v2/cmd/subfinder subfinder
install_go_tool assetfinder github.com/tomnomnom/assetfinder assetfinder
install_go_tool amass github.com/owasp-amass/amass/v4/... amass
install_go_tool httpx github.com/projectdiscovery/httpx/cmd/httpx httpx
install_go_tool katana github.com/projectdiscovery/katana/cmd/katana katana
install_go_tool waybackurls github.com/tomnomnom/waybackurls waybackurls
install_go_tool gf github.com/tomnomnom/gf gf
install_go_tool trufflehog github.com/trufflesecurity/trufflehog trufflehog
install_go_tool subzy github.com/lukasikic/subzy subzy
install_go_tool hakrawler github.com/hakluke/hakrawler hakrawler
install_go_tool gospider github.com/jaeles-project/gospider gospider
install_go_tool nuclei github.com/projectdiscovery/nuclei/v3/cmd/nuclei nuclei

# Configure gf patterns
if check_command gf && [[ ! -d ~/.gf ]]; then
    log "Configuring gf patterns"
    git clone https://github.com/tomnomnom/gf /tmp/gf
    mkdir -p ~/.gf
    cp -r /tmp/gf/examples ~/.gf
    rm -rf /tmp/gf
    log "gf patterns configured"
fi

# Install findomain
if ! check_command findomain; then
    log "Installing findomain"
    wget -q https://github.com/Findomain/Findomain/releases/latest/download/findomain-linux -O /tmp/findomain-linux
    chmod +x /tmp/findomain-linux
    sudo mv /tmp/findomain-linux /usr/local/bin/findomain || { log "Failed to install findomain"; exit 1; }
    log "findomain installed"
else
    log "findomain already installed, skipping"
fi

# Install sublist3r
if ! check_command sublist3r; then
    log "Installing sublist3r"
    git clone https://github.com/aboul3la/Sublist3r.git /tmp/sublist3r
    cd /tmp/sublist3r
    pip3 install --user -r requirements.txt || { log "Failed to install sublist3r dependencies"; exit 1; }
    sudo ln -sf $(pwd)/sublist3r.py /usr/local/bin/sublist3r || { log "Failed to link sublist3r"; exit 1; }
    cd - && rm -rf /tmp/sublist3r
    log "sublist3r installed"
else
    log "sublist3r already installed, skipping"
fi

# Install massdns
if ! check_command massdns; then
    log "Installing massdns"
    git clone https://github.com/blechschmidt/massdns.git /tmp/massdns
    cd /tmp/massdns
    make || { log "Failed to compile massdns"; exit 1; }
    sudo mv bin/massdns /usr/local/bin/ || { log "Failed to install massdns"; exit 1; }
    sudo mkdir -p /usr/share/massdns/lists
    sudo cp lists/resolvers.txt /usr/share/massdns/lists/ || { log "Failed to copy massdns resolvers"; exit 1; }
    cd - && rm -rf /tmp/massdns
    log "massdns installed"
else
    log "massdns already installed, skipping"
fi

# Install dnsvalidator
if ! check_command dnsvalidator; then
    log "Installing dnsvalidator"
    git clone https://github.com/vortexau/dnsvalidator.git /tmp/dnsvalidator
    cd /tmp/dnsvalidator
    pip3 install --user -r requirements.txt || { log "Failed to install dnsvalidator dependencies"; exit 1; }
    sudo ln -sf $(pwd)/dnsvalidator.py /usr/local/bin/dnsvalidator || { log "Failed to link dnsvalidator"; exit 1; }
    cd - && rm -rf /tmp/dnsvalidator
    log "dnsvalidator installed"
else
    log "dnsvalidator already installed, skipping"
fi

# Install spiderfoot
if ! check_command spiderfoot; then
    log "Installing spiderfoot"
    git clone https://github.com/smicallef/spiderfoot.git /tmp/spiderfoot
    cd /tmp/spiderfoot
    pip3 install --user -r requirements.txt || { log "Failed to install spiderfoot dependencies"; exit 1; }
    sudo ln -sf $(pwd)/sf.py /usr/local/bin/spiderfoot || { log "Failed to link spiderfoot"; exit 1; }
    cd - && rm -rf /tmp/spiderfoot
    log "spiderfoot installed"
else
    log "spiderfoot already installed, skipping"
fi

# Install theHarvester
if ! check_command theHarvester; then
    log "Installing theHarvester"
    git clone https://github.com/laramies/theHarvester.git /tmp/theHarvester
    cd /tmp/theHarvester
    pip3 install --user -r requirements.txt || { log "Failed to install theHarvester dependencies"; exit 1; }
    sudo ln -sf $(pwd)/theHarvester.py /usr/local/bin/theHarvester || { log "Failed to link theHarvester"; exit 1; }
    cd - && rm -rf /tmp/theHarvester
    log "theHarvester installed"
else
    log "theHarvester already installed, skipping"
fi

# Install ctfr.py
if ! check_file ctfr.py; then
    log "Installing ctfr.py"
    git clone https://github.com/UnaPibaGeek/ctfr.git /tmp/ctfr
    sudo mv /tmp/ctfr/ctfr.py /usr/local/bin/ || { log "Failed to install ctfr.py"; exit 1; }
    sudo chmod +x /usr/local/bin/ctfr.py
    rm -rf /tmp/ctfr
    log "ctfr.py installed"
else
    log "ctfr.py already installed, skipping"
fi

# Install dnsdumpster.py (assumed from secynic/dnsdumpster-python)
if ! check_file dnsdumpster.py; then
    log "Installing dnsdumpster.py"
    git clone https://github.com/secynic/dnsdumpster-python.git /tmp/dnsdumpster
    sudo mv /tmp/dnsdumpster/dnsdumpster.py /usr/local/bin/ || { log "Failed to install dnsdumpster.py"; exit 1; }
    sudo chmod +x /usr/local/bin/dnsdumpster.py
    rm -rf /tmp/dnsdumpster
    log "dnsdumpster.py installed"
else
    log "dnsdumpster.py already installed, skipping"
fi

# Install SecLists for altdns
if [[ ! -d /usr/share/wordlists/seclists ]]; then
    log "Installing SecLists"
    case "$DISTRO" in
        debian)
            sudo apt install -y seclists || { log "Failed to install SecLists"; exit 1; }
            ;;
        arch)
            sudo pacman -S --noconfirm seclists || { log "Failed to install SecLists"; exit 1; }
            ;;
        fedora)
            sudo dnf install -y seclists || { log "Failed to install SecLists"; exit 1; }
            ;;
        *)
            git clone https://github.com/danielmiessler/SecLists.git /tmp/seclists
            sudo mv /tmp/seclists /usr/share/wordlists/seclists || { log "Failed to install SecLists"; exit 1; }
            rm -rf /tmp/seclists
            ;;
    esac
    log "SecLists installed"
else
    log "SecLists already installed, skipping"
fi

# Install mdless (optional, for viewing tools.md)
if ! check_command mdless; then
    log "Installing mdless for Markdown viewing"
    sudo gem install mdless || { log "Failed to install mdless"; }
    log "mdless installed"
else
    log "mdless already installed, skipping"
fi

# Verify installations
log "Verifying installed tools"
for tool in subfinder assetfinder amass findomain sublist3r httpx katana waybackurls gf arjun trufflehog subzy dnsrecon altdns massdns dnsvalidator hakrawler gospider nuclei spiderfoot theHarvester; do
    if check_command "$tool"; then
        log "$tool: Installed"
    else
        log "$tool: Not installed"
    fi
done
for script in ctfr.py dnsdumpster.py; do
    if check_file "$script"; then
        log "/usr/local/bin/$script: Installed"
    else
        log "/usr/local/bin/$script: Not installed"
    fi
done

# Final instructions
log "Installation complete. Log file: $LOG_FILE"
echo -e "${GREEN}All tools installed. You can now run the subdomain enumeration script.${NC}"
echo -e "${YELLOW}To view logs: cat $LOG_FILE${NC}"
echo -e "${YELLOW}Ensure /usr/local/bin and ~/.local/bin are in your PATH. Run 'source ~/.bashrc' if you modified PATH.${NC}"

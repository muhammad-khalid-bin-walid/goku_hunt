Installation Guide for Subdomain Enumeration Tools
This guide provides step-by-step instructions to install all tools required for the subdomain_hunter_ultimate.sh script on a Linux system (e.g., Ubuntu/Debian). Ensure you have sudo privileges and an internet connection.
Prerequisites
Before installing the tools, set up the necessary dependencies and environment.
# Update package lists and install common dependencies
sudo apt update && sudo apt upgrade -y
sudo apt install -y git curl wget build-essential python3 python3-pip golang jq unzip

# Install Python dependencies for scripts
pip3 install requests beautifulsoup4

# Create a directory for tools
mkdir -p ~/tools && cd ~/tools

# Add Go bin to PATH
echo 'export PATH=$PATH:/usr/local/go/bin:~/go/bin' >> ~/.bashrc
source ~/.bashrc

Tool Installation
1. Subfinder
A subdomain discovery tool using passive sources.
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
sudo ln -s ~/go/bin/subfinder /usr/local/bin/subfinder
subfinder -version

2. Assetfinder
Finds subdomains using various sources like crt.sh and Facebook CT logs.
go install -v github.com/tomnomnom/assetfinder@latest
sudo ln -s ~/go/bin/assetfinder /usr/local/bin/assetfinder
assetfinder --version

3. Amass
An in-depth attack surface mapping and asset discovery tool.
go install -v github.com/OWASP/Amass/v3/...@master
sudo ln -s ~/go/bin/amass /usr/local/bin/amass
amass -version

4. Findomain
A fast and cross-platform subdomain enumerator.
wget https://github.com/findomain/findomain/releases/latest/download/findomain-linux
chmod +x findomain-linux
sudo mv findomain-linux /usr/local/bin/findomain
findomain --version

5. Sublist3r
A Python-based tool for enumerating subdomains using search engines.
git clone https://github.com/aboul3la/Sublist3r.git
cd Sublist3r
pip3 install -r requirements.txt
sudo ln -s $(pwd)/sublist3r.py /usr/local/bin/sublist3r
cd ..
sublist3r -v

6. httpx
A fast HTTP prober for checking alive subdomains.
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
sudo ln -s ~/go/bin/httpx /usr/local/bin/httpx
httpx -version

7. curl
A command-line tool for transferring data (usually pre-installed).
sudo apt install -y curl
curl --version

8. jq
A lightweight JSON processor.
sudo apt install -y jq
jq --version

9. Katana
A next-generation crawling and spidering tool.
go install -v github.com/projectdiscovery/katana/cmd/katana@latest
sudo ln -s ~/go/bin/katana /usr/local/bin/katana
katana -version

10. Waybackurls
Fetches URLs from the Wayback Machine.
go install -v github.com/tomnomnom/waybackurls@latest
sudo ln -s ~/go/bin/waybackurls /usr/local/bin/waybackurls
waybackurls -version

11. GF
A tool for identifying potential vulnerabilities using pattern matching.
go install -v github.com/tomnomnom/gf@latest
sudo ln -s ~/go/bin/gf /usr/local/bin/gf
# Install GF patterns
git clone https://github.com/1ndianl33t/Gf-Patterns.git
mkdir ~/.gf
cp Gf-Patterns/*.json ~/.gf/
gf -list

12. Arjun
A tool for discovering HTTP parameters.
pip3 install arjun
arjun --version

13. TruffleHog
A tool for finding secrets in repositories and web pages.
pip3 install trufflehog
trufflehog --version

14. Subzy
A tool for detecting subdomain takeover vulnerabilities.
go install -v github.com/LukaSikic/subzy@latest
sudo ln -s ~/go/bin/subzy /usr/local/bin/subzy
subzy --version

15. dnsrecon
A DNS reconnaissance tool.
sudo apt install -y dnsrecon
dnsrecon --version

16. altdns
A tool for generating subdomain permutations.
pip3 install altdns
altdns -h

17. massdns
A high-performance DNS resolver.
git clone https://github.com/blechschmidt/massdns.git
cd massdns
make
sudo mv bin/massdns /usr/local/bin/
cd ..
# Download resolver list
mkdir -p /usr/share/massdns/lists
wget https://raw.githubusercontent.com/blechschmidt/massdns/master/lists/resolvers.txt -O /usr/share/massdns/lists/resolvers.txt
massdns -h

18. dnsvalidator
Validates DNS resolvers.
git clone https://github.com/vortexau/dnsvalidator.git
cd dnsvalidator
pip3 install -r requirements.txt
sudo ln -s $(pwd)/dnsvalidator.py /usr/local/bin/dnsvalidator
cd ..
dnsvalidator -h

19. Hakrawler
A fast web crawler for discovering endpoints.
go install -v github.com/hakluke/hakrawler@latest
sudo ln -s ~/go/bin/hakrawler /usr/local/bin/hakrawler
hakrawler -h

20. Gospider
A fast web spider written in Go.
go install -v github.com/jaeles-project/gospider@latest
sudo ln -s ~/go/bin/gospider /usr/local/bin/gospider
gospider -h

21. Nuclei
A fast vulnerability scanner (optional).
go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest
sudo ln -s ~/go/bin/nuclei /usr/local/bin/nuclei
nuclei -version

22. SpiderFoot
An OSINT automation tool.
pip3 install spiderfoot
spiderfoot --version

23. theHarvester
An OSINT tool for gathering subdomains and emails.
sudo apt install -y theharvester
theHarvester -h

24. ctfr
A Python script for Certificate Transparency log enumeration.
git clone https://github.com/UnaPibaGeek/ctfr.git
cd ctfr
pip3 install -r requirements.txt
sudo ln -s $(pwd)/ctfr.py /usr/local/bin/ctfr.py
cd ..
python3 /usr/local/bin/ctfr.py -h

25. dnsdumpster
A Python script for DNS reconnaissance (custom implementation).
# Assuming a custom dnsdumpster.py script
# Replace with actual repository or script if available
touch /usr/local/bin/dnsdumpster.py
chmod +x /usr/local/bin/dnsdumpster.py
echo '#!/usr/bin/env python3\n# Add dnsdumpster logic here' > /usr/local/bin/dnsdumpster.py
# If you have a specific dnsdumpster.py, copy it:
# sudo cp path/to/dnsdumpster.py /usr/local/bin/dnsdumpster.py

26. SecLists (Wordlists for altdns)
A collection of wordlists for security testing.
sudo apt install -y seclists
# Ensure subdomain wordlist is available
ls /usr/share/wordlists/seclists/Discovery/DNS/subdomains-top1million-5000.txt

Verification
Verify all tools are installed correctly:
for tool in subfinder assetfinder amass findomain sublist3r httpx curl jq katana waybackurls gf arjun trufflehog subzy dnsrecon altdns massdns dnsvalidator hakrawler gospider nuclei spiderfoot theharvester; do
    command -v $tool >/dev/null 2>&1 && echo "$tool installed" || echo "$tool NOT installed"
done
# Check Python scripts
for script in /usr/local/bin/{ctfr.py,dnsdumpster.py}; do
    [[ -f $script ]] && echo "$script exists" || echo "$script NOT found"
done
# Check wordlist
[[ -f /usr/share/wordlists/seclists/Discovery/DNS/subdomains-top1million-5000.txt ]] && echo "SecLists wordlist installed" || echo "SecLists wordlist NOT installed"

Notes

Go Tools: Ensure Go is installed (go version) and the GOPATH is set correctly. Tools are installed to ~/go/bin and symlinked to /usr/local/bin.
Python Tools: Use pip3 to install Python dependencies globally or in a virtual environment.
dnsdumpster.py: The script assumes a custom implementation. Replace the placeholder with the actual script if available.
SecLists: Required for altdns to generate subdomain permutations.
Permissions: Some tools require sudo for installation or execution.
Updates: Regularly update tools (e.g., go get -u, pip3 install --upgrade, git pull) to ensure the latest versions.
Ethical Use: Use these tools only for authorized security testing.

Troubleshooting

Tool not found: Ensure the tool is in /usr/local/bin or update PATH.
Python errors: Verify requests and beautifulsoup4 are installed (pip3 show requests beautifulsoup4).
Go errors: Check Go version (go version) and GOPATH (echo $GOPATH).
Permission issues: Run commands with sudo or fix permissions (chmod, chown).

This setup ensures all tools are ready for the subdomain_hunter_ultimate.sh script.

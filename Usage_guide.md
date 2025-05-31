Usage Guide for goku_hunt.sh
This script automates subdomain enumeration, HTTP probing, crawling, and analysis for a target domain using tools like Subfinder, Amass, httpx, Katana, GF, Arjun, TruffleHog, Subzy, and optional Nuclei.
Purpose

Discover subdomains (passive/active).
Probe alive hosts, crawl endpoints, and extract subdomains.
Identify patterns, parameters, secrets, and takeover risks.
Optionally scan vulnerabilities with Nuclei.

Prerequisites

OS: Linux (e.g., Ubuntu) with sudo.
Tools: Subfinder, Assetfinder, Amass, httpx, Katana, GF, Arjun, TruffleHog, Subzy, dnsrecon, massdns, altdns, dnsvalidator, Hakrawler, Gospider, SpiderFoot, theHarvester, ctfr.py, dnsdumpster.py, SecLists wordlist. Optional: Nuclei (see install_tools.md).
Dependencies: Python 3 (requests, beautifulsoup4), Go, internet access.
Permissions: Write access to  your dir.

Verify:
for tool in subfinder assetfinder amass httpx katana jq curl sublist3r waybackurls gf arjun trufflehog subzy dnsrecon altdns massdns dnsvalidator hakrawler gospider nuclei spiderfoot theharvester; do
  command -v $tool >/dev/null && echo "$tool installed" || echo "$tool NOT installed"; done
ls /usr/local/bin/{ctfr.py,dnsdumpster.py} /usr/share/wordlists/seclists/Discovery/DNS/subdomains-top1million-5000.txt

Installation

Save goku_hunt.sh (e.g., ~/tools/).

Make executable:
chmod +x ~/tools/goku_hunt.sh



Usage

Run:
~/tools/goku_hunt.sh


Input:

Domain: Enter a valid domain (e.g., example.com) when prompted.
Nuclei (if installed): Enter y/n to enable/disable vulnerability scanning.


Process:

Enumerates subdomains (Subfinder, Amass, crt.sh, etc.).
Probes alive hosts (httpx).
Crawls (Katana, Hakrawler, Gospider), fetches history (Waybackurls).
Analyzes patterns (GF), parameters (Arjun), secrets (TruffleHog), takeovers (Subzy).
Optionally scans vulnerabilities (Nuclei).


Output:

Directory: /home/user/your dir/<domain>/dev/2025-05-31_18-33-00/
Files:
raw_subdomains.txt: All subdomains.
alive_subdomains.txt: Alive hosts (status, title, docs).
katana_endpoints.txt: Crawled endpoints.
waybackurls_subdomains.txt: Historical subdomains.
gf_patterns.txt: Vulnerability patterns.
arjun_parameters.txt: HTTP parameters.
trufflehog_secrets.txt: Secrets.
subzy_takeovers.txt: Takeover risks.
nuclei_vulns.txt: Vulnerabilities (if enabled).
scan.log: Logs.





Example
$ ./goku_hunt.sh
[ASCII Banner]
Enter target domain: example.com
Run Nuclei? (y/n): n
Enumerating...
Found 100 subdomains
Saved 30 alive to alive_subdomains.txt
Crawling completed
Results in /home/user/your dir/example.com/dev/2025-05-31_18-33-00

Troubleshooting

Tool Missing: Install via install_tools.md.
Invalid Domain: Use a valid domain (e.g., example.com).
No Subdomains: Check internet, domain, or logs (scan.log).
Permissions: Ensure write access: sudo chmod -R u+w  your dir.
Hangs: Check logs, reduce MAX_JOBS in script (e.g., MAX_JOBS=4).
Python Errors: Install: `pip3 install requests


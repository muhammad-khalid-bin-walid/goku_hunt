#!/bin/bash

# ANSI color codes for glowing effect
RED='\033[1;31m'
GREEN='\033[1;32m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Automatically set BASE_DIR to the script's directory
BASE_DIR="$(dirname "$(realpath "$0")")"

# Set timestamp
TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')

# Number of parallel jobs (2x CPU cores)
MAX_JOBS=$(($(nproc) * 2))

# Display glowing ASCII art banner
echo -e "${CYAN}"
cat << 'EOF'
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⣇⢿⣿⣿⣿⡙⣿⡔⢢⠙⢸⣧⢣⠹⣿⣿⣿⣿⣧⢻⡷⡌⢻⢷⡈⢦⠑⠆⠰⢀⠲⣡⠒⠴⣈⠦⡑⣌⠒⢸⡇⠃⣰⠻⠿⠿⠿⠿⠿⢿⢿⣿⣿⣿⣿⣿⣿⣿⡷⣌⠒⡌⠁⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠎⢁⡤⢞⣭⣶⣿⣿⣿⣿⣿⣿⠿⣿⣿⣿⣿⣿⣿⠓⡆⢃⣾⣿⡟⣽⠣⠜⡰⠌⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣞⣿⣿⣿⣷⡩⣿⣆⠫⢄⡘⠎⣇⢻⣿⣿⣿⣿⡎⣿⡇⢣⠚⡜⠤⢋⠆⠀⢃⠰⡁⢎⠐⢆⠲⣡⢊⡕⠘⣠⣴⣦⣶⣿⣿⣿⣿⣿⣿⣿⣶⣿⣿⣿⣿⣿⣿⣿⣌⠳⡌⡱⡀⠀⡀⠀⠀⠀⠀⠀⠠⢀⠔⣡⣼⣿⣿⣿⣿⢿⢋⠓⣬⣴⣿⣿⣿⣿⣿⣿⢏⡜⣡⣿⣿⢯⣼⡟⠬⡑⣂⠃⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣿⣿⣿⣿⣿⣷⣜⣿⡃⢎⠴⣀⠘⡤⢻⣿⣿⣿⣿⡸⣷⡈⠵⡘⢌⠣⢎⠀⠈⡄⠘⢬⠀⢊⠱⡐⢆⠂⣼⣿⣿⣿⣿⡿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣌⠱⡐⢆⠘⡐⠢⢄⡀⠄⠀⠀⢾⣿⣿⡿⣟⢫⡑⣢⣾⣿⣿⣿⣿⣿⣿⣿⣿⠟⢠⣼⣿⣿⢫⣾⡟⣑⢊⡱⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⣿⣿⣿⣿⣿⣿⣿⣄⢯⡘⠴⡡⠦⡘⢉⣿⣿⣿⣿⣧⢚⣿⡀⠝⣌⠲⡁⠆⠀⠰⠈⠆⡃⠀⢣⠉⢎⠜⣿⣿⣿⣿⡿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⢊⡕⣂⠠⠙⣄⢣⢃⠀⠐⠀⠋⠔⢊⣴⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣾⣿⣿⡿⣣⣿⠟⡰⢡⠎⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⣿⣿⣿⣿⣿⣿⣯⢹⣆⠘⢢⡑⠦⣑⠂⠘⣿⣿⣿⣿⣧⡹⣿⡌⢄⠣⡕⢊⠄⠀⠡⠈⡕⡀⠀⠭⣌⢢⢹⣿⣿⠄⠀⠀⠀⠈⠙⠛⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⠒⡌⢆⠘⡌⡚⠄⠁⡀⠂⠁⠀⢹⣿⣿⣿⣿⣿⣿⣿⡿⢟⡉⢢⣼⡟⣍⠲⡠⢍⠊⠀⠀⢀⠤⡐⢆⡱⢄⣳⣚⣭⣶⣿
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣇⠹⣆⠡⢌⠣⢔⡩⢂⡘⣿⣿⣿⣿⣧⠹⣿⣄⠣⢌⡃⢎⡀⠀⠡⠐⣃⠀⠐⠤⢃⡌⣿⣿⡂⠀⠀⠀⠀⠀⠀⠀⠀⠉⠻⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⠒⡌⢆⠘⡌⡚⠄⠀⠂⠁⡈⠀⣿⣿⣿⣿⣿⠟⡩⠜⣂⣼⡟⣍⠲⡠⢃⠖⠁⠀⠀⠀⡄⢃⠊⡡⣔⣲⣿⣿⣿⣿⣿⡿⢍
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⣿⣿⣿⣿⣿⣿⣿⣦⠀⢣⡈⠜⠤⢃⡍⡔⡈⢿⣿⣿⣿⠷⣙⣫⣤⣤⣴⣤⣤⣤⣤⣤⡀⠂⠀⠈⢒⠤⠹⣿⠀⠀⠀⠀⠀⠠⡄⠦⣑⠢⡡⢄⡙⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣗⠸⣌⢂⠘⡌⡚⠄⠀⠂⢀⠐⠘⡟⢛⡍⠲⠌⡑⣴⢋⠇⡜⡠⢃⠖⠁⠀⠀⠀⡄⢃⠊⡡⣔⣲⣿⣿⣿⣿⣿⡿⢏⠔⡣
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⣿⣿⣿⣿⣿⣿⣿⣿⣧⠀⠒⡌⠡⣃⠲⡰⠱⢌⠹⢋⣴⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⢄⠀⠈⢌⢃⢻⠄⠀⠀⠠⣌⠱⣈⠖⣡⢒⡉⡖⡌⣢⠙⢿⣿⣿⣿⣿⣯⢻⣿⣿⡂⢍⡘⡀⢣⠑⡂⢈⠀⠂⢀⠐⠘⡆⢌⠡⡒⢅⠆⡣⢚⠤⡱⠁⠀⠀⠀⢄⠆⣣⣿⣿⣿⣿⣿⣿⣿⡿⢏⡱⢊⡜⡔
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣧⢿⣿⣿⣿⣿⣿⣷⡀⠩⡄⠰⣁⠇⡹⠀⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡎⢄⡀⠊⠌⠀⡀⢆⠓⡤⢓⠤⣋⠔⡣⢜⡰⡘⢤⢋⡄⠻⣿⣿⣿⣿⡆⢿⣿⣿⡂⢍⡘⡀⢣⠑⡂⢈⠀⠂⢀⠐⠘⡆⢌⠡⡒⢅⠆⡣⢚⠤⡱⠁⠀⠀⠀⡄⢃⠊⡡⣔⣲⣿⣿⣿⣿⣿⡿⢏
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⡞⣿⣿⣿⣿⣿⣿⣿⣆⠈⢕⡨⢒⢁⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣮⡘⡅⢖⡠⢓⡌⣚⠰⣉⠖⡌⢎⡱⢊⠴⣉⠖⢈⡰⢃⡘⢿⣿⣿⡟⡈⢿⣿⣧⠈⠖⣁⠢⣉⠔⠀⡀⠂⠠⠀⠂⠈⡆⢌⠡⡒⢅⠆⡣⢚⠤⡱⠁⠀⠀⠀⡄⢃⠊⡡⣔⣲⣿⣿⣿⣿⣿⡿⢏⠔⡣
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣿⣿⣿⡸⣿⣿⣿⣿⣿⣿⣿⣧⡀⢃⠇⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡗⣘⢢⠱⣡⠚⡤⢓⡌⢎⡜⢢⠱⡉⠒⡡⢆⠣⣌⢣⠒⡌⢻⣿⡏⢴⠘⣿⣷⡌⠓⠬⠐⡰⢈⠀⠄⢀⠁⢀⠂⠀⠜⢢⡑⠥⣊⠜⡡⢃⠜⠀⠀⠀⢠⢂⡐⢦⣽⣶⣿⣿⣿⣿⣿⡿⢏⠔⡣
⠀⠀⠀⠀⠀⠀⠀⠀⠳⣦⣄⡀⠀⠀⠀⠀⠘⣿⣿⣧⠘⡞⢿⣿⣿⣿⣿⣿⣿⡤⡀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⣄⢣⠓⡤⢋⡔⢣⠘⢢⠈⠄⠃⣠⡿⢡⡙⡔⢢⢅⠫⢔⡂⢻⣿⣌⠆⣹⣿⡆⣙⠸⡀⢡⠀⠀⠀⠂⠈⠀⢀⠂⠨⡅⠜⣢⠡⢚⠤⠁⠀⠀⠀⢄⠆⣣⣿⣿⣿⣿⣿⣿⣿⡿⢏⡱⢊⡜⡔
⠀⠀⠀⠀⠀⠀⠙⣿⣿⡷⣌⡒⢤⡀⠀⠀⠈⢿⣿⣧⠘⣦⠙⣿⣿⣿⣿⣿⣿⠇⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣽⡊⢟⡻⣿⡅⢎⡱⢌⠣⡜⡡⠊⠄⠈⣰⣾⣿⠏⡴⢡⢣⡙⠔⢊⠠⠎⢬⡑⡄⠊⣿⡝⡄⢹⡇⢠⠋⡄⠂⠒⢡⠀⠀⠀⡁⠀⠐⡌⢣⠔⢣⡉⠀⠀⠀⢠⠚⢤⣫⣾⣿⣿⣿⣿⠿⣏⠱⠌⢦⠑⡣⠌⠀
⠀⠀⠀⠀⠀⠀⠀⠈⢿⣷⣮⡹⢶⣌⠳⢤⣀⠈⢻⣿⣧⡘⣧⡈⠟⣿⣿⣿⣿⢱⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⢘⡰⠃⢸⠀⡱⠂⠄⣃⠺⠥⠚⣀⢁⠦⢁⣢⡵⠚⢉⠉⠛⠿⣿⣿⡇⢿⡆⢸⠀⢆⠣⡍⠐⣌⠐⡀⠁⠀⡀⠁⠀⠀⠱⢂⢡⣴⡶⡄⠉⢦⠘⢧⠘⡥⣉⠦⣉⠖⣈⠣⠜⢁⠌⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠈⢻⣿⣿⣷⣌⡻⣦⡑⢯⣄⠹⣿⣷⡈⢷⡌⢌⠻⣿⣿⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⢘⡰⠃⢸⠀⡱⠂⠄⣃⠺⠥⠚⣀⢁⠦⢁⣢⡵⠚⢉⠉⠛⠿⣿⣿⡇⢿⡆⢸⠀⢆⠣⡍⠐⣌⠐⡀⠁⠀⡀⠁⠀⠀⠱⢂⢡⣴⡶⡄⠉⢦⠘⢧⠘⡥⣉⠦⣉⠖⣈⠣⠜⢁⠌⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣿⣿⣿⣿⣮⡛⢷⣌⠳⣘⢿⣿⣌⠹⣦⠑⠢⡝⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⢘⡰⠃⢸⠀⡱⠂⠄⣃⠺⠥⠚⣀⢁⠦⢁⣢⡵⠚⢉⠉⠛⠿⣿⣿⡇⢿⡆⢸⠀⢆⠣⡍⠐⣌⠐⡀⠁⠀⡀⠁⠀⠀⠱⢂⢡⣴⡶⡄⠉⢦⠘⢧⠘⡥⣉⠦⣉⠖⣈⠣⠜⢁⠌⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⣿⣿⣿⣿⣿⣦⡙⢷⣬⠊⠻⣿⣦⠙⢿⣄⠱⢸⣿⣷⣿⡿⠿⢛⡛⠛⠛⠛⡛⠟⠿⠻⠿⢿⢿⣿⣿⣟⡳⢌⠲⠀⣡⠐⢣⠆⠀⠁⠄⠒⠐⢈⣴⣾⣿⠿⠀⡐⣈⡈⠴⡠⠴⠄⠆⣹⡇⠐⢂⠜⡰⠀⠡⠀⡁⠀⠄⠁⡀⠈⠄⠀⠘⣠⣿⠳⣡⠚⡀⠦⡙⠢⣍⠰⢂⠖⡰⠊⠀⢁⠔⠁⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣿⣿⣿⣿⣿⣿⣮⡙⣿⣦⡙⢿⣿⣦⡙⢿⠸⡇⠀⠰⠁⣈⠔⣢⠹⣿⣿⣿⣿⣿⣿⠏⡐⣈⡁⡄⡀⠆⠠⣉⠖⣉⠦⢱⡧⡘⡔⠣⡍⠦⡙⡜⣿⣿⣿⣿⣿⢏⢳⡘⢤⢋⠆⡇⢼⡀⡱⠁⡐⠦⡑⢎⠱⠈⠄⠁⠠⠀⠂⢈⠀⢩⡐⢠⠘⡰⢀⡑⠆⠀⠀⠀⠀⠀⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣿⣿⣿⣿⣿⣿⣿⣷⣌⠻⣿⣦⡙⢿⣿⣦⡘⣇⣠⣤⣾⣷⣾⣤⣣⡘⠿⣛⣭⣱⣾⡷⠿⠛⡙⣠⢁⠤⡐⢬⡘⡤⢡⡾⠗⢡⠂⠑⠬⡑⡜⡰⠭⡿⣟⡿⢃⠎⢦⢙⠢⣍⠲⠁⡆⡘⠁⠴⡉⢦⠑⡈⠀⠄⠂⢈⠀⠂⢁⠠⠀⢂⠀⠣⠄⡁⠀⠜⡂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣟⢿⣿⣿⣿⣿⣿⣿⣦⢛⣿⣿⣦⡘⣇⣠⣤⣾⣷⣾⣤⣣⡘⠿⣛⣭⣱⣾⡷⠿⠛⡙⣠⢁⠤⡐⢬⡘⡤⢡⡾⠗⢡⠂⠑⠬⡑⡜⡰⠭⡿⣟⡿⢃⠎⢦⢙⠢⣍⠲⠁⡆⡘⠁⠴⡉⢦⠑⡈⠀⠄⠂⢈⠀⠂⢁⠠⠀⢂⠀⠣⠄⡁⠀⠜⡂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣶⣙⢿⣿⣿⣿⣿⣿⣷⡘⢿⣿⣧⢹⣿⣿⣿⣿⣿⣿⠿⢿⠛⠍⠉⣁⣴⣵⣢⣝⣦⡑⢎⠲⣉⠦⣸⡀⠀⠀⠄⡀⠀⠈⠐⡱⢌⡱⢊⠴⡡⢣⢍⡚⢤⠋⡴⣈⠖⠡⠑⢀⡌⡓⢜⠢⢃⠠⠈⠀⠄⠂⢀⠐⠀⠄⠐⡀⠀⠀⠑⠀⠄⡘⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⣿⣧⣝⠿⣿⣿⣿⣿⣿⣎⣉⠛⡃⠺⣿⣿⣿⡿⣝⠸⢂⣴⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣦⣱⣸⣿⣇⠀⠌⢀⠀⡐⠠⠀⠐⡡⢎⠱⣊⠥⢃⠦⣉⠦⡙⢤⢡⢚⠀⣀⠲⡌⡜⠬⡑⢂⠀⠄⠁⡀⠂⠀⠄⠈⠠⠀⠸⣧⠐⠀⣀⠢⢑⠂⠀⠀⠀⢠⢀⡀⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⡹⢷⣎⡳⣌⠻⣿⣿⣿⠇⣿⣧⠜⣂⠙⣿⣯⠓⣠⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡀⠄⠂⠐⠀⠄⡠⢣⠱⢌⢃⠦⡙⣌⠲⠡⢎⡑⠎⣆⢃⡐⠦⣑⠸⣐⢣⢉⠆⠀⠂⠐⠀⠠⠁⠀⠌⠀⠐⠀⠉⠀⢀⣦⣙⠢⠁⢀⠠⠌⣄⠡⣈⠤⡘⣄⠲⢄⢣⡘⠤⠉⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠃⠞⢳⣞⡳⢤⡘⢹⠃⣿⠠⢌⠳⣧⠘⣷⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠿⢟⣋⣳⣬⣥⡒⢰⠒⡤⠌⢆⠣⢍⠲⢡⠓⡤⣙⠢⡜⢢⠜⠤⣋⠴⣁⠈⠀⠄⠁⡀⠠⢈⠀⠐⢠⡽⢡⡙⢤⠱⠁⠀⠉⠘⠀⠉⠂⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠡⢌⡙⠦⡑⠂⡀⢻⢐⡬⠆⠹⣇⠸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢿⡿⢟⢫⠓⠔⢊⠤⠓⡌⠥⢒⡡⠣⢜⢨⡑⠎⡴⢉⠖⣌⠱⣊⠔⠁⢀⠐⠈⠀⠄⠌⡱⢂⠍⣂⠖⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⢆⡱⢃⡄⡈⡇⣿⠌⢦⠙⣦⢹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠏⠂⢈⠀⢠⢀⡀⠀⠈⠱⠘⡬⡑⡰⣉⢆⠣⣌⠓⣌⠣⠎⢤⠓⡌⢎⠀⠄⠁⠂⠁⢀⠀⠀⠀⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠃⠜⡠⢹⣾⡆⣇⠂⢸⣆⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢏⡀⢄⢆⡙⣆⡡⡜⣩⠃⡕⢢⠔⣡⠑⢆⡊⠵⣠⢋⠴⣉⠞⣄⠫⡘⢆⠀⠂⠐⠈⠀⢀⠠⠈⠀⠐⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡑⠂⢿⣿⡇⢮⣽⣿⡌⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡏⡄⠀⠈⠛⠆⠘⣿⣿⡿⣝⠸⢂⣤⣶⣾⣿⣿⣿⣿⣿⡟⣏⠙⣆⠚⡤⡙⠆⣀⢚⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣽⣿⣷⣿⣶⣶⣧⡒⠬⠤⠤⡌⣂⠑⠂⡙⠀⢀⠐⠀⡈⢀⠂⢀⠐⠀⡐⠀⡀⠂⢈⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⠶⣛⣛⣭⣧⣤⡛⣿⣆⠻⣧⢐⡘⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢏⡀⢄⢆⡙⣆⡡⡜⣩⠃⡕⢢⠔⣡⠑⢆⡊⠵⣠⢋⠴⣉⠞⣄⠫⡘⢆⠀⠂⠐⠈⠀⢀⠠⠈⠀⠐⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⡾⠿⠟⠛⠋⠑⢊⠐⠎⠲⢄⢫⡙⠤⠙⢬⣕⣂⠹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣤⣬⡠⣴⣢⡕⠢⢍⠢⠉⠒⣅⢢⠣⡙⠴⣈⠳⣠⠣⢜⡱⢌⡓⣌⠲⢌⡂⠁⠠⠁⠈⡀⠄⠁⠐⠀⠀⠐⡈⠀⡼⡷⢉⠂⡐⠎⡴⢉⠤⢓⡰⢌⠱⠀⠃⠈⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠈⠁⠘⠐⠒⠤⢂⢄⡉⡘⠠⢈⠛⠆⠘⣿⣿⡿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⢣⠘⡔⡡⢆⡙⢢⠜⡬⣑⠢⢍⡒⢬⠘⡌⠀⠂⢀⠀⡜⠤⠚⡌⢆⡈⠄⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⠁⠓⠢⠌⢀⠃⢀⡛⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡖⣌⠳⢌⠲⣑⠪⠜⡤⢋⠖⡨⠁⢀⠂⠈⠀⢀⠸⡀⠇⡭⡘⡌⢆⣃⠚⣄⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠠⠀⡀⠄⠠⠀⢸⣿⣦⣍⠺⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣄⢋⢆⠳⡨⢅⡋⢔⡡⠊⢀⠐⠀⠀⡀⠈⢠⠃⡝⡸⢄⡱⡘⠦⢌⠣⡌⢆⠀⠀⠀⠀⠀⠀⠀⠈⠄⠂⠁⠀⠄⠁⣀⣨⣤⣶⣦⣁⠂⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⢀⠄⡛⢛⡛⣿⣿⣿⠿⠛⠉⠁⠠⢀⠐⠠⠁⠠⠈⠄⣸⣿⣿⣿⣿⣿⣿⣷⡄⠙⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣮⡘⠌⡥⢃⠦⡉⠆⢀⠐⠈⠀⣴⣿⣏⠳⣌⢣⠚⡤⢣⠜⡡⠎⡜⡰⡉⢦⢑⡡⠃⠀⠀⠀⠀⠀⠀⠀⠐⠀⡈⠀⠄⠘⢿⣿⣿⣿⡿⠟⠛⠉
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠐⠠⢈⣤⣿⣿⣿⣿⣿⣿⡿⠛⠉⠠⠐⠀⠄⠂⡀⠂⠄⠀⠀⠂⠀⠂⠁⠀⣽⣿⣿⣿⣿⣿⣿⣿⣿⡧⢩⠄⡊⢥⢒⡩⠆⡄⠁⡀⠂⠀⠉⠐⠉⠈⠀⠉⠀⠀⠀⡀⠐⠈⡀⢄⠀⠂⡐⢠⣿⣿⡻⣈⠖⠀⢎⡱⢂⠧⡑⢎⠲⣉⠖⣡⠓⣌⠒⣍⠲⠀⠀⢀⠀⠀⠀⠀⠀⠀⠀⠀⠐⠀⢀⠠⠀⠄⠂⠠⠀
⠀⢡⣰⣯⣟⠀⢈⠀⠐⠠⠀⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠊⢆⡜⠢⡜⢀⣤⣣⣎⣾⣿⣿⣿⣿⣿⠓⡬⠃⣿⣿⣿⣿⡚⠀⡍⢢⠽⣯⡿⠟⣋⣴⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⣑⠣⢥⡘⢄⡋⠂⠀⠄⠂⢁⠐⠈⡀⠂⠠⠀⠂⢀⠂⢀⠁⠠⠐⠀
⢴⣿⣿⣿⠇⠈⡀⠐⠈⡀⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⠈⢣⣈⣡⣥⣦⣬⣾⣶⣷⣾⣷⣿⣾⣿⣿⣿⣶⣾⣦⣴⣈⠸⢿⣟⣯⢏⠱⠀⢁⣰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⢍⠢⡜⢢⠘⠂⠁⡀⠠⠁⠈⠄⠐⠀⠀⠄⠁⠀⠀⠀⠁⠀⠀⠀⠀⠀⠀⠀⠀
⠻⢟⣩⡶⠃⢀⠐⠀⡁⠠⠀⠁⠀⠀⠀⠀⠀⠀⢀⠠⠔⢶⠻⢟⠿⣿⠿⠿⠿⣛⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⢿⠿⢛⡂⢌⡁⠊⢠⣚⣼⣯⣿⣿⣻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⢍⠢⡜⢢⠘⠂⠁⡀⠠⠁⠈⠄⠐⠀⠀⠄⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠘⠋⢀⠀⠂⢀⠁⡀⠄⠁⠈⠀⠀⠀⠀⠀⢀⠎⡑⠎⠂⢉⢈⣀⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⣏⠙⣆⠚⡤⡙⠆⣀⢚⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⡝⢪⠜⢢⡐⠂⠀⢀⠠⠀⠂⠠⠈⠀⠄⠠⠐⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠌⠀⠄⠂⢁⠀⠂⠠⠐⠈⠀⠀⠀⠀⠀⠐⠈⠀⣄⣴⣾⣿⣻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⡍⢎⡜⡌⢣⢂⠧⠱⡘⠦⠁⣳⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢿⡻⡝⢩⠒⡌⡅⢋⠔⡡⢆⡑⠂⠀⠈⠄⠈⡀⠐⢀⠠⠀⠠⠁⡀⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠠⠈⠀⡀⢀⠠⠁⠐⡀⠀⠀⠀⠀⠀⡠⢔⣪⣽⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⡍⢎⡜⡌⢦⡘⠆⡍⢆⡩⢒⡉⢆⡈⠀⡇⢼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⣿⣿⣿⣿⣿⢿⣿⠟⡞⡉⠖⡡⢃⡜⠰⡈⠜⠤⢃⠆⡘⠀⠠⠁⠂⠁⡀⠐⢀⠠⠀⠠⠁⡀⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠁⠀⡀⠀⠄⠁⠀⠀⠀⠀⢠⣜⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⣏⢣⡙⡔⢣⠒⡌⢆⡁⠎⡱⠨⠅⢢⣟⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⣟⣿⡽⢋⠓⡜⡠⢣⠡⣘⠀⠐⠀⠂⠐⠀⠂⠀⠄⠁⡈⠀⠄⠂⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠐⢀⠈⠄⠂⠈⠀⠀⠀⠀⣠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⡍⢎⡜⡌⢦⡘⠆⡍⢆⡩⢒⡉⢆⡈⠀⡇⢼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⣟⣿⡽⢋⠓⡜⡠⢣⠡⣘⠀⠐⠀⠂⠐⠀⠂⠀⠄⠁⡈⠀⠄⠂⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
EOF
echo -e "${NC}"

# Log function for minimal debugging
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$LOG_FILE"
}

# Check for required tools
REQUIRED_TOOLS=(subfinder assetfinder amass findomain sublist3r httpx curl jq katana waybackurls gf arjun trufflehog subzy dnsrecon altdns massdns dnsvalidator hakrawler gospider)
for tool in "${REQUIRED_TOOLS[@]}"; do
    if ! command -v "$tool" >/dev/null 2>&1; then
        echo -e "${YELLOW}Warning: $tool is not installed, skipping${NC}"
        log "$tool not found, skipping"
    fi
done

# Check for optional tools
OPTIONAL_TOOLS=(nuclei spiderfoot theHarvester)
for tool in "${OPTIONAL_TOOLS[@]}"; do
    if ! command -v "$tool" >/dev/null 2>&1; then
        echo -e "${YELLOW}Warning: Optional tool $tool is not installed${NC}"
        log "Optional tool $tool not found"
    fi
done

# Check for Python scripts and dependencies
for script in /usr/local/bin/{ctfr.py,dnsdumpster.py}; do
    if [[ ! -f "$script" ]]; then
        echo -e "${RED}Error: $script not found${NC}"
        log "$script not found"
        exit 1
    fi
done
if ! python3 -c "import requests, bs4" >/dev/null 2>&1; then
    echo -e "${RED}Error: Python modules requests or bs4 not installed${NC}"
    log "Python modules requests or bs4 missing"
    exit 1
fi

# Prompt for target domain
echo -e "${YELLOW}Enter target domain (e.g., example.com): ${NC}"
read -r TARGET_DOMAIN
if [[ -z "$TARGET_DOMAIN" || ! "$TARGET_DOMAIN" =~ ^[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
    echo -e "${RED}Error: Invalid or empty domain${NC}"
    log "Invalid or empty domain entered"
    exit 1
fi

# Create domain-specific output directory in script's directory
OUTPUT_DIR="$BASE_DIR/$TARGET_DOMAIN/$TIMESTAMP"
SUBDOMAIN_FILE="$OUTPUT_DIR/raw_subdomains.txt"
ALIVE_FILE="$OUTPUT_DIR/alive_subdomains.txt"
KATANA_FILE="$OUTPUT_DIR/katana_endpoints.txt"
WAYBACK_FILE="$OUTPUT_DIR/wayback_subdomains.txt"
GF_FILE="$OUTPUT_DIR/gf_patterns.txt"
ARJUN_FILE="$OUTPUT_DIR/arjun_parameters.txt"
TRUFFLEHOG_FILE="$OUTPUT_DIR/trufflehog_secrets.txt"
SUBZY_FILE="$OUTPUT_DIR/subzy_takeovers.txt"
NUCLEI_FILE="$OUTPUT_DIR/nuclei_vulns.txt"
LOG_FILE="$OUTPUT_DIR/scan.log"

mkdir -p "$OUTPUT_DIR" || { echo -e "${RED}Failed to create output directory: $OUTPUT_DIR${NC}"; log "Failed to create output directory"; exit 1; }
: > "$LOG_FILE" || { echo -e "${RED}Failed to create log file: $LOG_FILE${NC}"; log "Failed to create log file"; exit 1; }

# Prompt for Nuclei scan
if command -v nuclei >/dev/null 2>&1; then
    echo -e "${YELLOW}Run Nuclei vulnerability scan? (y/n): ${NC}"
    read -r RUN_NUCLEI
    if [[ "$RUN_NUCLEI" =~ ^[Yy]$ ]]; then
        NUCLEI_ENABLED=1
        log "Nuclei scan enabled"
    else
        NUCLEI_ENABLED=0
        log "Nuclei scan disabled"
    fi
else
    NUCLEI_ENABLED=0
    echo -e "${YELLOW}Nuclei not installed, skipping vulnerability scan${NC}"
    log "Nuclei not installed, skipping"
fi

echo -e "${GREEN}Enumerating subdomains for $TARGET_DOMAIN...${NC}"
log "Starting subdomain enumeration for $TARGET_DOMAIN"

# Enumerate subdomains using multiple tools, saving all to SUBDOMAIN_FILE
: > "$SUBDOMAIN_FILE"
declare -a pids=()
if command -v subfinder >/dev/null 2>&1; then
    subfinder -d "$TARGET_DOMAIN" -all -silent -t 50 -max-time 10 -o - 2>>"$LOG_FILE" | tee -a "$SUBDOMAIN_FILE" &
    pids+=($!)
fi
if command -v assetfinder >/dev/null 2>&1; then
    assetfinder --subs-only "$TARGET_DOMAIN" 2>>"$LOG_FILE" | tee -a "$SUBDOMAIN_FILE" &
    pids+=($!)
fi
if command -v amass >/dev/null 2>&1; then
    amass enum -passive -d "$TARGET_DOMAIN" -timeout 10 -o - 2>>"$LOG_FILE" | tee -a "$SUBDOMAIN_FILE" &
    pids+=($!)
fi
if command -v findomain >/dev/null 2>&1; then
    findomain -t "$TARGET_DOMAIN" --quiet --threads 50 2>>"$LOG_FILE" | tee -a "$SUBDOMAIN_FILE" &
    pids+=($!)
fi
if command -v sublist3r >/dev/null 2>&1; then
    sublist3r -d "$TARGET_DOMAIN" -n -t 20 -o - 2>>"$LOG_FILE" | tee -a "$SUBDOMAIN_FILE" &
    pids+=($!)
fi
if [[ -f /usr/local/bin/ctfr.py ]]; then
    python3 /usr/local/bin/ctfr.py -d "$TARGET_DOMAIN" 2>>"$LOG_FILE" | grep -oE "[a-zA-Z0-9.-]+\.$TARGET_DOMAIN" | tee -a "$SUBDOMAIN_FILE" &
    pids+=($!)
fi
if [[ -f /usr/local/bin/dnsdumpster.py ]]; then
    python3 /usr/local/bin/dnsdumpster.py -d "$TARGET_DOMAIN" 2>>"$LOG_FILE" | grep -oE "[a-zA-Z0-9.-]+\.$TARGET_DOMAIN" | tee -a "$SUBDOMAIN_FILE" &
    pids+=($!)
fi
if command -v curl >/dev/null 2>&1 && command -v jq >/dev/null 2>&1; then
    curl -s "https://crt.sh/?q=%25.$TARGET_DOMAIN&output=json" | jq -r '.[].name_value' | grep -oE "[a-zA-Z0-9.-]+\.$TARGET_DOMAIN" 2>>"$LOG_FILE" | tee -a "$SUBDOMAIN_FILE" &
    pids+=($!)
fi
if command -v theHarvester >/dev/null 2>&1; then
    theHarvester -d "$TARGET_DOMAIN" -b all -f - | grep -oE "[a-zA-Z0-9.-]+\.$TARGET_DOMAIN" 2>>"$LOG_FILE" | tee -a "$SUBDOMAIN_FILE" &
    pids+=($!)
fi
if command -v dnsrecon >/dev/null 2>&1; then
    dnsrecon -d "$TARGET_DOMAIN" -t std 2>>"$LOG_FILE" | grep -oE "[a-zA-Z0-9.-]+\.$TARGET_DOMAIN" | tee -a "$SUBDOMAIN_FILE" &
    pids+=($!)
fi
if command -v altdns >/dev/null 2>&1; then
    altdns -i "$SUBDOMAIN_FILE" -o - -w /usr/share/wordlists/seclists/Discovery/DNS/subdomains-top1million-5000.txt 2>>"$LOG_FILE" | tee -a "$SUBDOMAIN_FILE" &
    pids+=($!)
fi
if command -v massdns >/dev/null 2>&1; then
    massdns -r /usr/share/massdns/lists/resolvers.txt -t A "$SUBDOMAIN_FILE" -o S 2>>"$LOG_FILE" | grep -oE "[a-zA-Z0-9.-]+\.$TARGET_DOMAIN" | tee -a "$SUBDOMAIN_FILE" &
    pids+=($!)
fi
if command -v dnsvalidator >/dev/null 2>&1; then
    dnsvalidator -tL -threads "$MAX_JOBS" -o - "$SUBDOMAIN_FILE" 2>>"$LOG_FILE" | tee -a "$SUBDOMAIN_FILE" &
    pids+=($!)
fi
# Wait for all enumeration processes to complete
for pid in "${pids[@]}"; do
    wait "$pid" 2>>"$LOG_FILE" || log "Process $pid failed"
done
log "Subdomain enumeration completed"

# Deduplicate subdomains, preserving all
if [[ -s "$SUBDOMAIN_FILE" ]]; then
    sort -u "$SUBDOMAIN_FILE" -o "$SUBDOMAIN_FILE"
    echo -e "${GREEN}Found $(wc -l < "$SUBDOMAIN_FILE") unique subdomains, saved to $SUBDOMAIN_FILE${NC}"
    log "Found $(wc -l < "$SUBDOMAIN_FILE") unique subdomains, saved to $SUBDOMAIN_FILE"
else
    echo -e "${RED}No subdomains found for $TARGET_DOMAIN${NC}"
    log "No subdomains found for $TARGET_DOMAIN"
    rm -f "$SUBDOMAIN_FILE"
    exit 0
fi

# Probe alive subdomains with httpx, keeping raw_subdomains.txt intact
echo -e "${GREEN}Probing alive subdomains...${NC}"
log "Starting httpx probing"
temp_alive=$(mktemp)
httpx -silent -sc -cl -title -timeout 2 -retries 1 -status-code -no-fallback -threads "$MAX_JOBS" -l "$SUBDOMAIN_FILE" -o "$temp_alive" 2>>"$LOG_FILE"
log "httpx probing completed"

# Process alive domains
temp_output=$(mktemp)
while IFS=',' read -r url status content_length title; do
    if [[ "$status" =~ ^(200|301|302)$ ]]; then
        echo -e "$url\tStatus: $status\tContent-Length: $content_length\tTitle: $title" | tee -a "$temp_output" >/dev/null
    fi
done < <(awk -F'[][]' '{print $2","$4","$6","$8}' "$temp_alive")
rm -f "$temp_alive"

# Save alive results
if [[ -s "$temp_output" ]]; then
    sort -u "$temp_output" > "$ALIVE_FILE"
    echo -e "${GREEN}Saved $(wc -l < "$ALIVE_FILE") alive subdomains to $ALIVE_FILE${NC}"
    log "Saved $(wc -l < "$ALIVE_FILE") alive subdomains to $ALIVE_FILE"
else
    echo -e "${YELLOW}No alive subdomains found for $TARGET_DOMAIN${NC}"
    log "No alive subdomains found for $TARGET_DOMAIN"
fi

# Crawl alive subdomains with Katana
if command -v katana >/dev/null 2>&1; then
    echo -e "${GREEN}Crawling alive subdomains with katana...${NC}"
    log "Starting katana crawling"
    : > "$KATANA_FILE"
    pids=()
    while IFS=$'\t' read -r url _; do
        katana -u "$url" -silent -d 3 -jc -fx -ef css,js,png,jpg,jpeg,svg,gif,ico -c "$MAX_JOBS" -o - 2>>"$LOG_FILE" | tee -a "$KATANA_FILE" &
        pids+=($!)
    done < "$temp_output"
    for pid in "${pids[@]}"; do
        wait "$pid" 2>>"$LOG_FILE" || log "Katana process $pid failed"
    done
    log "Katana crawling completed"

    # Extract subdomains from katana output
    temp_katana=$(mktemp)
    grep -oE "[a-zA-Z0-9.-]+\.$TARGET_DOMAIN" "$KATANA_FILE" | sort -u > "$temp_katana"
    if [[ -s "$temp_katana" ]]; then
        cat "$temp_katana" >> "$SUBDOMAIN_FILE"
        sort -u "$SUBDOMAIN_FILE" -o "$SUBDOMAIN_FILE"
        echo -e "${GREEN}Added $(wc -l < "$temp_katana") subdomains from katana to $SUBDOMAIN_FILE${NC}"
        log "Added $(wc -l < "$temp_katana") subdomains from katana"
    else
        echo -e "${YELLOW}No additional subdomains found by katana${NC}"
        log "No additional subdomains found by katana"
    fi
    rm -f "$temp_katana"
fi

# Fetch historical URLs with waybackurls
if command -v waybackurls >/dev/null 2>&1; then
    echo -e "${GREEN}Fetching historical URLs with waybackurls...${NC}"
    log "Starting waybackurls fetching"
    : > "$WAYBACK_FILE"
    waybackurls "$TARGET_DOMAIN" 2>>"$LOG_FILE" | grep -oE "[a-zA-Z0-9.-]+\.$TARGET_DOMAIN" | sort -u > "$WAYBACK_FILE"
    if [[ -s "$WAYBACK_FILE" ]]; then
        cat "$WAYBACK_FILE" >> "$SUBDOMAIN_FILE"
        sort -u "$SUBDOMAIN_FILE" -o "$SUBDOMAIN_FILE"
        echo -e "${GREEN}Added $(wc -l < "$WAYBACK_FILE") subdomains from waybackurls to $SUBDOMAIN_FILE${NC}"
        log "Added $(wc -l < "$WAYBACK_FILE") subdomains from waybackurls"
    else
        echo -e "${YELLOW}No subdomains found by waybackurls${NC}"
        log "No subdomains found by waybackurls"
    fi
    log "Waybackurls fetching completed"
fi

# Run GF for pattern matching on alive subdomains
if command -v gf >/dev/null 2>&1; then
    echo -e "${GREEN}Running GF for pattern matching...${NC}"
    log "Starting GF pattern matching"
    : > "$GF_FILE"
    pids=()
    while IFS=$'\t' read -r url _; do
        echo "$url" | gf xss | gf sqli | gf lfi | gf rce | gf redirect | sort -u 2>>"$LOG_FILE" | tee -a "$GF_FILE" &
        pids+=($!)
    done < "$temp_output"
    for pid in "${pids[@]}"; do
        wait "$pid" 2>>"$LOG_FILE" || log "GF process $pid failed"
    done
    if [[ -s "$GF_FILE" ]]; then
        echo -e "${GREEN}Found $(wc -l < "$GF_FILE") potential vulnerable patterns in $GF_FILE${NC}"
        log "Found $(wc -l < "$GF_FILE") patterns with GF"
    else
        echo -e "${YELLOW}No patterns found by GF${NC}"
        log "No patterns found by GF"
    fi
    log "GF pattern matching completed"
fi

# Run Arjun for parameter discovery
if command -v arjun >/dev/null 2>&1; then
    echo -e "${GREEN}Running Arjun for parameter discovery...${NC}"
    log "Starting Arjun parameter discovery"
    : > "$ARJUN_FILE"
    pids=()
    while IFS=$'\t' read -r url _; do
        arjun -u "$url" -t "$MAX_JOBS" -q -oT - 2>>"$LOG_FILE" | tee -a "$ARJUN_FILE" &
        pids+=($!)
    done < "$temp_output"
    for pid in "${pids[@]}"; do
        wait "$pid" 2>>"$LOG_FILE" || log "Arjun process $pid failed"
    done
    if [[ -s "$ARJUN_FILE" ]]; then
        echo -e "${GREEN}Found parameters in $ARJUN_FILE${NC}"
        log "Found parameters with Arjun"
    else
        echo -e "${YELLOW}No parameters found by Arjun${NC}"
        log "No parameters found by Arjun"
    fi
    log "Arjun parameter discovery completed"
fi

# Run TruffleHog for secret detection
if command -v trufflehog >/dev/null 2>&1; then
    echo -e "${GREEN}Running TruffleHog for secret detection...${NC}"
    log "Starting TruffleHog secret detection"
    : > "$TRUFFLEHOG_FILE"
    pids=()
    while IFS=$'\t' read -r url _; do
        trufflehog http --url "$url" --no-verification --concurrency "$MAX_JOBS" 2>>"$LOG_FILE" | tee -a "$TRUFFLEHOG_FILE" &
        pids+=($!)
    done < "$temp_output"
    for pid in "${pids[@]}"; do
        wait "$pid" 2>>"$LOG_FILE" || log "TruffleHog process $pid failed"
    done
    if [[ -s "$TRUFFLEHOG_FILE" ]]; then
        echo -e "${GREEN}Found $(wc -l < "$TRUFFLEHOG_FILE") potential secrets in $TRUFFLEHOG_FILE${NC}"
        log "Found $(wc -l < "$TRUFFLEHOG_FILE") secrets with TruffleHog"
    else
        echo -e "${YELLOW}No secrets found by TruffleHog${NC}"
        log "No secrets found by TruffleHog"
    fi
    log "TruffleHog secret detection completed"
fi

# Run Subzy for subdomain takeover checks
if command -v subzy >/dev/null 2>&1; then
    echo -e "${GREEN}Running Subzy for subdomain takeover checks...${NC}"
    log "Starting Subzy takeover checks"
    : > "$SUBZY_FILE"
    subzy -hide -concurrency "$MAX_JOBS" -targets "$SUBDOMAIN_FILE" 2>>"$LOG_FILE" | tee -a "$SUBZY_FILE"
    if [[ -s "$SUBZY_FILE" ]]; then
        echo -e "${GREEN}Found potential subdomain takeovers in $SUBZY_FILE${NC}"
        log "Found potential takeovers with Subzy"
    else
        echo -e "${YELLOW}No subdomain takeovers found by Subzy${NC}"
        log "No takeovers found by Subzy"
    fi
    log "Subzy takeover checks completed"
fi

# Run Hakrawler for crawling
if command -v hakrawler >/dev/null 2>&1; then
    echo -e "${GREEN}Running Hakrawler for additional crawling...${NC}"
    log "Starting Hakrawler crawling"
    temp_hakrawler=$(mktemp)
    pids=()
    while IFS=$'\t' read -r url _; do
        hakrawler -url "$url" -depth 3 -plain 2>>"$LOG_FILE" | grep -oE "[a-zA-Z0-9.-]+\.$TARGET_DOMAIN" | sort -u | tee -a "$temp_hakrawler" &
        pids+=($!)
    done < "$temp_output"
    for pid in "${pids[@]}"; do
        wait "$pid" 2>>"$LOG_FILE" || log "Hakrawler process $pid failed"
    done
    if [[ -s "$temp_hakrawler" ]]; then
        cat "$temp_hakrawler" >> "$SUBDOMAIN_FILE"
        sort -u "$SUBDOMAIN_FILE" -o "$SUBDOMAIN_FILE"
        echo -e "${GREEN}Added $(wc -l < "$temp_hakrawler") subdomains from Hakrawler to $SUBDOMAIN_FILE${NC}"
        log "Added $(wc -l < "$temp_hakrawler") subdomains from Hakrawler"
    else
        echo -e "${YELLOW}No additional subdomains found by Hakrawler${NC}"
        log "No subdomains found by Hakrawler"
    fi
    rm -f "$temp_hakrawler"
    log "Hakrawler crawling completed"
fi

# Run Gospider for crawling
if command -v gospider >/dev/null 2>&1; then
    echo -e "${GREEN}Running Gospider for additional crawling...${NC}"
    log "Starting Gospider crawling"
    temp_gospider=$(mktemp)
    pids=()
    while IFS=$'\t' read -r url _; do
        gospider -s "$url" -d 3 -c "$MAX_JOBS" -q --no-redirect 2>>"$LOG_FILE" | grep -oE "[a-zA-Z0-9.-]+\.$TARGET_DOMAIN" | sort -u | tee -a "$temp_gospider" &
        pids+=($!)
    done < "$temp_output"
    for pid in "${pids[@]}"; do
        wait "$pid" 2>>"$LOG_FILE" || log "Gospider process $pid failed"
    done
    if [[ -s "$temp_gospider" ]]; then
        cat "$temp_gospider" >> "$SUBDOMAIN_FILE"
        sort -u "$SUBDOMAIN_FILE" -o "$SUBDOMAIN_FILE"
        echo -e "${GREEN}Added $(wc -l < "$temp_gospider") subdomains from Gospider to $SUBDOMAIN_FILE${NC}"
        log "Added $(wc -l < "$temp_gospider") subdomains from Gospider"
    else
        echo -e "${YELLOW}No additional subdomains found by Gospider${NC}"
        log "No subdomains found by Gospider"
    fi
    rm -f "$temp_gospider"
    log "Gospider crawling completed"
fi

# Run SpiderFoot for OSINT
if command -v spiderfoot >/dev/null 2>&1; then
    echo -e "${GREEN}Running SpiderFoot for OSINT...${NC}"
    log "Starting SpiderFoot OSINT"
    temp_spiderfoot=$(mktemp)
    spiderfoot -s "$TARGET_DOMAIN" -m sfp_subdomain -o json 2>>"$LOG_FILE" | jq -r '.[] | .data | select(. | contains("'$TARGET_DOMAIN'"))' | grep -oE "[a-zA-Z0-9.-]+\.$TARGET_DOMAIN" | sort -u > "$temp_spiderfoot"
    if [[ -s "$temp_spiderfoot" ]]; then
        cat "$temp_spiderfoot" >> "$SUBDOMAIN_FILE"
        sort -u "$SUBDOMAIN_FILE" -o "$SUBDOMAIN_FILE"
        echo -e "${GREEN}Added $(wc -l < "$temp_spiderfoot") subdomains from SpiderFoot to $SUBDOMAIN_FILE${NC}"
        log "Added $(wc -l < "$temp_spiderfoot") subdomains from SpiderFoot"
    else
        echo -e "${YELLOW}No additional subdomains found by SpiderFoot${NC}"
        log "No subdomains found by SpiderFoot"
    fi
    rm -f "$temp_spiderfoot"
    log "SpiderFoot OSINT completed"
fi

# Run Nuclei for vulnerability scanning (if enabled)
if [[ "$NUCLEI_ENABLED" -eq 1 ]]; then
    echo -e "${GREEN}Running Nuclei for vulnerability scanning...${NC}"
    log "Starting Nuclei vulnerability scanning"
    : > "$NUCLEI_FILE"
    nuclei -l "$ALIVE_FILE" -t cves/ -t vulnerabilities/ -t misconfiguration/ -severity critical,high,medium -c "$MAX_JOBS" -o "$NUCLEI_FILE" 2>>"$LOG_FILE"
    if [[ -s "$NUCLEI_FILE" ]]; then
        echo -e "${GREEN}Found vulnerabilities in $NUCLEI_FILE${NC}"
        log "Found vulnerabilities with Nuclei"
    else
        echo -e "${YELLOW}No vulnerabilities found by Nuclei${NC}"
        log "No vulnerabilities found by Nuclei"
    fi
    log "Nuclei vulnerability scanning completed"
fi

# Clean up temporary files
rm -f "$temp_output"

echo -e "${CYAN}Processing complete! All subdomains saved in $SUBDOMAIN_FILE${NC}"
log "Processing complete"

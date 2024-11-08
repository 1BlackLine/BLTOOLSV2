#!/bin/bash

# Define colors
GREEN="\033[0;32m"
RED="\033[1;31m"
YELLOW="\033[1;33m"
CYAN="\033[1;36m"
MAGENTA="\033[1;35m"
WHITE="\033[1;37m"
LightRed="\033[0;31m"
RESET="\033[0m"
BG_RED="\033[41m"
BG_GREEN="\033[42m"
BG_YELLOW="\033[43m"
BG_BLUE="\033[44m"
BG_PURPLE="\033[45m"
# Warna teks tebal
BOLD_RED="\033[1;31m"
BOLD_GREEN="\033[1;32m"
BOLD_YELLOW="\033[1;33m"
BOLD_BLUE="\033[1;34m"

# Definisi warna
CYAN="\033[1;36m"
RESET="\033[0m"

# Definisikan teks banner
banner="""
${RED}
▄▄▄▄· ▄▄▌   ▄▄▄·  ▄▄· ▄ •▄ ▄▄▌  ▪   ▐ ▄ ▄▄▄ .
▐█ ▀█▪██•  ▐█ ▀█ ▐█ ▌▪█▌▄▌▪██•  ██ •█▌▐█▀▄.▀·
▐█▀▀█▄██▪  ▄█▀▀█ ██ ▄▄▐▀▀▄·██▪  ▐█·▐█▐▐▌▐▀▀▪▄
██▄▪▐█▐█▌▐▌▐█ ▪▐▌▐███▌▐█.█▌▐█▌▐▌▐█▌██▐█▌▐█▄▄▌
·▀▀▀▀ .▀▀▀  ▀  ▀ ·▀▀▀ ·▀  ▀.▀▀▀ ▀▀▀▀▀ █▪ ▀▀▀  """

# Fungsi animasi mengetik
function type_banner() {
    echo -e "${BOLD_RED}"
    # Looping setiap karakter dalam banner
    for ((i = 0; i < ${#banner}; i++)); do
        # Print satu karakter per iterasi tanpa newline
        echo -n "${banner:$i:1}"
        # Jeda waktu 3 milidetik (0.003 detik)
        sleep 0.000
    done
    echo -e "${RESET}"
}

# Panggil fungsi untuk menampilkan animasi banner
type_banner

clear 
# Function to set up the output directory
setup_output_dir() {
    domain=$1
    output_dir="output/$domain"
    mkdir -p "$output_dir"
    echo "$output_dir"
}

# Function to run subfinder for a single domain
run_subfinder() {
    domain=$1
    output_dir=$2
    output_file="${output_dir}/subdomains.txt"
    
    echo -e "${WHITE}🔍 Finding Subdomains For ${domain}...${RESET}"
    echo -e "${YELLOW}⊱ ─────────────────────────────────── {.⋅ ✯ ⋅.} ─────────────────────────────────── ⊰" "${YELLOW}${RESET}" 
    if command -v subfinder &> /dev/null; then
        result=$(subfinder -d "$domain" -silent)
        echo -e "${GREEN}${result}${RESET}" | lolcat
        echo "$result" > "$output_file"
        count=$(echo "$result" | wc -l)
           echo -e "⊱ ─────────────────────────────────── {.⋅ ✯ ⋅.} ─────────────────────────────────── ⊰" "${YELLOW}"
        echo -e "💥一━══デ︻▄ Find ${count} SUBDOMAIN ▄︻デ══━一💥 " "${RED}${BOLD}" | lolcat
        echo -e "${YELLOW}Subdomain disimpan di: $output_file${RESET}"
    else
        echo -e "${RED}Subfinder Not Found. Please install Subfinder first.${RESET}"
    fi
}

# Function to check active subdomains
check_active_subdomains() {
    output_dir=$1
    output_file="${output_dir}/active_subdomains.txt"
    subdomains_file="${output_dir}/subdomains.txt"
    clear
    # Menampilkan logo ASCII
    echo -e "${CYAN}"
    echo "   /\                 /\\"
    echo "  / \'._   (\\_/)   _.'/ \\"
    echo " /_.''._'--('.')--'_.''._\\"
    echo " | \\_ / \`=;/ \" \\=;\` \\ _/ |"
    echo "  \\/ \`\\__|\`\\___/\`|__/ \`  \\/"
    echo "   \`      \\(/|\\)/       \`"
    echo "           \" \` \""
    echo -e "${RESET}"
    echo -e "${WHITE}🔍 Check active subdomains...${RESET}"

           if [ -f "$subdomains_file" ]; then
        # Menggunakan httpx untuk memeriksa subdomain yang aktif, dengan filter status code 403 dan 404
        httpx -l "$subdomains_file" -fc 403,404 -silent -o "$output_file" | lolcat
        
        echo -e "${YELLOW}Active subdomains are saved at: $output_file${RESET}"
    else
        echo -e "${RED}File "$subdomains_file" Not Found.${RESET}"
    fi
}

# Function to run subfinder for a single domain
run_info() {
    domain=$1
    output_dir=$2
    output_file="${output_dir}/info.txt"

    echo -e "${WHITE}🔍 Search for domain information for ${domain}...${RESET}"
    echo -e "${YELLOW}⊱ ─────────────────────────────────── {.⋅ ✯ ⋅.} ─────────────────────────────────── ⊰${RESET}"
    clear
    # Menjalankan script Python dan mengarahkan output ke file dan terminal
    python3 modul/domain_info.py "$domain" 
}

run_urls() {
    output_dir=$1
    output_file="${output_dir}/urls.txt"
    subdomains_file="${output_dir}/active_subdomains.txt"
    clear
    # Menampilkan logo ASCII
    echo -e "${RED}"
echo -e "                                  ,        ,
                                          /(        )\`
                                          \\ \\___   / |
                                           /- _  \`-/  '
                                       (/\\/ \\ \\   /\\
                                         / /   | \`    \\
 ____  _      _    ____ _  _           O O   ) /    |
| __ )| |    / \\  / ___| |/ /           \`-^--'\`<     '
|  _ \\| |   / _ \\| |   | ' /         (_.)  _  )   /
| |_) | |__/ ___ \\ |___| . \\           \`.___/\`    /                 
|____/|____/_/   \\_\\____|_|\\_\\         \`-----' /                  
                                  <----.     ** / **   \\                      
 _     ___ _   _ _______           <--1--|====O)))==) \\) /====
| |   |_ _| \\ | | |___|           <----'    \`--' \`.__,' \\
| |    | ||  \\| |  _|                      |        |
| |___ | || |\\  | |___                     \\       /
|_____|___|_| \\_|_____|                ______( (_  / \\______
                                      ,'  ,-----'   |        \\
                                      \`--{__________)        \\/"
 
 
    echo -e "${RESET}"
    echo -e "${WHITE}🔍 Finding URLs...${RESET}"

           if [ -f "$subdomains_file" ]; then
        # Menggunakan httpx untuk memeriksa subdomain yang aktif, dengan filter status code 403 dan 404
       cat "$subdomains_file" | waybackurls | tee "$output_file" | lolcat
          echo -e "${result}${NORMAL}" | lolcat 
        count=$(echo "$result" | wc -l)
        echo -e "${YELLOW}URLS Saved at: $output_file${RESET}"
        echo -e "⊱ ─────────────────────────────────── {.⋅ ✯ ⋅.} ─────────────────────────────────── ⊰" "${YELLOW}"
    else
        echo -e "${RED}File "$subdomains_file" Not Found.${RESET}"
    fi
}

run_isub() {
    output_dir=$1
    output_file="${output_dir}/interest_sub.txt"
    subdomains_file="${output_dir}/subdomains.txt"
    clear
    echo -e      "\n\t\t\t${WHITE}🕵 Finding Interesting SUBDOMAIN${WHITE}${BOLD}"🕵
    echo -e "⊱ ─────────────────────────────────── {.⋅ ✯ ⋅.} ─────────────────────────────────── ⊰" "${YELLOW}"
    if command -v grep &> /dev/null; then
        result=$(cat "$subdomains_file" | grep -E "api|admin|mail|dev|test|manage|github|beta|jira|staging" | tee "$output_file")
        echo -e "${result}${NORMAL}" | lolcat 
        count=$(echo "$result" | wc -l)
        echo -e "⊱ ─────────────────────────────────── {.⋅ ✯ ⋅.} ─────────────────────────────────── ⊰" "${YELLOW}"
        echo -e "\n💥一━══デ︻▄ Find ${count} INTRESTING SUBDOMAIN ▄︻デ══━一💥 " "${RED}${BOLD}" | lolcat
        echo -e "${GREEN}Output Saved at: $output_file${RESET}"     
fi     
}

run_ip_scan() {
    output_dir=$1
    output_file="${output_dir}/ip.txt"
    subdomains_file="${output_dir}/subdomains.txt"
    python3 modul/ip.py 
}

run_cors() {
    output_dir=$1
    output_file="${output_dir}/cors_vulnerable.txt"
    subdomains_file="${output_dir}/active_subdomains.txt"
    clear
    echo -e "\n\t\t\t${WHITE}🌐 Finding CORS VULNERABILITY${WHITE}${BOLD} 🌐"
    echo -e "⊱ ─────────────────────────────────── {.⋅ ✯ ⋅.} ─────────────────────────────────── ⊰" "${YELLOW}"
    if [[ -f "$subdomains_file" ]]; then
        vulnerable_count=0
        if command -v curl &> /dev/null; then
            while IFS= read -r domain; do
                domain=$(echo "$domain" | xargs)
                payload="Origin: evil.com"
                response=$(curl -s -I -H "$payload" "$domain")

                if echo "$response" | grep -q "Access-Control-Allow-Origin: evil.com"; then
                    echo -e "${RED}VULNERABLE:${WHITE} $domain ${CYAN}PAYLOAD:${MAGENTA} $payload${RESET}" | tee -a "$output_file"
                    ((vulnerable_count++))
                else
                    echo -e "${GREEN}NOT VULNERABLE:${WHITE} $domain ${CYAN}PAYLOAD:${MAGENTA} $payload${RESET}"
                fi
            done < "$subdomains_file"
            
            echo -e "⊱ ─────────────────────────────────── {.⋅ ✯ ⋅.} ─────────────────────────────────── ⊰" "${YELLOW}"
            echo -e "\n💥一━══デ︻▄ FIND ${vulnerable_count} VULNERABLE SUBDOMAIN(S) ▄︻デ══━一💥 " "${RED}${BOLD}" | lolcat
            echo -e "${GREEN}Output Saved at: $output_file${RESET}"
        else
            echo -e "${RED}Command 'curl' not found. Please install it and try again.${RESET}"
        fi
    else
        echo -e "${LightRed}THE FILE PATH HAS NOT BEEN ENTERED!! <(ꐦㅍ _ㅍ)>${RESET}"
    fi
}



run_or() {
    domain=$1
    output_file=$2
     echo -e "\n\t\t\t\t${WHITE}🕵 Finding  OPEN REDIRECT Vulnerability${WHITE}${BOLD}"🕵
     echo -e "⊱ ─────────────────────────────────── {.⋅ ✯ ⋅.} ─────────────────────────────────── ⊰" "${YELLOW}" 
     clear
bash modul/redirect.sh
      count=$(echo "$result" | wc -l)
     echo -e "⊱ ─────────────────────────────────── {.⋅ ✯ ⋅.} ─────────────────────────────────── ⊰" "${YELLOW}"
     echo -e "\n💥一━══デ︻▄ Find ${count} OPEN REDIRECT Vulnerability  ▄︻デ══━一💥 " "${RED}${BOLD}" | lolcat
}

run_xss() {
  clear
 echo -e "${RED}"
echo -e "                                           ,        ,
                                          /(        )\`
                                          \\ \\___   / |
                                           /- _  \`-/  '
                                       (/\\/ \\ \\   /\\
                                         / /   | \`    \\
 ____  _      _    ____ _  _           O O   ) /    |
| __ )| |    / \\  / ___| |/ /           \`-^--'\`<     '
|  _ \\| |   / _ \\| |   | ' /         (_.)  _  )   /
| |_) | |__/ ___ \\ |___| . \\           \`.___/\`    /                 
|____/|____/_/   \\_\\____|_|\\_\\         \`-----' /                  
                                  <----.     ** / **   \\                      
 _     ___ _   _ _______           <--1--|====O)))==) \\) /====
| |   |_ _| \\ | | |___|           <----'    \`--' \`.__,' \\
| |    | ||  \\| |  _|                      |        |
| |___ | || |\\  | |___                     \\       /
|_____|___|_| \\_|_____|                ______( (_  / \\______
                                      ,'  ,-----'   |        \\
                                      \`--{__________)        \\/"
  python3 modul/xss_scanner.py 
}

run_takeover() {
  clear

  bash modul/takeover.sh 
}

run_blc() {
    output_dir=$1
    output_file="${output_dir}/broken_links.txt"
    clear
    echo -e ${RED}"
    
▗▄▄▖ ▗▄▄▖  ▗▄▖ ▗▖ ▗▖▗▄▄▄▖▗▖  ▗▖▗▖   ▗▄▄▄▖▗▖  ▗▖▗▖ ▗▖
▐▌ ▐▌▐▌ ▐▌▐▌ ▐▌▐▌▗▞▘▐▌   ▐▛▚▖▐▌▐▌     █  ▐▛▚▖▐▌▐▌▗▞▘
▐▛▀▚▖▐▛▀▚▖▐▌ ▐▌▐▛▚▖ ▐▛▀▀▘▐▌ ▝▜▌▐▌     █  ▐▌ ▝▜▌▐▛▚▖ 
▐▙▄▞▘▐▌ ▐▌▝▚▄▞▘▐▌ ▐▌▐▙▄▄▖▐▌  ▐▌▐▙▄▄▖▗▄█▄▖▐▌  ▐▌▐▌ ▐▌
 ▗▄▄▖▗▖ ▗▖▗▄▄▄▖ ▗▄▄▖▗▖ ▗▖▗▄▄▄▖▗▄▄▖ 
▐▌   ▐▌ ▐▌▐▌   ▐▌   ▐▌▗▞▘▐▌   ▐▌ ▐▌
▐▌   ▐▛▀▜▌▐▛▀▀▘▐▌   ▐▛▚▖ ▐▛▀▀▘▐▛▀▚▖
▝▚▄▄▖▐▌ ▐▌▐▙▄▄▖▝▚▄▄▖▐▌ ▐▌▐▙▄▄▖▐▌ ▐▌                                                    
                                                    
                                                    "${RESET}
echo -e ${YELLOW}⊱ ─────────────────────────────────── {.⋅ ✯ ⋅.} ─────────────────────────────────── ⊰${RESET} 
    blc https://"$domain" -r --filter-level 2 
    count=$(echo "$result" | wc -l)
}

run_grab() {
    domain=$1
    output_dir=$1
    output_file=$2
     echo -e "\n\t\t\t\t${WHITE}🕵 Finding Params${WHITE}${BOLD}"🕵
     echo -e "⊱ ─────────────────────────────────── {.⋅ ✯ ⋅.} ─────────────────────────────────── ⊰" "${YELLOW}" 
     clear
bash param.sh
      count=$(echo "$result" | wc -l)
     echo -e "⊱ ─────────────────────────────────── {.⋅ ✯ ⋅.} ─────────────────────────────────── ⊰" "${YELLOW}"
    
}

run_feroxbuster() {
    domain=$1
    output_dir="output/$domain"
    output_file="${output_dir}/directories.txt"

    # Membuat folder output jika belum ada
    mkdir -p "$output_dir"

    echo -e "🔍 Discovering Directories for $domain using Feroxbuster..."
    echo -e "⊱ ─────────────────────────────────── {.⋅ ✯ ⋅.} ─────────────────────────────────── ⊰"

    # Menjalankan feroxbuster dan menyimpan output
    if command -v feroxbuster &> /dev/null; then
        feroxbuster -u "http://$domain" -w wordlist/wordlist.txt -o "$output_file" 
        cat "$output_file" | lolcat
        echo -e "⊱ ─────────────────────────────────── {.⋅ ✯ ⋅.} ─────────────────────────────────── ⊰"
        echo -e "💥一━══デ︻▄ Directories saved to: $output_file ▄︻デ══━一💥"
    else
        echo -e "${RED}Feroxbuster not found. Please install Feroxbuster first.${RESET}"
    fi
}

run_sql() {
    domain=$1
    subdomains_file="${output_dir}/sqli_params.txt"

    # Menampilkan status awal
    echo -e "🕵 Finding SQL Injection For $domain..."
    echo -e "⊱ ─────────────────────────────────── {.⋅ ✯ ⋅.} ─────────────────────────────────── ⊰"

    # Mengecek apakah sqlmap dan dependensi lain tersedia
    if command -v sqlmap &> /dev/null; then
      
        # Menjalankan sqlmap pada URL yang dikumpulkan dan menyimpan outputnya
        sqlmap -m "${subdomains_file}" --batch --dbs --level 5 --risk 3 --random-agent --tamper=space2comment

        # Menampilkan output hasil
        cat "$output_file" | lolcat
        echo -e "⊱ ─────────────────────────────────── {.⋅ ✯ ⋅.} ─────────────────────────────────── ⊰"
    else
        echo -e "${RED}sqlmap tidak ditemukan. Pastikan semuanya sudah terpasang terlebih dahulu.${RESET}"
    fi
}


main_menu() {
    while true; do
        clear
        echo -e "$banner"
        echo -e "${CYAN}BlackLine Scanner${RESET} - ${WHITE}The Ultimate Tools For Web Hacking${RESET}"
        echo -e "${WHITE}Version: ${GREEN}2.0${RESET}    ${WHITE}Modules: ${GREEN}11${RESET}    ${WHITE}Coded by: ${GREEN}Admin 0X BlackLine${RESET}"
        echo -e "${YELLOW}──────────────────────────── {.✯ ✯ ✯.} ─────────────────────────────────${RESET}\n"
        
        # Network Analysis Section
        echo -e "${BG_RED}╰┈➤ Network & Infrastructure${RESET}"
        echo -e "${GREEN}1. ${WHITE}Subdomain Finder${RESET}" | lolcat
        echo -e "${GREEN}2. ${WHITE}Find Active Subdomains${RESET}" | lolcat
        echo -e "${GREEN}3. ${WHITE}Peek into domain information${RESET}" | lolcat
        echo -e "${GREEN}4. ${WHITE}Track IP & Location Website${RESET}" | lolcat
        echo -e ""
        
        # Web Intelligence Section
        echo -e "${BG_BLUE}╰┈➤ Web Application Analysis${RESET}" 
        echo -e "${GREEN}5. ${WHITE}Discover Hidden URLs${RESET}" | lolcat
        echo -e "${GREEN}6. ${WHITE}Filter Interesting Subdomains${RESET}" | lolcat
        echo -e "${GREEN}7. ${WHITE}Broken Link Checker${RESET}" | lolcat
        echo -e "${GREEN}8. ${WHITE}Grab Param XSS,SQLI,LFI,OPEN REDIRECT${RESET}" | lolcat
        echo -e "${GREEN}9. ${WHITE}Discovery Sensitive Directory${RESET}" | lolcat
        echo -e ""
        
        # Web Intelligence Section
        echo -e "${BG_PURPLE}╰┈➤ Web Vulnerable Scanner ${RESET}"
        echo -e "${GREEN}10.${WHITE}CORS MISCONFIGURATION Vulnerability${RESET}" | lolcat
        echo -e "${GREEN}11.${WHITE}Open Redirect Vulnerability${RESET}" | lolcat
        echo -e "${GREEN}12.${WHITE}XSS Vulnerability${RESET}" | lolcat
        echo -e "${GREEN}13.${WHITE}Subdomain Takeover Vulnerability${RESET}" | lolcat
        echo -e "${GREEN}14.${WHITE}Find MASS SQL Injection${RESET}" | lolcat
        echo -e ""
        
        # Exit Option
        echo -e "${BOLD_RED}0. ${RED}Exit!${RESET}"
          echo -e "${YELLOW}──────────────────────────── {.✯ ✯ ✯.} ─────────────────────────────────${RESET}"
   
        # Separator line
        echo -e "\n${RED}root${WHITE}@${CYAN}BlackLine${WHITE}︻デ══━一💥:~# ${RESET}\\c"
        read choice

        case $choice in
            1)
                read -p "Enter the domain (example: example.com): " domain
                output_dir=$(setup_output_dir "$domain")
                run_subfinder "$domain" "$output_dir"
                ;;
            2)
                read -p "Enter the domain that was scanned earlier from option number 1: " domain
                output_dir="output/$domain"
                check_active_subdomains "$output_dir"
                ;;
            3)
                read -p "Which domain do you want to peek at?: " domain
                output_dir="output/$domain"
                run_info "$domain"
                ;;
            4)
                output_dir="output/$domain"
                run_ip_scan
                ;;
            5)
                read -p "Just type in the domain name: " domain
                output_dir="output/$domain"
                run_urls "$output_dir"
                ;;
            6)
                read -p "Find interesting subdomains from which domains?: " domain
                output_dir="output/$domain"
                run_isub "$output_dir"
                ;;
            7)
                read -p "Enter Domain name?: " domain
                output_dir="output/$domain"
                run_blc "$output_dir"
                ;;
            8)
                output_dir="output/$domain"
                run_grab "$output_dir"
                ;;
            9)
                read -p "Enter Domain name?: " domain
                output_dir="output/$domain"
                run_feroxbuster "$domain"
                ;;
            10)
                read -p "Enter Domain name?: " domain
                output_dir="output/$domain"
                run_cors "$output_dir"
                ;;
            11)
                output_dir="output/$domain"
                run_or "$output_dir"
                ;;
            12)
                output_dir="output/$domain"
                run_xss "$output_dir"
                ;;
            13)
                output_dir="output/$domain"
                run_takeover "$output_dir"
                ;;    
            14) read -p "Enter the domain name after executing option number 8: " domain 
                output_dir="output/$domain"
                run_sql "$output_dir"
                ;;  
        
            0)
                echo -e "${GREEN}Thank you for using the BlackLine Scanner! See you again!${RESET}"
                exit 0
                ;;
            *)
                echo -e "${RED}Ouch, this choice is invalid. Try again, OK?${RESET}"
                sleep 2
                ;;
        esac
        
        echo -e "\n${YELLOW}Press Enter to continue...${RESET}"
        read
    done
}
# Start the program
main_menu


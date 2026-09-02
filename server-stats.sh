```bash
#!/bin/bash

# ==========================================================
# EC2 Server Performance Statistics
# Compatible with Amazon Linux 2 / Amazon Linux 2023
# ==========================================================

echo "=========================================================="
echo "          AMAZON EC2 SERVER PERFORMANCE REPORT"
echo "=========================================================="

echo "Hostname : $(hostname)"
echo "Instance : $(curl -s http://169.254.169.254/latest/meta-data/instance-id)"
echo "Date     : $(date)"

echo "=========================================================="


# ==========================================================
# 1. CPU USAGE
# ==========================================================

echo
echo "-------------------- CPU USAGE ---------------------------"

CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{
    printf "%.2f", 100 - $8
}')

echo "Total CPU Usage : ${CPU_USAGE}%"


# ==========================================================
# 2. MEMORY USAGE
# ==========================================================

echo
echo "------------------- MEMORY USAGE -------------------------"

free -m | awk '
NR==1 {
    printf "%-10s %-12s %-12s %-12s %-12s\n",
    "Type", "Total(MB)", "Used(MB)", "Free(MB)", "Usage"
}

NR==2 {
    used_percent=($3/$2)*100
    free_percent=($4/$2)*100

    printf "%-10s %-12s %-12s %-12s %.2f%%\n",
    "Memory", $2, $3, $4, used_percent

    printf "\nMemory Used : %.2f%%\n", used_percent
    printf "Memory Free : %.2f%%\n", free_percent
}'


# ==========================================================
# 3. DISK USAGE
# ==========================================================

echo
echo "-------------------- DISK USAGE --------------------------"

df -h / | awk '
NR==2 {
    used_percent=$5
    free_percent=100-substr($5,1,length($5)-1)

    printf "Filesystem     : %s\n", $1
    printf "Total Disk     : %s\n", $2
    printf "Used Disk      : %s (%s)\n", $3, $5
    printf "Free Disk      : %s (%d%%)\n", $4, free_percent
}'


# ==========================================================
# 4. TOP 5 PROCESSES BY CPU
# ==========================================================

echo
echo "--------------- TOP 5 CPU PROCESSES ----------------------"

printf "%-8s %-15s %-25s %-8s\n" \
       "PID" "USER" "COMMAND" "CPU%"

ps -eo pid,user,comm,%cpu --sort=-%cpu | \
awk 'NR>1 && NR<=6 {
    printf "%-8s %-15s %-25s %-8s\n",
    $1, $2, $3, $4
}'


# ==========================================================
# 5. TOP 5 PROCESSES BY MEMORY
# ==========================================================

echo
echo "-------------- TOP 5 MEMORY PROCESSES --------------------"

printf "%-8s %-15s %-25s %-8s\n" \
       "PID" "USER" "COMMAND" "MEM%"

ps -eo pid,user,comm,%mem --sort=-%mem | \
awk 'NR>1 && NR<=6 {
    printf "%-8s %-15s %-25s %-8s\n",
    $1, $2, $3, $4
}'


# ==========================================================
# END
# ==========================================================

echo
echo "=========================================================="
echo "              END OF EC2 PERFORMANCE REPORT"
echo "=========================================================="
```

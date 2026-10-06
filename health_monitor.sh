

set -euo pipefail

LOG_DIR="./logs"
REPORT_DIR="./reports"


LOG_FILE="$LOG_DIR/health.log"
STATUS="HEALTHY"
mkdir -p "$LOG_DIR" "$REPORT_DIR"
check_cpu() {
    local cpu_usage

    cpu_usage=$(top -bn1 | awk '/Cpu\(s\)/ {print 100 - $8}' | tr -d '%')

    if (( ${cpu_usage%.*} >= 80 )); then
    echo "CPU: WARNING - ${cpu_usage}%"
    STATUS="WARNING"
else
    echo "CPU: OK - ${cpu_usage}%"
fi
}
check_memory() {
    local memory_usage

    memory_usage=$(free | awk '/Mem:/ {printf "%.0f", ($3/$2) * 100}')

    if (( memory_usage >= 80 )); then
    echo "Memory: WARNING - ${memory_usage}%"
    STATUS="WARNING"
else
    echo "Memory: OK - ${memory_usage}%"
fi
}
check_disk() {
    local disk_usage

    disk_usage=$(df -P / | awk 'NR==2 {gsub("%","",$5); print $5}')

    if (( disk_usage >= 80 )); then
    echo "Disk: WARNING - ${disk_usage}%"
    STATUS="WARNING"
else
    echo "Disk: OK - ${disk_usage}%"
fi
}
check_ssh() {
    if systemctl is-active --quiet ssh; then
        echo "SSH: OK - service is running"
    else
        echo "SSH: WARNING - service is not running"
    fi
}
check_network() {
    if ping -c 1 -W 2 8.8.8.8 >/dev/null 2>&1; then
        echo "Network: OK - internet reachable"
    else
    echo "Network: WARNING - internet unreachable"
    STATUS="WARNING"
fi
}
check_service() {
    local service="$1"

    if systemctl is-active --quiet "$service"; then
        echo "Service ($service): OK - running"
    else
    echo "Service ($service): WARNING - not running"
    STATUS="WARNING"
fi
}

echo "===== Health Check: $(date) =====" | tee -a "$LOG_FILE"
echo "Overall Status: $STATUS" | tee -a "$LOG_FILE"
echo "================================" | tee -a "$LOG_FILE"
check_cpu | tee -a "$LOG_FILE"
check_memory | tee -a "$LOG_FILE"
check_disk | tee -a "$LOG_FILE"
check_network | tee -a "$LOG_FILE"
check_service ssh | tee -a "$LOG_FILE"

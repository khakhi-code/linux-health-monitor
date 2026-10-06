# Linux System Health Monitor

A Bash-based Linux system health monitoring tool that checks CPU, memory, disk usage, network connectivity, and SSH service status.

## Features

- CPU usage monitoring
- Memory usage monitoring
- Disk usage monitoring
- Internet connectivity check
- SSH service check
- Warning thresholds
- Overall health status
- Timestamped health logs
- Exit codes for automation
- Automatic execution using cron

## Requirements

- Linux
- Bash
- `top`
- `free`
- `df`
- `ping`
- `systemctl`
- `awk`

## Usage

Make the script executable:

```bash
chmod +x health_monitor.sh

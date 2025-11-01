#!/bin/bash

# SSH connection details
HOST="62.113.111.84"
USER="root"
PASSWORD="asj8PY3S*m!F"

echo "=== Подключение к серверу $HOST ==="

# Create expect script
cat > /tmp/ssh_docker_cleanup.exp << 'EOF'
#!/usr/bin/expect -f

set timeout 30
set host [lindex $argv 0]
set user [lindex $argv 1]
set password [lindex $argv 2]

spawn ssh -o StrictHostKeyChecking=no $user@$host

expect {
    "*password*" {
        send "$password\r"
        exp_continue
    }
    "*#*" {
        send "echo '=== Текущие контейнеры ==='\r"
        expect "*#*"
        send "docker ps -a\r"
        expect "*#*"

        send "echo '\r=== Текущие образы ==='\r"
        expect "*#*"
        send "docker images\r"
        expect "*#*"

        send "echo '\r=== Текущие volumes ==='\r"
        expect "*#*"
        send "docker volume ls\r"
        expect "*#*"

        send "echo '\r=== Очистка остановленных контейнеров ==='\r"
        expect "*#*"
        send "docker container prune -f\r"
        expect "*#*"

        send "echo '\r=== Очистка неиспользуемых образов ==='\r"
        expect "*#*"
        send "docker image prune -f\r"
        expect "*#*"

        send "echo '\r=== Очистка неиспользуемых volumes ==='\r"
        expect "*#*"
        send "docker volume prune -f\r"
        expect "*#*"

        send "echo '\r=== Очистка неиспользуемых сетей ==='\r"
        expect "*#*"
        send "docker network prune -f\r"
        expect "*#*"

        send "echo '\r=== Итоговое состояние ==='\r"
        expect "*#*"
        send "docker system df\r"
        expect "*#*"

        send "exit\r"
    }
}

expect eof
EOF

chmod +x /tmp/ssh_docker_cleanup.exp

# Run the expect script
/tmp/ssh_docker_cleanup.exp "$HOST" "$USER" "$PASSWORD"

# Cleanup
rm -f /tmp/ssh_docker_cleanup.exp

echo ""
echo "=== Очистка Docker завершена ==="

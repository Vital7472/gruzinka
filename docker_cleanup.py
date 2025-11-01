#!/usr/bin/env python3

import paramiko
import time

# SSH connection details
HOST = "62.113.111.84"
USER = "root"
PASSWORD = "asj8PY3S*m!F"

def execute_command(ssh, command, wait_time=2):
    """Execute command and return output"""
    stdin, stdout, stderr = ssh.exec_command(command)
    time.sleep(wait_time)
    output = stdout.read().decode('utf-8')
    error = stderr.read().decode('utf-8')

    if output:
        print(output)
    if error:
        print(f"Error: {error}")

    return output, error

try:
    print(f"=== Подключение к серверу {HOST} ===\n")

    # Create SSH client
    ssh = paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())

    # Connect to the server
    ssh.connect(HOST, username=USER, password=PASSWORD)
    print("✓ Подключение установлено\n")

    # Check current state
    print("=== Текущие контейнеры ===")
    execute_command(ssh, "docker ps -a")

    print("\n=== Текущие образы ===")
    execute_command(ssh, "docker images")

    print("\n=== Текущие volumes ===")
    execute_command(ssh, "docker volume ls")

    print("\n=== Использование диска Docker ===")
    execute_command(ssh, "docker system df")

    # Cleanup operations
    print("\n=== Очистка остановленных контейнеров ===")
    execute_command(ssh, "docker container prune -f")

    print("\n=== Очистка неиспользуемых образов ===")
    execute_command(ssh, "docker image prune -f")

    print("\n=== Очистка неиспользуемых volumes ===")
    execute_command(ssh, "docker volume prune -f")

    print("\n=== Очистка неиспользуемых сетей ===")
    execute_command(ssh, "docker network prune -f")

    # Final state
    print("\n=== Итоговое использование диска Docker ===")
    execute_command(ssh, "docker system df")

    print("\n=== Итоговые контейнеры ===")
    execute_command(ssh, "docker ps -a")

    # Close connection
    ssh.close()
    print("\n✓ Очистка Docker завершена успешно!")

except Exception as e:
    print(f"Ошибка: {e}")

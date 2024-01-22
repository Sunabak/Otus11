#!/bin/bash
# Проверка запуска скрипта под root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root."
    exit 1
fi
# Цикл для каждого процесса /proc
for pid in $(ls /proc | grep "^[0-9]" | sort -n); do
    # Проверка папки процесса
    if [[ -d "/proc/$pid" ]]; then
        # Получчение имени процесса
        process_name=$(cat "/proc/$pid/cmdline" | tr -d '\0' | cut -d ' ' -f 1)
        # Получения списка открытых файлов
        open_files=$(ls -l -N "/proc/$pid/fd" 2>/dev/null | grep -v dev | grep -v pipe | grep -v socket | grep -v anon | awk '{print $11}' ) 
        open_filesmp=$(ls -l -N "/proc/$pid/map_files" 2>/dev/null | grep so | awk '{print $11}' )  
        # Вывод файлов открытых процессами
            echo "Process ID: $pid, Process Name: $process_name"
            echo "Open Files: $open_files"
	    echo "$open_filesmp"
    fi
done


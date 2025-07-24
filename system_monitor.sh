#!/bin/bash

# Define o limite de valores da CPU

CPU_THRESHOLD=80
MEMORY_THRESHOLD=80
DISK_THRESHOLD=80

# Função para enviar o alerta
send_alert(){
    echo "$(tput setaf 1)ALERT: $1 usage exceeded threshold! Current value:$2$(tput sgr0)"
}
# sgr0 é o padrão do terminal || setaf 1 -> deixa o terminal vermelho para dar a sensação de alerta 
#while true; do
# Logica para monitorar o CPU

cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $3}') 
#top -bn1 -b executa em batch -n mostra o número de atualizações dos processos em execução e depois termina
#grep vai procurar o que conter "Cpu(s)"
#awk vai extrair e somar a soma das porcentagens do usuário e do sistema.

cpu_usage=${cpu_usage%.*} # Converte o valor para inteiro
echo "Current CPU usage: $cpu_usage%"

if ((cpu_usage >= CPU_THRESHOLD)); then
send_alert "CPU" "$cpu_usage"
fi

# Logica para monitorar a Memória

mem_usage=$(free | awk '/Mem/ {printf("%3.1f", ($3/$2) * 100)}' | bc -l)

if ((mem_usage >= MEMORY_THRESHOLD)); then
send_alert "MEMORY" "$mem_usage%"
fi

# Logica para monitorar o Disco

disk_usage=$(df -h --total | awk '/total/ {gsub(/%/, "", $5);print $5}') # gsub(/padrão/,"novo_texto", variável)

if ((disk_usage >= DISK_THRESHOLD)); then
send_alert "Disk" "$disk_usage%"
fi

# Exibe as informações de uso da máquina

#clear
echo "CPU: $cpu_usage %"
echo "MEM: $mem_usage %"
echo "DISK: $disk_usage %"

#done

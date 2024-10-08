#!/bin/bash

REPO_URL="https://github.com/EvgeniyaBalanyuk/shvirtd-example-python"
PROJECT_DIR="/opt/shvirtd-example-python"

# Функция для проверки ошибки
check_error() {
    if [ $? -ne 0 ]; then
        echo "Произошла ошибка на этапе: $1"
        exit 1
    fi
}

# Установка необходимых пакетов и подготовка к установке Docker
echo "Обновление списка пакетов..."
sudo apt-get update
check_error "Обновление списка пакетов"

echo "Установка git..."
sudo apt-get install -y git
check_error "Установка git"

# Удаление старых версий Docker и конфликтующих пакетов
echo "Удаление старых версий Docker и конфликтующих пакетов..."
sudo apt-get remove -y docker docker-engine docker.io containerd runc
check_error "Удаление старых версий Docker"

# Установка зависимостей для Docker
echo "Установка зависимостей для Docker..."
sudo apt-get install -y ca-certificates curl gnupg lsb-release
check_error "Установка зависимостей для Docker"

# Добавление GPG ключа Docker
echo "Добавление ключа GPG для Docker..."
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
check_error "Добавление ключа GPG для Docker"

# Добавление репозитория Docker
echo "Добавление репозитория Docker..."
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
check_error "Добавление репозитория Docker"

# Установка Docker и Docker Compose
echo "Установка Docker и Docker Compose..."
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
check_error "Установка Docker и Docker Compose"

# Скачивание репозитория
if [ -d "$PROJECT_DIR" ]; then
    echo "Проект уже существует в $PROJECT_DIR, удаление старой версии..."
    sudo rm -rf "$PROJECT_DIR"
fi

echo "Клонирование репозитория в $PROJECT_DIR..."
sudo git clone "$REPO_URL" "$PROJECT_DIR"
check_error "Клонирование репозитория"

# Переход в каталог проекта
cd "$PROJECT_DIR" || exit
check_error "Переход в каталог проекта"

# Запуск проекта через Docker Compose
echo "Запуск проекта с помощью Docker Compose..."
sudo docker compose up --build -d
check_error "Запуск проекта"

echo "Проект успешно запущен!"

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

# Установка необходимых пакетов
echo "Обновление списка пакетов..."
sudo apt-get update
check_error "Обновление списка пакетов"

echo "Установка git..."
sudo apt-get install -y git
check_error "Установка git"

echo "Установка Docker..."
sudo apt-get install -y docker.io
check_error "Установка Docker"

echo "Установка Docker Compose..."
sudo apt-get install -y docker-compose-plugin
check_error "Установка Docker Compose"

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

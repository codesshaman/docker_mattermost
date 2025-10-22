#!/bin/bash

# Проверяем наличие каталога mattermost
if [ ! -d "mattermost" ]; then
  # Создаем каталог mattermost
  mkdir mattermost

  # Создаем каталоги внутри mattermost
  mkdir -p mattermost/app/mattermost/client-plugins
  mkdir mattermost/config
  mkdir mattermost/data
  mkdir mattermost/logs
  mkdir mattermost/plugins
fi

# Проверяем наличие каталога volumes
if [ ! -d "volumes" ]; then
  # Создаем каталог mattermost
  mkdir volumes

  # Создаем каталоги внутри volumes
  mkdir -p volumes/web/cert
  mkdir -p /volumes/db/var/lib/postgresql/data
fi
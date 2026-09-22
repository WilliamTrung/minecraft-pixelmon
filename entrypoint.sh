#!/usr/bin/env bash
set -euo pipefail

INSTALL_DIR=/opt/install
DATA_DIR=/data
MEMORY="${MEMORY:-6G}"

if [ "${EULA:-false}" != "true" ]; then
  echo "EULA not accepted. Set EULA=true (https://aka.ms/MinecraftEULA) and restart."
  exit 1
fi

mkdir -p "$DATA_DIR/mods"

if [ ! -f "$DATA_DIR/run.sh" ]; then
  echo "No install found in /data, running NeoForge installer..."
  cp "$INSTALL_DIR/neoforge-installer.jar" "$DATA_DIR/neoforge-installer.jar"
  cd "$DATA_DIR"
  java -jar neoforge-installer.jar --installServer
  rm -f neoforge-installer.jar neoforge-installer.jar.log run.bat
  chmod +x run.sh
fi

echo "eula=true" > "$DATA_DIR/eula.txt"

cp -f "$INSTALL_DIR/pixelmon-server.jar" "$DATA_DIR/mods/pixelmon-server.jar"

echo "-Xmx${MEMORY} -Xms${MEMORY}" > "$DATA_DIR/user_jvm_args.txt"

cd "$DATA_DIR"
exec ./run.sh nogui

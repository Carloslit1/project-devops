#!/bin/bash

set -e

DIRECTORIO="$1"
BUCKET="$2"
LOG_FILE="logs/backup_$(date +%Y%m%d_%H%M%S).log"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
ARCHIVO="backup_${TIMESTAMP}.tar.gz"

mkdir -p logs

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

if [ -z "$DIRECTORIO" ] || [ -z "$BUCKET" ]; then
  log "Error: uso correcto -> bash s3/backup_s3.sh <directorio> <bucket>"
  exit 1
fi

if [ ! -d "$DIRECTORIO" ]; then
  log "Error: el directorio '$DIRECTORIO' no existe."
  exit 1
fi

log "Iniciando compresión del directorio $DIRECTORIO"
tar -czf "$ARCHIVO" -C "$DIRECTORIO" .
log "Archivo comprimido generado: $ARCHIVO"

log "Subiendo archivo a S3: s3://$BUCKET/"
aws s3 cp "$ARCHIVO" "s3://$BUCKET/"
log "Subida completada correctamente"

rm -f "$ARCHIVO"
log "Archivo temporal eliminado"
log "Proceso finalizado con éxito"

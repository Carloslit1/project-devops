#!/bin/bash

set -e

ACCION="$1"
INSTANCE_ID_ARG="$2"
DIRECTORIO_ARG="$3"
BUCKET_ARG="$4"

LOG_FILE="logs/deploy_$(date +%Y%m%d_%H%M%S).log"
mkdir -p logs

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

if [ -f config/config.env ]; then
  source config/config.env
fi

ACCION_FINAL="${ACCION}"
INSTANCE_ID_FINAL="${INSTANCE_ID_ARG:-$INSTANCE_ID}"
DIRECTORIO_FINAL="${DIRECTORIO_ARG:-$DIRECTORY}"
BUCKET_FINAL="${BUCKET_ARG:-$BUCKET_NAME}"
REGION_FINAL="${REGION}"

if [ -z "$ACCION_FINAL" ]; then
  log "Error: debes indicar una acción EC2."
  exit 1
fi

if [ "$ACCION_FINAL" != "listar" ] && [ -z "$INSTANCE_ID_FINAL" ]; then
  log "Error: falta INSTANCE_ID."
  exit 1
fi

if [ -z "$DIRECTORIO_FINAL" ] || [ -z "$BUCKET_FINAL" ]; then
  log "Error: faltan DIRECTORY o BUCKET_NAME."
  exit 1
fi

log "Iniciando despliegue controlado"
log "Acción EC2: $ACCION_FINAL"

if [ "$ACCION_FINAL" = "listar" ]; then
  python3 ec2/gestionar_ec2.py listar "$REGION_FINAL" | tee -a "$LOG_FILE"
else
  python3 ec2/gestionar_ec2.py "$ACCION_FINAL" "$INSTANCE_ID_FINAL" "$REGION_FINAL" | tee -a "$LOG_FILE"
fi

bash s3/backup_s3.sh "$DIRECTORIO_FINAL" "$BUCKET_FINAL" | tee -a "$LOG_FILE"

log "Deploy finalizado correctamente"

# Proyecto DevOps: Automatización EC2 y S3

## Descripción
Este proyecto implementa una solución automatizada para la gestión de instancias EC2 y respaldo de archivos en Amazon S3, utilizando Python, Bash y un script de despliegue.

Permite ejecutar acciones sobre EC2 y realizar respaldos automáticos hacia la nube.

---

## Estructura del proyecto

project-devops/
│── ec2/
│   └── gestionar_ec2.py
│── s3/
│   └── backup_s3.sh
│── config/
│   └── config.env
│── data/
│── logs/
│── deploy.sh
│── README.md

---

## Configuración

Archivo config/config.env:

INSTANCE_ID=i-0924305d962c10f16  
BUCKET_NAME=cgsg-devops-backup-2026  
DIRECTORY=./data  
REGION=us-east-1  

---

## Funcionalidades

### Script Python (EC2)
Permite:
- Listar instancias
- Iniciar instancia
- Detener instancia
- Terminar instancia

Ejemplo:
python3 ec2/gestionar_ec2.py listar us-east-1

---

### Script Bash (S3)
Permite:
- Comprimir un directorio
- Subirlo a S3
- Generar logs

Ejemplo:
bash s3/backup_s3.sh ./data cgsg-devops-backup-2026

---

### Script deploy.sh
Orquesta todo el flujo:

Ejemplo:
./deploy.sh listar  
./deploy.sh iniciar i-0924305d962c10f16 ./data cgsg-devops-backup-2026  

---

## Logs

Ubicación:
logs/

Ejemplo:
Proceso finalizado con éxito  
Deploy finalizado correctamente  

---

## Validación en S3

Bucket utilizado:
s3://cgsg-devops-backup-2026

---

## Control de versiones

Se utilizaron ramas:
- main
- develop
- feature/ec2-script

Commits progresivos con prefijo feat y chore.

---

## Pruebas realizadas

- Script Python ejecutado correctamente
- Script Bash ejecutado correctamente
- deploy.sh ejecutado correctamente
- Logs generados correctamente
- Archivos almacenados en S3

---

## Reflexión

Este proyecto permitió integrar automatización de infraestructura, scripting y servicios cloud, simulando un flujo tipo DevOps.

---

## Conclusión

Se logró automatizar la gestión de EC2 y el respaldo en S3 con un flujo funcional, modular y escalable.

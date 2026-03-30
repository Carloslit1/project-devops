#!/usr/bin/env python3
import sys
import boto3
from botocore.exceptions import ClientError, NoCredentialsError, EndpointConnectionError

def get_ec2_client(region=None):
    return boto3.client("ec2", region_name=region)

def listar_instancias(region=None):
    ec2 = get_ec2_client(region)
    response = ec2.describe_instances()
    found = False

    for reservation in response.get("Reservations", []):
        for instance in reservation.get("Instances", []):
            found = True
            instance_id = instance.get("InstanceId", "N/A")
            state = instance.get("State", {}).get("Name", "N/A")
            instance_type = instance.get("InstanceType", "N/A")
            print(f"ID: {instance_id} | Estado: {state} | Tipo: {instance_type}")

    if not found:
        print("No se encontraron instancias.")

def iniciar_instancia(instance_id, region=None):
    ec2 = get_ec2_client(region)
    ec2.start_instances(InstanceIds=[instance_id])
    print(f"Instancia iniciada: {instance_id}")

def detener_instancia(instance_id, region=None):
    ec2 = get_ec2_client(region)
    ec2.stop_instances(InstanceIds=[instance_id])
    print(f"Instancia detenida: {instance_id}")

def terminar_instancia(instance_id, region=None):
    ec2 = get_ec2_client(region)
    ec2.terminate_instances(InstanceIds=[instance_id])
    print(f"Instancia terminada: {instance_id}")

def main():
    if len(sys.argv) < 2:
        print("Uso:")
        print("  python3 gestionar_ec2.py listar [region]")
        print("  python3 gestionar_ec2.py iniciar <instance_id> [region]")
        print("  python3 gestionar_ec2.py detener <instance_id> [region]")
        print("  python3 gestionar_ec2.py terminar <instance_id> [region]")
        sys.exit(1)

    accion = sys.argv[1].lower()

    try:
        if accion == "listar":
            region = sys.argv[2] if len(sys.argv) > 2 else None
            listar_instancias(region)

        elif accion in ["iniciar", "detener", "terminar"]:
            if len(sys.argv) < 3:
                print(f"Falta instance_id para la acción: {accion}")
                sys.exit(1)

            instance_id = sys.argv[2]
            region = sys.argv[3] if len(sys.argv) > 3 else None

            if accion == "iniciar":
                iniciar_instancia(instance_id, region)
            elif accion == "detener":
                detener_instancia(instance_id, region)
            elif accion == "terminar":
                terminar_instancia(instance_id, region)

        else:
            print(f"Acción no válida: {accion}")
            sys.exit(1)

    except NoCredentialsError:
        print("Error: no se encontraron credenciales AWS configuradas.")
        sys.exit(1)
    except EndpointConnectionError as e:
        print(f"Error de conexión con AWS: {e}")
        sys.exit(1)
    except ClientError as e:
        print(f"Error de AWS: {e}")
        sys.exit(1)
    except Exception as e:
        print(f"Error inesperado: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()

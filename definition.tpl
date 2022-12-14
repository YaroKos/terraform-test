[
    {
      "name": "${prefix}-${environment}-container",
      "image": "yarokos/petclinic:latest",
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${cloudwatch_log_group}",
          "awslogs-region": "us-east-1",
          "awslogs-stream-prefix": "petclinic"
        }
      },
      "environment": [
        {
          "name": "SPRING_PROFILES_ACTIVE",
          "value": "mysql"
        },
        {
          "name": "SPRING_DATASOURCE_URL",
          "value": "jdbc:mysql://${db_address}/${db_name}"
        },
        {
          "name": "SPRING_DATASOURCE_USERNAME",
          "value": "${db_username}"
        },
        {
          "name": "SPRING_DATASOURCE_PASSWORD",
          "value": "${db_password}"
        }
      ],
      "portMappings": [
        {
          "containerPort": 8080,
          "hostPort": 0
        }
      ],
      "memoryReservation": 300
    }
]
FROM python:3.10-slim

# Evita que Python genere archivos .pyc y hace que los prints salgan al toque
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# mysqlclient necesita el compilador y los headers de MySQL/MariaDB para instalarse
RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential default-libmysqlclient-dev pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Directorio de trabajo dentro del contenedor
WORKDIR /app

# Instala dependencias primero para aprovechar la cache de capas
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copia el código de la app (lo que está en /app del repo)
COPY app/ .

# Puerto en el que escucha Flask (ver app/main.py)
EXPOSE 8080

# Comando para arrancar la app
CMD ["python", "main.py"]

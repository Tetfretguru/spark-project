# Utiliza una imagen de Python 3.8 como base
FROM python:3.8

# Instala las dependencias necesarias, incluyendo pyspark y jupyterlab
RUN pip install distlib==0.3.4 \
    filelock==3.0.12 \
    platformdirs==2.5.2 \
    pyspark==3.3.0 \
    six==1.16.0 \
    jupyterlab

# Copia tu aplicación al directorio de trabajo dentro del contenedor
COPY . /app

# Establece /app como el directorio de trabajo
WORKDIR /app

# Agrega un usuario no root y establece los permisos para /app
RUN useradd -m nonroot && \
    chown -R nonroot /app

# Cambia al usuario no root antes de ejecutar Jupyter Lab
USER nonroot

# Comando para ejecutar Jupyter Lab
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--no-browser"]

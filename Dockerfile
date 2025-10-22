# Usa una imagen base ligera de Linux
FROM ubuntu:22.04

# Variables de entorno para el proxy
ENV SQUID_PORT=3128

# Instalar Squid y dependencias
RUN apt-get update && \
    apt-get install -y squid && \
    rm -rf /var/lib/apt/lists/*+

# Exponer el puerto del proxy
EXPOSE ${SQUID_PORT}

# Copiar los archivos de configuración desde el host al contenedor
# Esto garantiza que tu configuración personalizada será usada
COPY ./squid.conf /etc/squid/squid.conf
COPY ./whitelist.txt /etc/squid/whitelist.txt

# Limpiar las configuraciones por defecto (opcional)
RUN rm -f /etc/squid/squid.conf.default

# Ejecutar Squid en primer plano cuando el contenedor se inicie
# La opción -N evita que se ejecute como un daemon, lo que es necesario para Docker
CMD ["/usr/sbin/squid", "-N", "-f", "/etc/squid/squid.conf"]
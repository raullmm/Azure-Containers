# Usar la imagen base de Nginx
FROM nginx:1.27.1

# Actualizar y eliminar archivos por defecto de Nginx
RUN apt-get update && apt-get install -y vim && \
    rm /etc/nginx/conf.d/default.conf && \
    rm /usr/share/nginx/html/index.html

# Copiar la configuración de Nginx personalizada (minijuegos.conf)
COPY minijuegos.conf /etc/nginx/conf.d/default.conf

# Copiar los archivos HTML necesarios para los minijuegos y el dashboard
COPY index-minijuego1.html /usr/share/nginx/html/minijuego1/index.html
COPY index-minijuego2.html /usr/share/nginx/html/minijuego2/index.html
COPY index-dashboard.html /usr/share/nginx/html/index.html

# Exponer el puerto 80 (el puerto por defecto para Nginx)
EXPOSE 80

# Comando por defecto para ejecutar Nginx
CMD ["nginx", "-g", "daemon off;"]



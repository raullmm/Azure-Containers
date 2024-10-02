La idea es crear un contenedor con una imagen donde en el path / se muestre el index.html y en el path /minijuego1 se muestre el path index-minijuego.hmtl.

Los pasos serán 

- Crear la imagen
- Subirla a docker hub
- Desplegarla en una web app de Azure

VIDEO PARA HOW TO AZURE

Subir imagenes a tu docker Hub -->

docker login

docker tag nombre_imagen_local:version_imagen_local nombre_respositorio/nombre_imagen_repositorio:version_imagen_repositorio

docker push nombre_respositorio/nombre_imagen_repositorio:version_imagen_repositorio
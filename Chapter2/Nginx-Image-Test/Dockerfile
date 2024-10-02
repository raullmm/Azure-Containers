FROM nginx:1.27.1


RUN apt-get update && apt-get install -y vim && \
    rm /etc/nginx/conf.d/default.conf && \
    rm /usr/share/nginx/html/index.html


COPY minijuegos.conf /etc/nginx/conf.d/default.conf


COPY index-minijuego1.html /usr/share/nginx/html/minijuego1/index.html
COPY index-minijuego2.html /usr/share/nginx/html/minijuego2/index.html
COPY index-dashboard.html /usr/share/nginx/html/index.html


EXPOSE 80


CMD ["nginx", "-g", "daemon off;"]



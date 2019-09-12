docker run nombre-de-la-imagen # ejecuta un contenedor con un nombre por defecto
docker ps -a # muestra todos los contenedores que se están ejecutando
docker inspect nombre-del-contenedor # también sirve el id del contenedor
docker inspect -f '{{ json .Config.Env }}' nombre-del-contenedor # también sirve el id del contenedor
docker rename antiguo-nombre nuevo-nombre
docker run --name nombre-del-contenedor nombre-de-la-imagen # ejecuta la imagen en un contenedor con un nombre específico
docker logs nombre-del-contenedor # muestra la salida de un contenedor sin ejecutarlo
docker rm nombre-del-contenedor # también sirve el id del contenedor
docker ps -aq # muestra los ids de los contenedores que se están ejecutando
docker rm $(docker ps -aq) # detiene las ejecuciones de todos los contenedores que se están ejecutando


docker run -it ubuntu ejecuta un contenedor con ubuntu de forma interactiva con la terminal
docker run --name some-drupal -p 8080:80 -d drupal    # jecuta un contenedor con un drupal funcional enviando el puerto 80 del contenedor al puerto 8080 de mi local
docker commit 8d0ac009370b drupal/wspublish:day1  # guarda la imagen 8d0ac009370b en el repositorio drupal/wspublish con la versión day1
docker images # muestra las imágenes que tenemos de Docker
docker run ubuntu tail -f /dev/null # ejecuta un contenedor ubuntu, pero le indica un comando a ejecutar en lugar del predeterminado
            # tail -f es un tail, pero quedándose esperando por nuevo contenido en el fichero
docker exec -it nombre_contenedor bash # ebre una terminal de bash en un contenedor que ya está corriendo
ps -fea # muestra todos los procesos, no sólo los de nuestra sesión
docker exec nombre_contenedor kill 1 # termina el proceso con el pid 1, que siempre es aquel con el que se ejecuta un contenedor.
                                     # al terminar dicho proceso, se detiene la ejecución del contenedor y queda parado.
docker run -d --name nombre_nuevo_contenedor nombreImagen # ejecuta en segundo plano un contenedor talternativa --detach
docker run --name mi_mongo -d -v /ruta/en/mi/local:/data/db_mongo # ejecuta un contenedor de mongo DB que guarda los datos en la máquina local
docker volume ls # lista los volúmenes de Docker
docker volume prun # elimina los volúmenes de docker
docker volume create nombreDelVolumen # crea un nuevo volumen de Docker
docker run -d --name mi_mongo --mount src=nombreDelVolumen,dst=/data/db_mongo # ejecuta el contenedor mi_mongo montando un volumen para guardar los datos en local
docker pull redis # descarga la última imagen de redis
docker image ls # muestra las imágenes que tenemos de Docker


touch Dockerfile
#############################################
# imagen de docker en un fichero Dockerfile #
#############################################
FROM ubuntu                     # crea la imagen a partir de una imagen de ubuntu
RUN touch /usr/src/mifichero    # modifica la imagen añadiendo mifichero
####################

# para utilizar la imagen nueva:
docker build -t ubuntu:mi_ubuntu . # crea una imagen de ubuntu, modificada, con el tag mi_ubuntu. El segundo argumento es la ruta a la carpeta en la que se encuentra el Dockerfile
docker run ubuntu:mi_ubuntu # ejecuta un contenedor de mi_ubuntu, un ubuntu modificado
docker tag ubuntu:mi_ubuntu mi_usuario/ubuntu:mi_ubuntu # hacemos un tag en nuestro repositorio de docker
docker push mi_usuario/ubuntu:mi_ubuntu # envía la imagen a nuestro repositorio de docker
docker history ubuntu:mi_ubuntu # muestra las capas que tiene una imagen y cuándo se han añadido dichas capas
docker history --no-trunc ubuntu:mi_ubuntu # en más detalle

# dive es una herramienta de análisis de capas de imágenes de ubuntu

# imagen para ejecutar un proyecto en node:
FROM node:10
COPY[".","/usr/src/"]
WORKDIR  /usr/src
RUN npm install
EXPOSE 3000
CMD ["node","index.js"]

docker network create --attachable mi_red # crea una red. Con el modificador --attachable permite que cualquier contenedor utilice esta red
docker network ls # muestra un listado de las redes de docker
    # dirver bridge por defeco para redes locales
    # driver host no debería utilizarse, conecta con nuestra máquina local
    # driver null no funciona, lo que envíes por ahí, no llegará a ninguna parte
docker network connect mi_red mi_contenedor # conecta un contenedor a una red
docker network inspect mi_red # muestra un JSON de la red, en cuya propiedad "Containers" podemos ver qué contenedores están conectados y con qué IP, MAC...
docker run -d --name mi_contenedor -p 3000:3000 --env MONGO_URL=mongodb://db:27017/test mi_imagen # con esto ejecutamos la imagen en un contenedor poniendo como variable de entorno
                                                                                                  # MONGO_URL la URL, puerto y endpoint de nuestra BBDD en otro contenedor de mongo


docker run -d --name mi_app -p 3000:3000 -env MONGO_URL=mongodb://my_db:27017/test

docker network rm mi_red # elimina una red

##################
# docker compose #
##################
# se crea el siguiente archivo docker-compose.yml

version: "3"

services:
  app:
    image: mi_imagen
    environment:
      MONGO_URL: "mongodb://mi_db:27017/test"
    depends_on:
      - mi_db
    ports:
      - "3000:3000"
  mi_db:
    image: mongo

# y para lanzar esta aplicación contenida en el fichero docker-compose.yml
docker-compose up
docker-compose down
docker-compose ps
docker-compose exec app bash # lanza una terminal de bash en la máquina llamada app
docker-compose logs -f nombre-del-contenedor # muestra el log de un contenedor en tiempo real

docker-compose scale app=4 # intenta escalar a cuatro contenedores el servicio de "app", pero fallará porque todos intentan usar el mismo puerto
    # para evitar este error hay que poner un rango de puertos, en lugar de un solo puerto
    ports:
      - "3000-3010:3000"










.

```
     Docker is a platform that allows us to run applications in isolated containers using the host machine’s CPU, memory, and OS kernel, which helps eliminate the “it works on my machine” problem by providing consistent runtime environments.

```


### docker run  -it --name "name which we want to call our container" "actual name of the image"

- Here our local terminal get connected to the main process of the container
- it will start the container and attaches tty 
```

      docker run -it ubuntu
          └── bash (PID 1)
              └── exit → container stops
 ```


### docker exec -it docker_container_name '/bin/bash or other shells '

- Now we can run any other process inside our already running containers
```
   docker exec -it backend sh
        └── sh (PID 23)
             └── exit → container still running

```

### providing memory and cpus to the container

 * Docker:
    - Uses host CPU
    - Uses host RAM
    - Uses host disk

* But:
     - Containers are limited & isolated
     - Controlled by:
     - cgroups (CPU/RAM)
     - namespaces (process, network, filesystem)


```
     docker run -d --memory=512m --cpus=1 "image_name"

```

### On MAC 
- Docker run on Linux vm on MAC
```
MacOS
  └── Docker Desktop
        └── Linux VM
              └── Containers
```
### So technically:
   - Containers run inside a Linux VM
   - Still share the Linux kernel
   - Ports are forwarded:





### docker run  -it --name "name which we want to call our container" "actual name of the image"

- Here our local terminal get connected to the main process of the container
- it will start the container and attaches tty 
```

      docker run -it ubuntu
          └── bash (PID 1)
              └── exit → container stops
 ```
 
### docker exec -it dcoker_container_name '/bin/bash or other shells '

- Now we can run any other process inside our already running containers
```
   docker exec -it backend sh
        └── sh (PID 23)
             └── exit → container still running

```



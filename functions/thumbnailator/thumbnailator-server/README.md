# Thumbnailator HTTP Server

## Build
You can build the whole project running just a maven command as below:

```bash
mvn clean install
```

## Run
After running maven and build the project you can run the server running the jar file. Some environment variables definition are required.  See an example as follow.

```bash
rotate=0 output_quality=1 scale=0.1 image_url=https://i.imgur.com/BhlDUOR.jpg java -jar target/server-0.0.1-SNAPSHOT.jar
```

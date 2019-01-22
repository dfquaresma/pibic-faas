# Business HTTP Server

## Build
You can build the whole project running just a maven command as below:

```bash
mvn clean install
```

## Run
After running maven and build the project you can run the server running the jar file. Some environment variables definition are required.  See an example as follow.

```bash
to_power_of=21 java -Xms128m -Xmx128m -XX:+UseG1GC -jar target/listfiller-server-0.0.1-SNAPSHOT.jar
```

#Stage 1 : Build with Maven
FROM maven:3.9.6-eclipse-temurin-17 AS Build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

#Stage 2 : Runtime
FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=build /app/target/maven-hello-app-1.0-SNAPSHOT-jar-with-dependencies.jar app.jar

EXPOSE 8080
ENTRYPOINT [ "java","-jar","app.jar" ]

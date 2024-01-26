# Use the official Maven image to build the application
FROM gradle:8.5-jdk17 AS build
WORKDIR /app
COPY . /app
ARG DB_URL
ENV DB_URL=$DB_URL
ARG DB_NAME
ENV DB_NAME=$DB_NAME
ARG DB_PASSWORD
ENV DB_PASSWORD=$DB_PASSWORD

# Change permissions for gradlew
RUN chmod +x ./gradlew

# Run the Gradle build
RUN ./gradlew clean build -x test

# Use the official OpenJDK 17 base image
FROM openjdk:17

# Set the working directory inside the container
WORKDIR /app

# Copy the JAR file from the build stage
COPY --from=build /app/build/libs/*.jar /app/template.jar

EXPOSE 8080

# Command to run your application
CMD ["java", "-jar", "/app/template.jar"]
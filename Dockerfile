# Build stage
FROM ubuntu:latest AS build

# Install required packages
RUN apt-get update && apt-get install -y openjdk-17-jdk

# Set the working directory
WORKDIR /app

# Copy your project files into the container
COPY . .

# Make the gradlew script executable
RUN chmod +x gradlew

# Build the JAR file
RUN ./gradlew bootJar --no-daemon

# Final stage
FROM openjdk:17-jdk-slim

# Expose the port your application will run on
EXPOSE 8080

# Create a directory for your application
WORKDIR /app

# Copy the JAR file from the build stage to the final image
COPY --from=build /app/build/libs/secureData-1.jar app.jar

# Define the entry point for running your application
ENTRYPOINT ["java", "-jar", "app.jar"]
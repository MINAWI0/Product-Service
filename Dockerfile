# Builder stage
FROM bellsoft/liberica-runtime-container:jdk-21-stream-musl as builder
WORKDIR /app
ADD . /app
WORKDIR /app
RUN chmod +x mvnw
RUN ./mvnw clean package -Dmaven.test.skip=true

# Runtime stage
FROM bellsoft/liberica-runtime-container:jre-21-musl
WORKDIR /app

# Expose the necessary port
EXPOSE 8084

# Copy the built JAR file from the builder stage
COPY --from=builder /app/target/*.jar course-registration.jar

# Run the application
ENTRYPOINT ["java", "-jar", "course-registration.jar"]

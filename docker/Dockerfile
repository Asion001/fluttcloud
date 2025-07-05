# Build stage
FROM dart:3.8 AS build
WORKDIR /app
COPY fluttcloud_server .

# Install dependencies and compile the server executable
RUN dart pub get
RUN dart compile exe bin/main.dart -o bin/server


# Final stage
FROM alpine:latest
WORKDIR /app

# Copy app files
COPY fluttcloud_flutter/build/web/ web/app/

# Copy runtime dependencies
COPY --from=build /runtime/ /

# Copy compiled server executable
COPY --from=build /app/bin/server server

# Copy configuration files and resources
COPY --from=build /app/config/ config/
COPY --from=build /app/migrations/ migrations/

# This file is required to enable the endpoint log filter in Insights.
COPY --from=build /app/lib/src/generated/protocol.yaml lib/src/generated/protocol.yaml


# Expose ports
EXPOSE 8080
EXPOSE 8081
EXPOSE 8082

# Define the entrypoint command
ENTRYPOINT ["./server", "--apply-migrations", "--mode", "production"]

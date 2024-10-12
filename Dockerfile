# Use the PostGIS image with PostgreSQL 16 and PostGIS 3.4
FROM postgis/postgis:16-3.4

# Install build dependencies
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    git \
    postgresql-server-dev-16

# Install pgvector (latest version as of 2023-10)
RUN git clone --branch v0.7.4 https://github.com/pgvector/pgvector.git && \
    cd pgvector && \
    make && \
    make install && \
    cd .. && rm -rf pgvector

# Clean up to reduce image size
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy the initialization script
COPY init_extensions.sql /docker-entrypoint-initdb.d/

# Expose PostgreSQL port
EXPOSE 5432

# Set environment variables (optional)
ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=postgres

# Set the default command
CMD ["postgres", "-c", "wal_level=logical"]
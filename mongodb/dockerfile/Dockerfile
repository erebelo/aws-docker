# Build mongodb
FROM mongo:5

# Specify the volume for data/db
VOLUME /data/db

# Specify the command to run MongoDB with replica set configuration
CMD ["mongod", "--replSet", "rs0", "--bind_ip", "localhost,mongo1"]
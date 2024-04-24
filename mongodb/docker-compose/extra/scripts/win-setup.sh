#!/bin/bash

# Source environment variables
source .env

echo "Initializing replica set 'rs0' for '$CONTAINER_1_NAME' container..."
winpty docker exec -it $CONTAINER_1_NAME mongosh --eval "
rs.initiate({
  _id: 'rs0',
  members: [
	{ _id: 0, host: '$CONTAINER_1_NAME' },
	{ _id: 1, host: '$CONTAINER_2_NAME' },
	{ _id: 2, host: '$CONTAINER_3_NAME' }
  ]
});"

winpty docker exec -it $CONTAINER_1_NAME mongosh --eval 'rs.status();'

sleep 1

echo
echo "Creating '$ADMIN_USER' user for '$ADMIN_DB_NAME' database..."
winpty docker exec -it $CONTAINER_1_NAME mongosh --eval "
db.getSiblingDB('$ADMIN_DB_NAME').createUser({
  user: '$ADMIN_USER',
  pwd: '$ADMIN_PWD',
  roles: [{ role: 'userAdminAnyDatabase', db: '$ADMIN_DB_NAME' }]
});"

echo
echo "Logging in with '$ADMIN_USER' user..."
echo "Creating '$ROOT_USER' user for '$ADMIN_DB_NAME' database..."
winpty docker exec -it $CONTAINER_1_NAME mongosh --eval "
db.getSiblingDB('$ADMIN_DB_NAME').auth('$ADMIN_USER', '$ADMIN_PWD');
db.getSiblingDB('$ADMIN_DB_NAME').createUser({
  user: '$ROOT_USER',
  pwd: '$ROOT_PWD',
  roles: [{ role: 'root', db: '$ADMIN_DB_NAME' }]
});"

echo
echo "Logging in with '$ADMIN_USER' user..."
echo "Creating '$REGULAR_USER' user for '$DEMO_DB_NAME' database..."
winpty docker exec -it $CONTAINER_1_NAME mongosh --eval "
db.getSiblingDB('$ADMIN_DB_NAME').auth('$ADMIN_USER', '$ADMIN_PWD');
db.getSiblingDB('$DEMO_DB_NAME').createUser({
  user: '$REGULAR_USER',
  pwd: '$REGULAR_PWD',
  roles: [{ role: 'readWrite', db: '$DEMO_DB_NAME' }]
});"

echo
echo "Logging in with '$REGULAR_USER' user..."
echo "Creating '$PROFILE_COLLECTION' and '$PROFILE_HISTORY_COLLECTION' collections for '$DEMO_DB_NAME' database..."
winpty docker exec -it $CONTAINER_1_NAME mongosh --eval "
db.getSiblingDB('$DEMO_DB_NAME').auth('$REGULAR_USER', '$REGULAR_PWD');
db.getSiblingDB('$DEMO_DB_NAME').createCollection('$PROFILE_COLLECTION');
db.getSiblingDB('$DEMO_DB_NAME').createCollection('$PROFILE_HISTORY_COLLECTION');"
# Clear the terminal screen for better visibility of the output
clear

# Stop and remove all containers, networks, and volumes defined in the docker-compose.yml file
docker-compose down

# Build or rebuild the services defined in the docker-compose.yml file
docker-compose build

# Start the services defined in the docker-compose.yml file
docker-compose up

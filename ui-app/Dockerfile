# Use a lightweight Node.js base image for serving the application
FROM node:20.13.1-alpine as build

# Set the working directory inside the container
WORKDIR /app

# Copy only the package.json and package-lock.json files to leverage Docker's layer caching mechanism
COPY package*.json ./

# Install project dependencies
RUN npm install --production

# Copy the rest of the application code to the working directory
COPY . .

# Build the React application
RUN npm run build

# Use a lightweight Node.js base image for serving the application
FROM node:20.13.1-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy only the built files from the previous stage
COPY --from=build /app/build /app/build

# Command to start the server and serve the built React application
CMD ["npx", "serve", "-s", "build"]
# Use the official Node.js 14 image as the base image
FROM node:18

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install the dependencies
RUN npm install

# Copy the rest of the application code to the working directory
COPY . .

# Expose the port that your Node.js application will be listening on
EXPOSE 6983 5900

# Specify the command to run your application
CMD [ "npm", "start" ]
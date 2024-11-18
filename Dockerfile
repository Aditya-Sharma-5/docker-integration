# Step 1: Build Stage
FROM node:18-slim AS build

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json first to install dependencies
COPY package*.json ./

# Install dependencies
RUN npm install --frozen-lockfile

# Copy the application code
COPY . .

# Step 2: Production Stage
FROM node:18-alpine AS production

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json from the build stage
COPY --from=build /app/package*.json ./

# Install production dependencies
RUN npm install --production --frozen-lockfile

# Copy the application code from the build stage
COPY --from=build /app .

# Expose the port the app runs on
EXPOSE 3000

# Command to run the app
CMD ["node", "app.js"]

#Multiple stage build
# ---- Stage 1: Build ----
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

# ---- Stage 2: Production ----
FROM node:18-alpine AS production
WORKDIR /app
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/testingapp.js .
EXPOSE 3000
CMD ["node", "testingapp.js"]

#Multiple branch build
# Use official Node.js image
#FROM node:18-alpine

# Set working directory
#WORKDIR /app

# Copy package files
#COPY package*.json ./

# Install dependencies
#RUN npm install

# Copy app source
#COPY . .

# Expose port
#EXPOSE 3000

# Start the app
#CMD ["node", "testingapp.js"]

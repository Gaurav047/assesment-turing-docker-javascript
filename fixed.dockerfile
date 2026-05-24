# Dockerfile for the Mongoose library project
# Uses a Node 20 base image and installs dependencies from package.json.
# This image is useful for building, testing, or running scripts against the repository.

FROM node:20-alpine AS builder
WORKDIR /usr/src/app

# Install project dependencies first to leverage build cache.
COPY package.json ./
COPY package-lock.json ./
RUN npm install

# Copy repository files and build the browser bundle.
COPY . ./
RUN npm run build-browser

# Final image contains the built project and runtime dependencies.
FROM node:20-alpine AS runtime
WORKDIR /usr/src/app
COPY --from=builder /usr/src/app .

# Use the built browser assets and runtime dependencies.
ENV NODE_ENV=production

CMD ["node", "-e", "console.log('Mongoose container ready. Run your own command or use this image as a base.')"]

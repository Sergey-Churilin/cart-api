# Base
FROM node:12 as base
WORKDIR /app

# Dependencies
FROM base as dependencies
COPY package*.json ./
RUN npm install

# Build
FROM dependencies as build
WORKDIR /app
COPY . .
RUN npm run build

FROM node:12-alpine AS release

COPY --from=dependencies /app/package*.json ./
RUN npm install --only=production
COPY --from=build /app/dist ./dist

# Application
USER node
ENV PORT=8080
EXPOSE 8080

CMD ["node", "dist/main.js"]
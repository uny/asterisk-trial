FROM node:22-slim AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY ./src ./src
COPY ./tsconfig.json ./
RUN npm run build

FROM node:22-slim AS runtime
WORKDIR /app
COPY --from=build /app/dist ./dist
CMD ["node", "dist/index.js"]

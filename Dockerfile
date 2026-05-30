FROM node:20-alpine AS compiler
WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

RUN npm run build

FROM node:20-alpine AS runtime
WORKDIR /app

ENV NODE_env=production
ENV HOST=0.0.0.0
ENV PORT=3000

COPY --from=compiler /app/.output ./.output

EXPOSE 3000

CMD ["node", ".output/server/index.mjs"]
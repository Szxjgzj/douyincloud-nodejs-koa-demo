# 第一阶段：编译 TypeScript
FROM node:18 AS builder

WORKDIR /app

COPY package*.json ./
RUN npm ci --only=production
COPY src/ ./src/
COPY tsconfig.json ./

RUN npm run build

# 第二阶段：生产镜像
FROM node:18-alpine
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
EXPOSE 3000
CMD ["node", "dist/index.js"] 
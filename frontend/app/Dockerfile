FROM node:18-alpine

# Install bash
RUN apk add --no-cache bash zip

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 3000

CMD ["npm", "start"]

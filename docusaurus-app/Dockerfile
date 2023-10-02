FROM node:18.18.0-slim as builder

# Reduce npm log spam and colour during install within Docker
ENV NPM_CONFIG_LOGLEVEL=warn
ENV NPM_CONFIG_COLOR=false

RUN npx create-docusaurus@latest app classic

WORKDIR /app

#RUN sed -i 's/docusaurus start/docusaurus start --host 0.0.0.0/' package.json && sed -i 's/docusaurus serve/docusaurus serve --host 0.0.0.0/' package.json
RUN npm run build

FROM nginx:stable-alpine
COPY --from=builder /app/build /usr/share/nginx/html/



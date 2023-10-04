FROM node:18.18.0-slim as builder

RUN npx create-docusaurus@latest app classic

WORKDIR /app

#RUN sed -i 's/docusaurus start/docusaurus start --host 0.0.0.0/' package.json && sed -i 's/docusaurus serve/docusaurus serve --host 0.0.0.0/' package.json
RUN npm run build

FROM nginx:stable-alpine
COPY --from=builder /app/build /usr/share/nginx/html/



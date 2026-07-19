FROM denoland/deno:latest AS build

LABEL authors="Thomas Philippot"

ARG PORT=3000

WORKDIR /app

COPY package.json deno.json deno.lock ./

RUN deno install

COPY . ./

RUN deno run build

FROM denoland/deno:latest AS prod

WORKDIR /app

ENV HOST=0.0.0.0
ENV PORT=$PORT
ENV NODE_ENV=production

COPY --from=build /app/.output ./.output

EXPOSE 3000

CMD ["deno", "run", "--env", "--allow-env", "--allow-net", "--allow-read", ".output/server/index.mjs"]

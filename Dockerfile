FROM denoland/deno:2.9.3 AS build

LABEL authors="Thomas Philippot"

ARG PORT=3000

WORKDIR /app

COPY package.json deno.json deno.lock ./

RUN deno install

COPY . ./

RUN deno run build

FROM denoland/deno:alpine-2.9.3 AS prod

USER deno

WORKDIR /app

ENV HOST=0.0.0.0
ENV NODE_ENV=production

COPY --from=build --chown=deno:deno /app/.output ./.output

HEALTHCHECK --interval=10s --timeout=10s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://0.0.0.0:3000 || exit 1

EXPOSE 3000

CMD ["deno", "run", "--env", "--allow-env", "--allow-net", "--allow-read",".output/server/index.mjs"]

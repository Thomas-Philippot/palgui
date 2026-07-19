export default defineEventHandler(async (event) => {
  const data = await readBody(event);
  if (!event.context.params) {
    throw createError({
      statusCode: 400,
      statusMessage: "missing url parameter",
    });
  }

  const path = `/${event.context.params._}`;
  const config = useRuntimeConfig(event);

  return await palClient(config, path, { method: "POST", body: data });
});

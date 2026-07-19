export const palClient = async <T>(
  config: any,
  endpoint: string,
  options = {},
) => {
  // Basic Auth encoding using Buffer (Node.js/Nitro compatible)
  const auth = Buffer.from(`${config.palApiUser}:${config.palApiPass}`)
    .toString("base64");

  try {
    return await $fetch<T>(`${config.palApiUrl}/v1/api${endpoint}`, {
      ...options,
      headers: {
        ...options.headers,
        "Authorization": `Basic ${auth}`,
        "Accept": "application/json",
      },
    });
  } catch (error) {
    console.error(
      `[PalClient] Error calling ${endpoint}:`,
      error.data || error.message,
    );
    throw createError({
      statusCode: error.response?.status || 500,
      statusMessage: `Palworld API Error (${config.palApiUrl}): ${
        error.data?.message || error.message
      }`,
    });
  }
};

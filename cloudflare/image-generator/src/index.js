/**
 * Turkishly vocabulary image batch worker.
 *
 * Required bindings:
 * - AI: Cloudflare Workers AI binding
 * - IMAGES: R2 bucket binding
 * - ADMIN_TOKEN: secret configured with wrangler secret put ADMIN_TOKEN
 *
 * This worker creates one independent image per vocabulary item.
 * It does not update the app's vocabulary database; approval and catalog
 * integration are a separate step.
 */

const MODEL = "@cf/black-forest-labs/flux-1-schnell";
const MAX_BATCH_SIZE = 10;
const ID_PATTERN = /^[A-Za-z0-9_-]{3,80}$/;
const CATEGORY_PATTERN = /^[a-z0-9_-]{2,40}$/;

function json(data, status = 200) {
  return new Response(JSON.stringify(data, null, 2), {
    status,
    headers: { "content-type": "application/json; charset=utf-8" }
  });
}

function authorized(request, env) {
  const expected = env.ADMIN_TOKEN;
  if (!expected) return false;
  return request.headers.get("authorization") === `Bearer ${expected}`;
}

function buildPrompt(item) {
  const subject = String(item.subject || "").trim();
  const scene = String(item.scene || "on a clean, simple neutral background").trim();
  return [
    "Photorealistic educational vocabulary photograph.",
    `Main subject: ${subject}.`,
    `Scene: ${scene}.`,
    "One clear concept, centered composition, natural soft daylight, realistic colors and details.",
    "Square image.",
    "No text, no letters, no numbers, no captions, no labels, no logo, no watermark."
  ].join(" ");
}

function validateItem(item) {
  if (!item || typeof item !== "object") return "Each item must be an object.";
  if (typeof item.vocabularyId !== "string" || !ID_PATTERN.test(item.vocabularyId)) {
    return "Invalid vocabularyId.";
  }
  if (typeof item.category !== "string" || !CATEGORY_PATTERN.test(item.category)) {
    return "Invalid category.";
  }
  if (typeof item.subject !== "string" || item.subject.trim().length < 2 || item.subject.length > 240) {
    return "subject must contain 2–240 characters.";
  }
  if (item.scene !== undefined && (typeof item.scene !== "string" || item.scene.length > 400)) {
    return "scene must be a string up to 400 characters.";
  }
  return null;
}

async function generateOne(item, env) {
  const key = `images/vocabulary/${item.category}/${item.vocabularyId}.jpg`;

  // Idempotency: do not silently replace an existing object.
  const existing = await env.IMAGES.head(key);
  if (existing) {
    return { vocabularyId: item.vocabularyId, status: "exists", objectKey: key };
  }

  const result = await env.AI.run(MODEL, { prompt: buildPrompt(item) });
  if (!result) throw new Error("The image model returned an empty result.");

  await env.IMAGES.put(key, result, {
    httpMetadata: { contentType: "image/jpeg", cacheControl: "public, max-age=31536000, immutable" },
    customMetadata: {
      vocabularyId: item.vocabularyId,
      category: item.category,
      model: MODEL,
      promptVersion: "1",
      reviewStatus: "pending"
    }
  });

  const saved = await env.IMAGES.head(key);
  if (!saved) throw new Error("Image upload verification failed.");

  return {
    vocabularyId: item.vocabularyId,
    status: "generated_pending_review",
    objectKey: key,
    sizeBytes: saved.size,
    etag: saved.etag
  };
}

export default {
  async fetch(request, env) {
    const url = new URL(request.url);

    if (request.method === "GET" && url.pathname === "/health") {
      return json({ ok: true, service: "turkishly-image-worker", generationEnabled: Boolean(env.AI && env.IMAGES) });
    }

    if (url.pathname !== "/admin/image-batches" || request.method !== "POST") {
      return json({ error: "Not found" }, 404, cors);
    }

    if (!authorized(request, env)) return json({ error: "Unauthorized" }, 401, cors);
    if (!env.AI || !env.IMAGES) return json({ error: "AI and R2 bindings are required." }, 503, cors);

    let body;
    try {
      body = await request.json();
    } catch {
      return json({ error: "Request body must be valid JSON." }, 400, cors);
    }

    if (!body || !Array.isArray(body.items) || body.items.length < 1 || body.items.length > MAX_BATCH_SIZE) {
      return json({ error: `items must contain between 1 and ${MAX_BATCH_SIZE} entries per request.` }, 400, cors);
    }

    const seen = new Set();
    for (const item of body.items) {
      const issue = validateItem(item);
      if (issue) return json({ error: issue }, 400, cors);
      if (seen.has(item.vocabularyId)) return json({ error: "Duplicate vocabularyId in batch." }, 400, cors);
      seen.add(item.vocabularyId);
    }

    const results = [];
    for (const item of body.items) {
      try {
        results.push(await generateOne(item, env));
      } catch (error) {
        results.push({
          vocabularyId: item.vocabularyId,
          status: "failed",
          error: error instanceof Error ? error.message : "Unknown generation error"
        });
      }
    }

    const generated = results.filter(x => x.status === "generated_pending_review").length;
    const exists = results.filter(x => x.status === "exists").length;
    const failed = results.filter(x => x.status === "failed").length;

    return json({
      model: MODEL,
      requested: results.length,
      generated,
      existing: exists,
      failed,
      results
    }, failed === results.length ? 502 : 200, cors);
  }
};

# Turkishly Image Generator (Cloudflare Worker)

Worker scaffold for generating one separate image per Turkish vocabulary concept.

## Status

This is source code only. It is **not deployed** and has no connected Cloudflare account, AI binding, R2 bucket, or secret configured yet.

## Requirements

- Cloudflare account with Workers AI access.
- R2 bucket named `turkishly-vocabulary-images` (or update `wrangler.toml`).
- Wrangler CLI.
- An admin token stored as a Worker secret, never committed to Git.

## Setup

1. Create the R2 bucket in Cloudflare named `turkishly-vocabulary-images`.
2. From this folder, install/use Wrangler and authenticate using your own Cloudflare account.
3. Configure the secret interactively:

   ```bash
   npx wrangler secret put ADMIN_TOKEN
   ```

   Enter a long random value in the secure prompt. Do not paste it into chat or commit it.
4. Deploy:

   ```bash
   npx wrangler deploy
   ```

5. Test `GET /health`. It should report that generation bindings are available.

## Generate a batch

Send an authenticated POST to `/admin/image-batches`:

```json
{
  "items": [
    {
      "vocabularyId": "TR-A1-FRUIT-0001",
      "category": "fruits",
      "subject": "one fresh red apple",
      "scene": "isolated on a clean soft neutral background"
    },
    {
      "vocabularyId": "TR-A1-FRUIT-0002",
      "category": "fruits",
      "subject": "one ripe yellow banana",
      "scene": "isolated on a clean soft neutral background"
    }
  ]
}
```

Header: `Authorization: Bearer YOUR_ADMIN_TOKEN`.

The worker currently accepts up to 10 items per request and processes them sequentially. Each image is stored separately in R2 under `images/vocabulary/{category}/{vocabularyId}.png`. Existing objects are not overwritten.

## Important limitations

- The response records generated objects as pending review; it does not approve them.
- This scaffold does not yet connect to the app's vocabulary database or update image paths.
- Configure a private admin route or strict access controls before production use.
- Add budget guards, durable job persistence, retry scheduling, rate limiting, audit logs, and image moderation before large-scale batches.
- The selected model output is stored as PNG. WebP conversion should be added as a separate, tested optimization step.
- Never put `ADMIN_TOKEN`, Cloudflare API tokens, or R2 credentials in Flutter or GitHub.

#!/usr/bin/env bash
set -euo pipefail

RESPONSE=$(curl -sf --max-time "$TIMEOUT" \
  -X POST "${API_URL}/review-pr" \
  -H "Content-Type: application/json" \
  -H "x-api-secret: ${API_SECRET}" \
  -d "{
    \"repo\": \"${GITHUB_REPOSITORY}\",
    \"pr_number\": ${PR_NUMBER},
    \"github_token\": \"${GITHUB_TOKEN}\"
  }")

REVIEW=$(echo "$RESPONSE" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d['review'])")
DURATION=$(echo "$RESPONSE" | python3 -c "import sys,json; d=json.load(sys.stdin); ms=d.get('duration_ms',0); print(f'{ms/1000:.1f}s')")

{
  echo "review<<REVIEW_EOF"
  echo "$REVIEW"
  echo "REVIEW_EOF"
  echo "duration=$DURATION"
} >> "$GITHUB_OUTPUT"

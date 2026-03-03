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

VERDICT=$(echo "$RESPONSE"  | python3 -c "import sys,json; d=json.load(sys.stdin); print(d['verdict'])")
COMMENTS=$(echo "$RESPONSE" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d['comments_count'])")
DURATION=$(echo "$RESPONSE" | python3 -c "import sys,json; d=json.load(sys.stdin); ms=d.get('duration_ms',0); print(f'{ms/1000:.1f}s')")
CACHED=$(echo "$RESPONSE"   | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('cached', False))")

echo "verdict=$VERDICT"       >> "$GITHUB_OUTPUT"
echo "comments_count=$COMMENTS" >> "$GITHUB_OUTPUT"
echo "duration=$DURATION"     >> "$GITHUB_OUTPUT"
echo "cached=$CACHED"         >> "$GITHUB_OUTPUT"

echo "✅ Review posted: verdict=$VERDICT | inline_comments=$COMMENTS | duration=$DURATION | cached=$CACHED"
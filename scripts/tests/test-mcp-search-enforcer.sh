#!/usr/bin/env bash
# Test: mcp-servers/search-enforcer/server.py responds correctly to the MCP
# stdio protocol and mints valid citation tokens.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
SERVER="$REPO_ROOT/mcp-servers/search-enforcer/server.py"

if [ ! -f "$SERVER" ]; then
  echo "FAIL: server not found at $SERVER"
  exit 1
fi

# Helper: send a JSON-RPC request to the server via stdin, return the response
# for a given request id. Uses python because the response is JSONL.
send_request() {
  local id="$1"
  python3 - "$SERVER" "$id" <<'PYEOF'
import sys, json, subprocess

server, target_id = sys.argv[1], sys.argv[2]
proc = subprocess.Popen(
    ["python3", "-u", server],
    stdin=subprocess.PIPE,
    stdout=subprocess.PIPE,
    stderr=subprocess.PIPE,
    text=True,
)
# Fire all 4 standard requests in one stream.
requests = [
    {"jsonrpc": "2.0", "id": 1, "method": "initialize", "params": {"protocolVersion": "2024-11-05", "capabilities": {}, "clientInfo": {"name": "test", "version": "0"}}},
    {"jsonrpc": "2.0", "id": 2, "method": "tools/list"},
    {"jsonrpc": "2.0", "id": 3, "method": "tools/call", "params": {"name": "verified_search", "arguments": {"query": "test query", "claim": "test claim"}}},
    {"jsonrpc": "2.0", "id": 4, "method": "tools/call", "params": {"name": "verify_token", "arguments": {"token": "vst-deadbeef-cafe1234-12345678"}}},
    {"jsonrpc": "2.0", "id": 5, "method": "tools/call", "params": {"name": "verified_search", "arguments": {"query": ""}}},
]
for r in requests:
    proc.stdin.write(json.dumps(r) + "\n")
proc.stdin.flush()
proc.stdin.close()

for line in proc.stdout:
    line = line.strip()
    if not line:
        continue
    try:
        resp = json.loads(line)
    except json.JSONDecodeError:
        continue
    if str(resp.get("id")) == str(target_id):
        print(json.dumps(resp))
        sys.exit(0)
sys.exit(1)
PYEOF
}

# --- 1. initialize ---
echo "=== test 1: initialize ==="
init_resp="$(send_request 1)"
echo "$init_resp" | python3 -c "import json,sys; d=json.loads(sys.stdin.read()); assert d['result']['serverInfo']['name']=='search-enforcer', d; print('  OK')"

# --- 2. tools/list ---
echo "=== test 2: tools/list ==="
list_resp="$(send_request 2)"
echo "$list_resp" | python3 -c "
import json, sys
d = json.loads(sys.stdin.read())
tools = [t['name'] for t in d['result']['tools']]
assert 'verified_search' in tools, f'missing verified_search in {tools}'
assert 'verify_token' in tools, f'missing verify_token in {tools}'
print('  OK (both tools present)')
"

# --- 3. verified_search mints a valid token ---
echo "=== test 3: verified_search ==="
search_resp="$(send_request 3)"
echo "$search_resp" | python3 -c "
import json, sys, re
d = json.loads(sys.stdin.read())
text = d['result']['content'][0]['text']
m = re.search(r'\[(vst-[0-9a-f]+-[0-9a-f]+-[0-9a-f]+)\]', text)
assert m, f'no token in response: {text[:200]}'
token = m.group(1)
parts = token[4:].split('-')
assert len(parts) == 3, f'bad token shape: {token}'
int(parts[0], 16); int(parts[1], 16); int(parts[2], 16)
print(f'  OK (token: {token})')
"

# --- 4. verify_token accepts a well-formed token ---
echo "=== test 4: verify_token (valid shape) ==="
verify_resp="$(send_request 4)"
echo "$verify_resp" | python3 -c "
import json, sys
d = json.loads(sys.stdin.read())
text = d['result']['content'][0]['text']
assert 'VALID' in text and 'vst-deadbeef' in text, f'unexpected: {text}'
print('  OK (token accepted)')
"

# --- 5. missing 'claim' arg returns proper error ---
echo "=== test 5: missing required arg ==="
err_resp="$(send_request 5)"
echo "$err_resp" | python3 -c "
import json, sys
d = json.loads(sys.stdin.read())
assert 'error' in d, f'expected error, got: {d}'
assert d['error']['code'] == -32602, f'wrong error code: {d}'
print('  OK (proper JSON-RPC error)')
"

echo ""
echo "PASS: search-enforcer MCP server"

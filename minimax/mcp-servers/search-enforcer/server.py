#!/usr/bin/env python3
"""
search-enforcer MCP server (superpowers-max)
============================================

A stdio MCP server that mints citation tokens. Models operating under the
superpowers-max search-discipline regime MUST call `verified_search` before
stating any fact, decision, or self-confident assertion. The tool returns a
unique token `[vst-{timestamp}-{nonce}-{query-hash}]` that the model must
include verbatim in its response.

The token is the audit anchor: scripts/audit-tokens.sh (and eval cases) can
verify that a response includes a valid token, proving the model at least
attempted to call the tool. This is L2.5 — stronger than a prompt, weaker
than a hook.

Token format
------------
    vst-{hex(timestamp)}-{hex(nonce)}-{hex(sha256(query)[:8])}

Example:
    vst-19a8f3c2-7b4e2f1a-9d3c1a8f

Components:
  - `vst-`              : magic prefix
  - hex(timestamp)      : UTC unix timestamp in hex
  - hex(nonce)          : 8 bytes from secrets.token_hex(8) (16 hex chars)
  - hex(sha256[:8])     : first 8 hex chars of sha256(query) for traceability

Usage (in MCP client)
---------------------
    tool_call("verified_search", {
        "query": "Python 3.13 GIL removal 2026",
        "claim": "Python 3.13 still has the GIL in default build"
    })
    → response includes text with the token
    → model must include the same token next to the cited fact

Compatibility
-------------
Implements MCP protocol version 2024-11-05. stdio transport only.
No external dependencies (stdlib only).

Run
---
    python3 -u ./mcp-servers/search-enforcer/server.py
"""

import sys
import json
import secrets
import hashlib
from datetime import datetime, timezone


PROTOCOL_VERSION = "2024-11-05"
SERVER_NAME = "search-enforcer"
SERVER_VERSION = "1.0.0"
TOKEN_PREFIX = "vst-"


def mint_token(query: str) -> str:
    """Mint a fresh citation token for a query."""
    ts = int(datetime.now(timezone.utc).timestamp())
    nonce = secrets.token_hex(8)
    digest = hashlib.sha256(query.encode()).hexdigest()[:8]
    return f"{TOKEN_PREFIX}{ts:x}-{nonce}-{digest}"


def is_valid_token(token: str) -> bool:
    """Check token shape (not cryptographic validity)."""
    if not token.startswith(TOKEN_PREFIX):
        return False
    parts = token[len(TOKEN_PREFIX):].split("-")
    if len(parts) != 3:
        return False
    ts_hex, nonce_hex, digest_hex = parts
    try:
        int(ts_hex, 16)
        int(nonce_hex, 16)
        int(digest_hex, 16)
        return True
    except ValueError:
        return False


def send(msg: dict) -> None:
    """Write one JSON-RPC message to stdout, flushed immediately."""
    sys.stdout.write(json.dumps(msg) + "\n")
    sys.stdout.flush()


def handle(req: dict) -> None:
    """Handle a single JSON-RPC request, write the response (or nothing for
    notifications)."""
    method = req.get("method")
    req_id = req.get("id")
    is_notification = "id" not in req

    # Notifications (no id) → no response
    if is_notification and method == "notifications/initialized":
        return

    if method == "initialize":
        send({
            "jsonrpc": "2.0",
            "id": req_id,
            "result": {
                "protocolVersion": PROTOCOL_VERSION,
                "serverInfo": {"name": SERVER_NAME, "version": SERVER_VERSION},
                "capabilities": {"tools": {}},
            },
        })
        return

    if method == "tools/list":
        send({
            "jsonrpc": "2.0",
            "id": req_id,
            "result": {
                "tools": [
                    {
                        "name": "verified_search",
                        "description": (
                            "Mint a citation token. You MUST call this BEFORE stating any "
                            "fact, decision, or self-confident assertion (per the superpowers-max "
                            "MANDATORY_PREAMBLE). The returned token must appear VERBATIM, in "
                            "square brackets, next to the cited claim. Do not paraphrase, strip, "
                            "or wrap the token in other formatting — the audit script greps for "
                            "the exact pattern."
                        ),
                        "inputSchema": {
                            "type": "object",
                            "properties": {
                                "query": {
                                    "type": "string",
                                    "description": (
                                        "The web search query you would run (or did run via "
                                        "web_search / web_fetch) to verify the claim. Becomes "
                                        "part of the token's traceability."
                                    ),
                                },
                                "claim": {
                                    "type": "string",
                                    "description": (
                                        "The exact claim you are about to make. Recorded in the "
                                        "tool response so you can confirm you cited the right thing."
                                    ),
                                },
                            },
                            "required": ["query", "claim"],
                        },
                    },
                    {
                        "name": "verify_token",
                        "description": (
                            "Check whether a token has the right shape (not cryptographic "
                            "validity). Useful for self-checking before submitting a response."
                        ),
                        "inputSchema": {
                            "type": "object",
                            "properties": {
                                "token": {"type": "string", "description": "The token to verify."}
                            },
                            "required": ["token"],
                        },
                    },
                ],
            },
        })
        return

    if method == "tools/call":
        params = req.get("params", {}) or {}
        name = params.get("name")
        args = params.get("arguments", {}) or {}

        if name == "verified_search":
            query = args.get("query", "")
            claim = args.get("claim", "")
            if not query or not claim:
                send({
                    "jsonrpc": "2.0",
                    "id": req_id,
                    "error": {
                        "code": -32602,
                        "message": "Both 'query' and 'claim' are required.",
                    },
                })
                return
            token = mint_token(query)
            ts_iso = datetime.now(timezone.utc).isoformat()
            text = (
                f"Citation token: [{token}]\n"
                f"Issued for query: {query}\n"
                f"Verifying claim: {claim}\n"
                f"Timestamp (UTC): {ts_iso}\n\n"
                f"REMINDER (per MANDATORY_PREAMBLE): You MUST include `[{token}]` verbatim, "
                f"in square brackets, next to the cited fact in your response. The audit "
                f"script greps for tokens of the form `vst-<hex>-<hex>-<hex>`. Any token "
                f"in your final response counts as a citation for the closest preceding claim."
            )
            send({
                "jsonrpc": "2.0",
                "id": req_id,
                "result": {
                    "content": [{"type": "text", "text": text}],
                    "isError": False,
                },
            })
            return

        if name == "verify_token":
            token = args.get("token", "")
            valid = is_valid_token(token)
            send({
                "jsonrpc": "2.0",
                "id": req_id,
                "result": {
                    "content": [{
                        "type": "text",
                        "text": f"Token {'VALID' if valid else 'INVALID'}: {token}",
                    }],
                    "isError": False,
                },
            })
            return

        send({
            "jsonrpc": "2.0",
            "id": req_id,
            "error": {"code": -32601, "message": f"Unknown tool: {name}"},
        })
        return

    # Unknown method
    if not is_notification:
        send({
            "jsonrpc": "2.0",
            "id": req_id,
            "error": {"code": -32601, "message": f"Method not found: {method}"},
        })


def main():
    """Read line-delimited JSON-RPC from stdin, dispatch each request."""
    for line in sys.stdin:
        line = line.strip()
        if not line:
            continue
        try:
            req = json.loads(line)
        except json.JSONDecodeError as e:
            send({
                "jsonrpc": "2.0",
                "id": None,
                "error": {"code": -32700, "message": f"Parse error: {e}"},
            })
            continue
        try:
            handle(req)
        except Exception as e:  # noqa: BLE001
            req_id = req.get("id") if isinstance(req, dict) else None
            send({
                "jsonrpc": "2.0",
                "id": req_id,
                "error": {"code": -32603, "message": f"Internal error: {e}"},
            })


if __name__ == "__main__":
    main()

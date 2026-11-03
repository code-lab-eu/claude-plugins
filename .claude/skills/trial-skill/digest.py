"""Print a readable digest of a Claude Code session transcript.

Usage: python3 -I digest.py <transcript.jsonl>

Lists the developer's messages, including those sent mid-turn, the
assistant's text, each tool call and a truncated tool result, numbered in
order.
"""

import json
import sys


def text_of(result):
    if isinstance(result, list):
        return " ".join(x.get("text", "") for x in result if isinstance(x, dict))
    return str(result)


def main(path):
    n = 0
    with open(path) as transcript:
        for line in transcript:
            try:
                entry = json.loads(line)
            except ValueError:
                continue
            kind = entry.get("type")
            attachment = entry.get("attachment") or {}
            # A message the developer sends while the worker is busy is stored
            # as an attachment, not as a user entry.
            if kind == "attachment" and attachment.get("type") == "queued_command":
                n += 1
                print(f"\n[{n}] USER (mid-turn): {attachment.get('prompt')}")
                continue
            if kind not in ("user", "assistant"):
                continue
            content = entry.get("message", {}).get("content")
            if isinstance(content, str):
                content = [{"type": "text", "text": content}]
            for block in content or []:
                n += 1
                block_type = block.get("type")
                if block_type == "text":
                    limit = 1500 if kind == "assistant" else 1200
                    text = block["text"]
                    more = " …" if len(text) > limit else ""
                    print(f"\n[{n}] {kind.upper()}: {text[:limit]}{more}")
                elif block_type == "tool_use":
                    args = json.dumps(block.get("input"), ensure_ascii=False)
                    print(f"\n[{n}] TOOL {block.get('name')}: {args[:700]}")
                elif block_type == "tool_result":
                    result = text_of(block.get("content"))
                    error = " (ERROR)" if block.get("is_error") else ""
                    more = " …" if len(result) > 400 else ""
                    print(f"[{n}] RESULT{error}: {result[:400]}{more}")


if __name__ == "__main__":
    if len(sys.argv) != 2:
        sys.exit(__doc__)
    main(sys.argv[1])

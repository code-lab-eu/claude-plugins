---
name: grilling
description: Grill the user relentlessly about a plan, decision, or idea. Use when the user wants to stress-test their thinking, or uses any 'grill' trigger phrases.
---

Interview the user relentlessly until you reach a shared understanding. Map
this as a **design tree**: every decision branches into the decisions that hang
off it.

The **frontier** is every decision whose prerequisites are already settled —
the questions you can ask _now_ without guessing at answers you haven't heard
yet. Pick the frontier question that unblocks the most others, ask it, and wait
for the user's answer. Format each question as the "Rule: presenting
decisions" in your context describes.

Each answer reshapes the tree — settled decisions push the frontier outward and
unblock questions that depended on them. Recompute the frontier and ask the
next question. When the user only says "next question" or similar, move on to
the next frontier question. Leave the unanswered question open, and ask it
again once no other frontier question remains.

Finding _facts_ is your job, never the user's. When a frontier question needs a
fact from the environment (filesystem, tools, etc.), dispatch a sub-agent to
find it — don't ask the user for anything you could look up yourself. Don't
block on it: a running exploration is an unsettled prerequisite, so only the
questions downstream of it wait for the sub-agent to report — ask the next
frontier question now. The _decisions_ are the user's — put each to them and
wait.

The session is done when the frontier is empty: every branch of the design tree
visited, nothing left silently assumed. Do not act on it until the user
confirms you have reached a shared understanding. Ask for that confirmation
with a list of the settled decisions.

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
for the user's answer. Ask in the chat text, never with the AskUserQuestion
tool.

Each question should be formatted like so:

```
<The decision and why it matters now: what depends on it, what is already settled that leads to it, and the facts found that bear on it.>

**Option A: <short name>.** <What the option is and how it works.>

- Pros: <pro>
- Cons:
  - <con>
  - <con>

**Option B: <short name>.** <What the option is and how it works.>

- Pros:
  - <pro>
  - <pro>
- Cons: <con>

**Option C: <short name>.** …

**Best practice.** <One paragraph naming what is commonly done, with concrete references (tools, projects, documentation). Say when something is from memory and not verified.>

**Recommendation: <option>.** <One short paragraph with the reason.>
```

List every option worth considering. A minor detail whose answer does not
depend on the question may follow the options, with its own reasoning and
recommendation.

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

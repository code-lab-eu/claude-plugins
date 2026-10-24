# Rule: presenting decisions

Apply this whenever a decision is put to the developer, in a grilling session
or not.

## Before presenting options

Settle the facts from the code and the documentation first. Ask the developer
only about choices that belong to the developer.

Read the official documentation of the tool, and search the codebase for an
existing solution. An existing solution is the first option.

## Format

Put one decision per message, in the chat text, never with the AskUserQuestion
tool. This format replaces the question format of any other skill.

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

# Rule: presenting decisions

Apply this whenever a decision is put to the developer, in a grilling session
or not.

## Before presenting options

Settle the facts from the code and the documentation first, including whether
anything needs the decision now; when nothing does, say so and propose dropping
or deferring it. Ask the developer only about choices that belong to the
developer.

Read the official documentation of the tool, and search the codebase for an
existing solution. An existing solution, or a fix within the design's existing
mechanism, is the first option: reuse the code that exists instead of writing a
second solution next to it. The end state has one mechanism per purpose. An
option that replaces a mechanism migrates every dependent and removes it;
keeping a mechanism that the end state does not need is not reuse.

When the decision is about a failure, look for an option that removes the step
where the failure happens, such as automating it, next to the options that
detect or document the failure.

## Format

Put one decision per message, in the chat text, never with the AskUserQuestion
tool. This format replaces the question format of any other skill. A decision
stays open until the developer picks an option; a question or remark about it
does not settle it.

```
<The decision and why it matters now: what depends on it, what is already settled that leads to it, and the facts found that bear on it. When the decision fixes a defect, the failing sequence step by step.>

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

List only the options that are worth considering: those that fit what is already
settled or that the developer described, and that the facts found do not rule
out. Never add an option, pro or con for balance or completeness. Check every
pro and con against the code before listing it. Weigh every option, pro and con
by one measure: the highest possible quality of the result. Implementation
effort counts only where it affects that quality.

Judge the result in its end state: after the planned work, such as the entries
of the roadmap or the backlog, is done, and over the years it is maintained. A
mechanism that nothing in the end state needs is obsolete, even when something
uses it today. Compatibility with an obsolete mechanism is not a pro, and an
option that gives it a new dependent has that as a con. Recommend by the same
measure, never by which option changes the least today.

Name an alternative that is ruled out in one line of the decision text, with the
reason, not as an option. When the facts leave one option, present that one and
ask for confirmation. Variants of one option that differ only in a value are one
option; give the value as part of the recommendation.

A minor detail whose answer does not depend on the question may follow the
options, with its own reasoning and recommendation.

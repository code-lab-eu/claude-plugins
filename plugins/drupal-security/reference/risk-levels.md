# Security risk score

Drupal scores each vulnerability with the NIST Common Misuse Scoring System:
six metrics, summed to a score from 0 to 25.

Sources, checked 2026-10-31:

- https://www.drupal.org/drupal-security-team/security-risk-levels-defined
- https://www.drupal.org/drupal-security-team/security-risk-calculator
- https://www.drupal.org/drupal-security-team/security-team-procedures/drafting-a-security-advisory

## Metrics

| Metric | Value | Meaning | Points |
|---|---|---|---|
| AC, access complexity | None | The user visits a page. | 4 |
| | Basic | The user follows a specific path. | 2 |
| | Complex | Multi-step, unintuitive, many dependencies. | 1 |
| A, authentication | None | Anonymous users. | 4 |
| | User | Basic or commonly assigned permissions. | 2 |
| | Admin | Broad permissions without `restrict access`. | 1 |
| CI, confidentiality impact | All | All non-public data is accessible. | 5 |
| | Some | Certain non-public data is released. | 3 |
| | None | No confidentiality impact. | 0 |
| II, integrity impact | All | All data can be modified or deleted. | 5 |
| | Some | Some data can be modified. | 3 |
| | None | Data integrity remains intact. | 0 |
| E, exploit | Exploit | Exploit code exists in the wild. | 4 |
| | Proof | A proof of concept is publicly documented. | 2 |
| | Theoretical | No public exploit or documentation. | 1 |
| TD, target distribution | All | All module configurations. | 3 |
| | Default | Default or common configurations; a config change disables it. | 2 |
| | Uncommon | Only uncommon configurations. | 1 |

## Levels

| Score | Level |
|---|---|
| 0–4 | Not critical |
| 5–9 | Less critical |
| 10–14 | Moderately critical |
| 15–19 | Critical |
| 20–25 | Highly critical |

## Conventions

- A vulnerability that needs a permission with `restrict access: true` gets no
  SA.
- XSS and some improper-authentication issues use `CI:Some` and `II:Some`.
- Remote code execution uses `CI:All` and `II:All`.
- Steps to reproduce in the confidential issue are `E:Theoretical`. `E:Proof`
  is only for a publicly disclosed proof of concept.
- `TD:Default` covers configuration changes unrelated to permissions.

## Notation

Advisories write the score as level, score and vector, as in
SA-CONTRIB-2026-289:

```
Moderately critical, 13/25 (AC:None/A:None/CI:Some/II:None/E:Theoretical/TD:Uncommon)
```

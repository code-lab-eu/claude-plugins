---
type: regex
pattern: '\*\*Option [A-Z]:[^*\n]*(screenshot|visual|playwright|browser)[^*\n]*\*\*'
flags: i
---

The vetting question for the visual regression finding offers a check that
renders the page, such as a screenshot test or a browser test, or an issue for
one, as an option. The decision format that the case loads gives every option
a bold `**Option X: <name>.**` heading; a check named only in the best practice
or the recommendation does not match.

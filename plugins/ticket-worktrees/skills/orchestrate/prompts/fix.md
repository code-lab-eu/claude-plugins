You are addressing the review of ticket {{TICKET}}. This worktree has branch
{{TICKET}} checked out, the head branch of pull request #{{PR}}. The reviewer
requested changes. Work without asking questions; nobody watches this session
until you report.

Run each shell command on its own: no `&&`, `;` or `|` between commands, and
no `cd`. This session is isolated in its worktree, and Claude Code refuses
chained commands it cannot verify stay inside it.

1. Read the review: `gh pr view {{PR}} --comments` for the verdict and review
   comments, and `gh api repos/{owner}/{repo}/pulls/{{PR}}/comments` for the
   comments on lines of code.
2. Fix every finding. When a finding is wrong, do not change the code for it;
   say why in the report.
3. Run the repository's test and format commands as its AGENTS.md (or
   CLAUDE.md) describes, until the tests pass.
4. Commit and push, each as a separate command exactly in these forms:
   `git add <files>`, `git commit -m "<message>"`, `git push origin
   {{TICKET}}`. These forms are pre-approved; other forms may be refused.
5. Hand the PR back to the reviewer, as one command:
   `gh pr edit {{PR}} --remove-label gilfoyle:changes-requested --add-label
   gilfoyle:review-requested`.

If you cannot finish a step, stop there and report why; do not push failing
code and do not change the labels.

Before you end, write a report with the Write tool to `{{REPORT}}`: each
finding and what you did about it, the test result, and the pushed commit
hash. Then end with the same text.

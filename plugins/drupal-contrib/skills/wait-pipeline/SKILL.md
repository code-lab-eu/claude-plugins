---
name: wait-pipeline
description: Waits for the pipeline of a merge request on git.drupalcode.org after a push, until it ends. Use when pushing to the branch of a merge request, or after creating one, on git.drupalcode.org.
---

# Wait for a merge request pipeline

Right after a push, the merge request's `head_pipeline` can still be the
previous pipeline. `wait-pipeline.sh`, in this skill's base directory, waits for
a pipeline other than that one on the pushed commit, until it ends.

`<path>` is the full path of the project that holds the merge request, such as
`project/graphql_webform` for an issue fork or
`security/3617853-graphql_core_schema-security` for a private security fork.

1. Before a push to the branch of an existing merge request, record its
   `head_pipeline.id`:

   ```sh
   GITLAB_HOST=git.drupalcode.org glab api projects/<path with / as %2F>/merge_requests/<iid>
   ```

2. After the push, or after creating the merge request, run the script in the
   background from the checkout, where `HEAD` is the pushed commit:

   ```sh
   <skill directory>/wait-pipeline.sh <path> <iid> HEAD <pipeline id from step 1>
   ```

   Leave out the pipeline id for a merge request created after the push. The
   script prints the pipeline's id, status, commit and URL. It exits with 0 for
   `success`, 1 for another end status, and 2 when the pipeline does not end
   within an hour.

Done when the script exits with 0. On 1, read the failing jobs:

```sh
GITLAB_HOST=git.drupalcode.org glab api 'projects/<path with / as %2F>/pipelines/<id>/jobs?scope[]=failed'
```

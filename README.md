# Setup

## OCaml

```bash
$ npm run ml:install
```

Create a new branch.

```bash
$ git co -B prompt001
```

COPY the prompt to work on from `RAW/ocaml` to `OCAML/prompts/`.

Build and watch the prompt (replace `001` with the actual prompt id).

```bash
$ npm run ml:watch 001
```

Submit work:

```bash
$ git commit -m "Solved 001"
$ git push origin prompt001
# ...
# ...
# pull-request [click on link here]
```

Create the pull request. The automated tests will run.

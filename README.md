<img height="96" src="./docs/img/logo.png" width="96" align="right"/>

# Open MRS Infrastructure Wiki

Full documentation is available here : https://gocert.gitlab.io/go-cert-wiki/

- [Open MRS Infrastructure Wiki](#open-mrs-infrastructure-wiki)
  - [How to commit to wiki](#how-to-commit-to-wiki)

## How to commit to wiki

Clone the repository, then install `mkdocs`:

```bash
git clone git@gitlab.com:gocert/go-cert-wiki.git && cd go-cert-wiki
pip install mkdocs-material mkdocstrings
```

You can then serve locally :

```bash
mkdocs serve
```

Edit markdown files within the `docs` folder.
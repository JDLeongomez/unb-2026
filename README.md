# UNB 2026

Slides for the **Opening Lecture & Conference**, Graduate Program in Behavioural Sciences,
Institute of Psychology, University of Brasília (UnB), 10–11 August 2026.

- [`open-science/index.qmd`](open-science/index.qmd) — Opening Lecture: *Open Science and Reproducibility* (10 Aug)
- [`statistical-inference/index.qmd`](statistical-inference/index.qmd) — Conference: *Statistical Inference in Psychology* (11 Aug)

Built with [Quarto](https://quarto.org) reveal.js and the
[quarto-revealjs-clean](https://github.com/grantmcdermott/quarto-revealjs-clean) theme.

See [PLAN.md](PLAN.md) for the full content plan.

## Rendering

```sh
quarto render
```

Rendered output goes to `_site/`, mirroring the source layout (`_site/open-science/index.html`,
`_site/statistical-inference/index.html`). `statistical-inference/index.qmd` renders its figures
live with R (tidyverse), so R must be installed to render that deck.

## Publishing

Pushing to `main` triggers [`.github/workflows/render.yml`](.github/workflows/render.yml), which
renders both decks and deploys `_site/` to the `gh-pages` branch. In the repo's Settings → Pages,
set the source to "Deploy from a branch" → `gh-pages` → `/ (root)`. Once enabled, the decks are
available at:

- `https://jdleongomez.github.io/unb-2026/open-science/`
- `https://jdleongomez.github.io/unb-2026/statistical-inference/`

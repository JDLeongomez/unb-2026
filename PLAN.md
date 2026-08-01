# UNB 2026 — Presentation Plan

## Event

**Opening Lecture & Conference**, Graduate Program in Behavioral Sciences, Institute of Psychology, University of Brasília (UnB), August 10–11, 2026.

- **Opening Lecture:** Afternoon of August 10, ~90 min — *Reproducibility and Open Science*
- **Conference:** Morning of August 11, ~90 min — *Statistical Inference in Psychology*

## Audience

- 30–60 people: graduate students and faculty from multiple psychology programs at UnB (evolutionary psychology, cognitive psychology, neuroscience, behavior analysis, social, educational, and clinical psychology)
- Low background in statistics, open science, and programming
- Tend to be shy and unlikely to participate spontaneously
- **Language:** British English

## Status (as of 2026-08-01)

**Repo scaffolding:** done. `_quarto.yml`, the `quarto-revealjs-clean` extension (installed under
`_extensions/grantmcdermott/clean`), the folder structure below, `.gitignore`, and `README.md`
are all in place. The repo is **not yet a git repository** (no `git init` has been run).

**`open-science/index.qmd`:** fully drafted end to end (Parts 1–4 + Closing), adapted and
translated from [preregistration-and-RRs](https://github.com/JDLeongomez/preregistration-and-RRs).
The hands-on OSF step-by-step tutorial was replaced with a short descriptive slide, and a
dedicated Preregistration-vs-Registered-Reports comparison slide was added (§3.4) per the brief
below. Part 4 also includes a Stage 1 **design table** (§4.3: Question, Hypothesis, Sampling
Plan, Analysis Plan, Rationale for the test's sensitivity, Interpretation given different
outcomes, Theory that could be shown wrong — matching PCI RR's actual template, which is more
detailed than the generic version), plus the real PCI RR design-table template and process
diagram (`img/PCIRR-designtable.jpeg`, `img/PCIRR-process.jpeg`, shown in §4.3 and §4.5). §4.9
covers PCI RR's bias-control levels (`img/bias_control_taxon.jpeg`) — kept to two takeaways
(secondary-data analyses are still eligible; submitting before data collection gets the
highest level) rather than the full technical detail, with the table itself shown as
reference material. All referenced again in the Closing "Practical First Steps" slide. Images
copied locally into `open-science/img/`.

**`statistical-inference/index.qmd`:** partially drafted.

- **Part 1** (What is Statistical Inference?) — fully drafted. Despite being marked *(NEW)*
  below, the Spanish source already covered this (parameter/coin intro + three-frameworks
  preview), so it was translated and reused directly rather than written from scratch.
- **Part 2** (Frequentist Inference) — **left as a skeleton (heading placeholders only)**.
  Waiting on a PowerPoint from the author to expand this section — do not draft further until
  it's provided.
- **Parts 3–5** (Likelihood, Bayesian, Comparison & Closing) — fully drafted, translated from
  [Inferencia_estadistica](https://github.com/JDLeongomez/Inferencia_estadistica). Figures are
  generated live via R/ggplot chunks with `echo: false` (the audience never sees code), so
  rendering requires R + the tidyverse installed.

**Next steps:**

1. Author to share the frequentist-inference PowerPoint → draft Part 2 of `statistical-inference`.
2. Proofread both decks for British English consistency and check timing against the ~90 min
   budget for each.
3. Decide whether to formalise citations via `references.bib` — both files are currently empty
   stubs, and all citations so far are inline markdown links (matching the original decks' style).
4. `git init` + first commit, push to GitHub, then enable Pages (Settings → Pages → Deploy from
   a branch → `gh-pages` → `/ (root)`) — see "Publishing" in README.md.

**CI/Publishing:** `.github/workflows/render.yml` renders both decks (R + tidyverse installed
via `r-lib/actions`, Quarto pinned to 1.10.18) on every push to `main` and deploys `_site/` to
the `gh-pages` branch via `peaceiris/actions-gh-pages`. `_quarto.yml` sets
`project.output-dir: _site` so both decks render to predictable, self-contained paths
(`_site/open-science/index.html`, `_site/statistical-inference/index.html`); `_site/` is
gitignored on `main`. Not yet tested end-to-end against a live GitHub Pages deployment — the
Pages source setting still needs to be configured once the repo exists on GitHub.

---

## Repo Architecture

```
unb-2026/
├── _quarto.yml                  # Global shared configuration
├── open-science/
│   ├── index.qmd                # Talk 1
│   ├── references.bib
│   └── img/
├── statistical-inference/
│   ├── index.qmd                # Talk 2
│   ├── references.bib
│   └── img/
├── _extensions/                 # Shared Quarto extensions
├── PLAN.md
└── README.md
```

**Theme:** `quarto-revealjs-clean`
Install with: `quarto add grantmcdermott/quarto-revealjs-clean`

The `_quarto.yml` should set global defaults (format: revealjs, theme: clean, bibliography
handling, etc.) and each `index.qmd` can override locally as needed.

---

## Opening Lecture (Aug 10): Open Science & Reproducibility

**File:** `open-science/index.qmd`
**Duration:** ~90 min
**Format:** Lecture (no live workshop activities)
**Emphasis:** Registered Reports and the PCI RR model; practical value for grad students

### Source material

Based on: <https://github.com/JDLeongomez/preregistration-and-RRs>
(rendered slides: <https://jdleongomez.github.io/preregistration-and-RRs/en/>)

The original was a hands-on workshop with step-by-step OSF exercises. Those sections must
be removed or converted to descriptive slides. Everything else can be adapted.

### Structure

#### Part 1 — What is Open Science? *(NEW)*
~15 min. Not in the source material. Cover:
- Definition and motivation
- The pillars of open science: open data, open code, open access, open materials,
  preregistration
- Why it matters for psychology and behavioral sciences
- Serves as context before introducing the reproducibility crisis

#### Part 2 — The Reproducibility Crisis *(reuse, minor edits)*
- Opening hook: 96% of psychology findings are statistically significant — why?
- Publication bias and the significance filter
- Threats to replicability: p-hacking, HARKing, publication bias, low power, flexible
  pipelines, selective reporting, data/code not shared, cultural incentives
- The four horsemen of the reproducibility apocalypse

#### Part 3 — Preregistration *(reuse, trim)*
- What it is and what it is not
- Key benefits
- Limitations and considerations
- **Remove** all step-by-step OSF tutorial slides (not a workshop)
- **Add** explicit, clear distinction between preregistration and Registered Reports
  (this distinction has caused persistent confusion in past audiences — make it
  unambiguous with a dedicated comparison slide or diagram)

#### Part 4 — Registered Reports *(reuse, expand)*
- How RRs differ from preregistration (reiterate clearly)
- The standard RR format: Stage 1 → IPA → Stage 2
- Key benefits (reduce publication bias, methodological rigour, transparency, null results
  welcome)
- The PCI RR model in detail:
  - Free, non-profit, journal-agnostic
  - Transparent open peer review
  - 100+ friendly journals, or use recommendation alone
  - **Why this is especially valuable for grad students** (no APC, publication guaranteed
    if plan is followed, peer review improves design before data collection)
- Real-world adoption (300+ journals, multiple disciplines)
- When RRs are not ideal

#### Closing — How to Start *(brief, practical)*
- Practical first steps for a grad student wanting to try this
- Key links: OSF Registries, PCI RR, cos.io

---

## Conference (Aug 11): Statistical Inference

**File:** `statistical-inference/index.qmd`
**Duration:** ~90 min
**Format:** Semi-interactive but presenter-driven. No spontaneous participation assumed.
Use rhetorical questions and structured guided moments — not open discussion.
**Approach:** Fully conceptual, no code shown.

### Source material

Based on: <https://github.com/JDLeongomez/Inferencia_estadistica>
(rendered: <https://jdleongomez.github.io/Inferencia_estadistica>)

The original uses a coin-flip example (20 tosses, 14 heads, θ = P(heads)) throughout to
illustrate all three frameworks. Keep this unifying example — it works well and should
run through the entire talk.

The original was in Spanish and included R code in the slides. The new version must be
in English and code-free (figures and diagrams replace any code output, generated
separately if needed).

### Structure

#### Part 1 — What is Statistical Inference? *(NEW)*
- The core problem: we have data, we want to say something about reality
- Parameters vs. statistics
- Probability as a language for uncertainty
- Introduce the coin example here (20 tosses, 14 heads — is the coin fair?)
- Three frameworks exist to answer this — preview of the talk structure

#### Part 2 — Frequentist Inference *(expand significantly)*
The source material covers this briefly. This section needs more development, drawing
from an existing PowerPoint (to be provided separately by the author).

Cover:
- Probability as long-run frequency
- The logic of hypothesis testing: P(data | H₀), not P(H₀ | data)
- Null hypothesis and the null distribution
- The p-value: what it is and — critically — what it is not
- Type I and Type II errors (α and β), and their consequences
- Statistical power
- Confidence intervals: correct and incorrect interpretations
- Apply all of this to the coin example

#### Part 3 — Likelihood Inference *(reuse)*
- The likelihood function L(θ)
- Maximum likelihood estimate (MLE)
- Likelihood ratio
- Applied to the coin example
- What likelihood does and does not tell us

#### Part 4 — Bayesian Inference *(reuse)*
- Prior, likelihood, posterior
- How prior beliefs update with data
- Credible intervals vs. confidence intervals
- Applied to the coin example

#### Part 5 — Comparison and Closing *(reuse, adapt)*
- Side-by-side comparison of the three frameworks on the same coin problem
- What question each framework answers
- Practical implications: when might each be more appropriate?
- Take-home message: these are tools, not religions
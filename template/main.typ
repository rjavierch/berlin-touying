// ============================================================
// SHUIMU-TOUYING PRESENTATION TEMPLATE — TUNED SHOWCASE
// ============================================================
// Demonstrates the maximum range of shuimu-touying features:
//   - All block types (infoblock, alertblock, exampleblock)
//   - All layout patterns (1-col, 2-col, 3-col grids)
//   - Tables (basic, booktabs, grouped rows, colspan/rowspan)
//   - Figures (single, side-by-side, inside blocks, above/below)
//   - Equations (numbered, unnumbered, inline, block)
//   - pos / neg / warn inline highlights
//   - focus-slide, outline-slide, title-slide
//   - Appendix section
//   - Custom colors, footer, and font config
//
// Content: Lorem ipsum placeholder throughout.
// ============================================================

#import "lib.typ": *

// ============================================================
// THEME CONFIGURATION
// ============================================================
#show: shuimu-touying-theme.with(
  aspect-ratio: "16-9",
  align: top,
  display-section-slides: true,

  // ── Custom color scheme ──────────────────────────────────
  theme-colors: shuimu-colors(
    // primary:          rgb("#1A5276"),   // deep ocean blue
    // primary-dark:     rgb("#0E2F44"),
    // neutral-lightest: rgb("#FDFEFE"),
    // neutral-darkest:  rgb("#0D0D0D"),
  ),

  // ── Custom fonts ────────────────────────────────────────
  theme-fonts: shuimu-fonts(
    // main:             ("Linux Libertine", "Palatino", "Georgia"),
    body-size: 15pt,
    footer-size: 8.5pt,
    header-title-size: 1.25em,
  ),

  // ── Footer slots ────────────────────────────────────────
  footer-top-left: self => self.info.title,
  footer-top-mid: self => self.info.at("event", default: []),
  footer-top-right: self => self.info.date.display("[month repr:short] [day], [year]"),
  footer-bottom-left: self => {
    let pm = self.info.at("personal-mail", default: [])
    let wm = self.info.at("work-mail", default: [])
    [#self.info.author #h(2em) #pm / #wm]
  },
  footer-bottom-right: self => self.info.institution,

  // ── Metadata ────────────────────────────────────────────
  config-info(
    title: [Lorem Ipsum Showcase],
    subtitle: [A Comprehensive Feature Demonstration],
    author: [Jane Doe],
    advisor: [Prof. John Smith],
    personal-mail: [jane\@lorem.edu],
    work-mail: [j.doe\@ipsum.ac],
    institution: [Department of Lorem Studies, Ipsum University],
    institution-1: [Department of Lorem Studies],
    institution-2: [Faculty of Dolor Sciences],
    institution-3: [Ipsum University],
    event: [International Lorem Conference],
    date: datetime.today(),
  ),
)

// ── Global settings ─────────────────────────────────────────
#set par(justify: true)
#set math.equation(numbering: "(1)")

// ── Custom show rule: figure captions wrap to content width ─
#show figure: it => {
  layout(size => context {
    let cap-width = if it.kind == table {
      let body-width = measure(it.body).width
      calc.min(body-width, size.width)
    } else {
      size.width
    }

    let caption-block = block(
      width: cap-width,
      std.align(if it.kind == table { left } else { center }, it.caption),
    )

    std.align(center, if it.kind == table {
      stack(dir: ttb, spacing: 0.65em, caption-block, it.body)
    } else {
      stack(dir: ttb, spacing: 0.65em, it.body, caption-block)
    })
  })
}

// ============================================================
// COVER & OUTLINE
// ============================================================
#title-slide()
#outline-slide(title: [Outline])

// ============================================================
// 1. INTRODUCTION
// ============================================================
= Introduction

== Motivation

#lorem(45)

#grid(
  columns: (0.55fr, 0.41fr),
  gutter: 1.2cm,
  [
    - #lorem(12)
    - #lorem(10)
    - *#lorem(30)*
  ],
  figure(
    // rect(width: 100%, height: 5.5cm, fill: luma(220))[
    //   #align(center + horizon)[_Figure placeholder_]
    // ],
    image("figure.jpeg", width: 80%),
    caption: [#lorem(10)],
  ),
)

== Research Questions

#infoblock(title: [Core Questions])[
  + #lorem(18)
  + #lorem(16)
  + #lorem(14)
]

#v(6pt)
#lorem(30)

== Literature Gap

#grid(
  columns: (1fr, 1fr),
  gutter: 1cm,
  infoblock(title: [What Exists])[
    - #lorem(10)
    - #lorem(9)
    - #lorem(11)
  ],
  alertblock(title: [What Is Missing])[
    - #lorem(10)
    - #lorem(12)
    - #lorem(9)
  ],
)

// ============================================================
// 2. DATA & METHODS
// ============================================================
= Data & Methods

== Study Area & Data

#grid(
  columns: (0.55fr, 0.41fr),
  gutter: 1.2cm,
  [
    *Datasets used (1990–2021, pentad resolution):*
    - *Atmospheric:* #lorem(30)
    - *Hydrological:* #lorem(7)
    - *Vegetation:* #lorem(9)
    - *Labels:* #lorem(10)
  ],
  figure(
    // rect(width: 100%, height: 5.5cm, fill: luma(220))[
    //   #align(center + horizon)[_Study area map_]
    // ],
    image("figure.jpeg", width: 80%),
    caption: [#lorem(30)],
  ),
)

== Ground Truth & Labels

*Binary classification label at lead $L$:*

$
  "label"(c, t, L) = cases(
    1 quad & "onset detected at " (c\, t+L),
    0 quad & "otherwise"
  )
$

- Headline lead: $bold(L = 4)$ pentads ($approx 20$ days).
- Also evaluated at $L = 2$ and $L = 6$ pentads.
- Train / validation / test split: 1990–2010 / 2011–2015 / 2016–2021.
- *Strict temporal split — no information leakage.*

== Model Architecture

#grid(
  columns: (1fr, 1fr),
  gutter: 1cm,
  infoblock(title: [Input Sequence])[
    Past $K = 8$–$12$ steps per grid cell comprising: #lorem(15)
  ],
  infoblock(title: [Models Compared])[
    - *Baselines:* threshold rules, logistic regression, random forest
    - *Neural models:* LSTM / GRU; Transformer sequence model
  ],
)

#v(6pt)
*Evaluation metrics:* AUC, POD, Brier score, reliability diagrams — at each lead $L$.

== Equations Showcase

#infoblock(title: [Primary Loss Function])[
  $ cal(L) = -1/N sum_(i=1)^N [y_i log hat(y)_i + (1 - y_i) log(1 - hat(y)_i)] $
]

#infoblock(title: [Auxiliary Identity (unnumbered)])[
  #math.equation(block: true, numbering: none)[
    $ sum_(i=1)^N omega_i = 1, quad omega_i >= 0 $
  ]
]

#infoblock(title: [Index Definition])[
  $ "IDX"(t, w) = Phi^(-1) [hat(F)("PET"(t\, w))] $

  where $Phi^(-1)$ is the probit function and $hat(F)$ is the empirical CDF.
]

// ============================================================
// FOCUS SLIDE — transition
// ============================================================
#focus-slide[
  Results
]

// ============================================================
// 3. RESULTS
// ============================================================
= Results

== Quantitative Performance

#grid(
  columns: (1fr, 1fr, 1fr),
  gutter: 0.8cm,
  infoblock(title: [$L = 2$ pentads])[
    - AUC: *0.83*
    - POD\@0.5: 0.71
    - Brier: 0.12
    - #lorem(30)
  ],
  infoblock(title: [$L = 4$ pentads])[
    - AUC: *0.79*
    - POD\@0.5: 0.65
    - Brier: 0.15
    - #lorem(30)
  ],
  infoblock(title: [$L = 6$ pentads])[
    - AUC: *0.74*
    - POD\@0.5: 0.58
    - Brier: 0.19
    - #lorem(30)
  ],
)

#v(6pt)
#lorem(28)

== AUC Comparison Table

#figure(
  table(
    columns: (auto, auto, auto, auto),
    stroke: 0.5pt,
    align: (left, center, center, center),
    table.header([*Model*], [$L=2$], [$L=4$], [$L=6$]),
    [Threshold rule], [0.68], [0.61], [0.54],
    [Logistic regression], [0.72], [0.66], [0.59],
    [Random Forest], [0.78], [0.72], [0.66],
    [LSTM], [0.81], [0.77], [0.70],
    [Transformer], [*0.84*], [*0.79*], [*0.74*],
  ),
  caption: [AUC comparison across models and lead times. Bold = best per column.],
)

== Booktabs-Style Table

#figure(
  table(
    columns: (auto, auto, auto, auto, auto, auto, auto, auto),
    align: (left, left, center, center, center, center, center, center),
    stroke: none,
    inset: (x: 0.55em, y: 0.4em),

    table.hline(stroke: 1.5pt),
    [], [],
    table.cell(colspan: 2)[LSTM],
    table.cell(colspan: 2)[Random Forest],
    table.cell(colspan: 2)[Transformer],
    table.hline(stroke: 0.5pt),
    [Variable], [Horizon],
    [$R^2$], [Bias],
    [$R^2$], [Bias],
    [$R^2$], [Bias],
    table.hline(stroke: 0.8pt),

    table.cell(rowspan: 2)[Var A],
    [$t_1$], [*0.71*], [-0.1], [*0.71*], [+0.6], [*0.71*], [+0.5],
    [$t_6$], [*0.46*], [-0.3], [0.37], [+0.7], [0.33], [+1.3],
    table.hline(stroke: 0.5pt),

    table.cell(rowspan: 2)[Var B],
    [$t_1$], [*0.48*], [+0.3], [*0.48*], [+1.4], [0.43], [+3.5],
    [$t_6$], [*0.31*], [+3.9], [0.23], [+3.8], [0.14], [+6.9],
    table.hline(stroke: 0.5pt),

    table.cell(rowspan: 2)[Var C],
    [$t_1$], [0.47], [-1.7], [*0.48*], [-1.4], [*0.48*], [+2.0],
    [$t_6$], [0.42], [+2.1], [*0.44*], [+0.5], [0.41], [+3.6],
    table.hline(stroke: 1.5pt),
  ),
  caption: [$R^2$ and mean prediction bias for all models at $t_1$ and $t_6$. Bold = best $R^2$ per row.],
)

== Driver Attribution

#grid(
  columns: (0.55fr, 0.41fr),
  gutter: 1.2cm,
  [
    *Semi-arid regions* — #lorem(14)

    #v(4pt)
    *Humid regions* — #lorem(14)

    #v(4pt)
    *Transition zones* — #lorem(12)
  ],
  figure(
    // rect(width: 100%, height: 5.5cm, fill: luma(220))[
    //   #align(center + horizon)[_SHAP summary plot_]
    // ],
    image("figure.jpeg", width: 80%),
    caption: [#lorem(10)],
  ),
)

== Two Figures Side by Side

#grid(
  columns: (1fr, 1fr),
  gutter: 1cm,
  [#figure(
    // rect(width: 100%, height: 5cm, fill: luma(220))[
    //   #align(center + horizon)[_Figure A_]
    // ],
    
    image("figure.jpeg", width: 80%),
    caption: [AUC — semi-arid croplands.],
  ) <fig:auc-dry>],
  [#figure(
    // rect(width: 100%, height: 5cm, fill: luma(220))[
    //   #align(center + horizon)[_Figure B_]
    // ],
    image("figure.jpeg", width: 80%),
    caption: [AUC — humid broadleaf forests.],
  ) <fig:auc-wet>],
)

#v(4pt)
Semi-arid regions (@fig:auc-dry) achieve higher AUC at short leads,
while humid regions (@fig:auc-wet) benefit from vegetation inputs at longer leads.

== Case Study & Inline Highlights

#exampleblock(title: [2012 Central Plains Event])[
  The model issued a *Level 3 warning* 18 days before the official designation.
  #lorem(20)
]

#v(6pt)
The results showed that #pos[group A improved by 34%], while #neg[group B presented higher mortality]. Furthermore, #warn[a worrying trend was observed in subgroup C].

== Executive Summary (Stacked Cards)

#infoblock(title: [Finding 1 — #lorem(5)])[
  #lorem(22)
]
#v(4pt)
#infoblock(title: [Finding 2 — #lorem(5)])[
  #lorem(20)
]
#v(4pt)
#alertblock(title: [Caveat — #lorem(4)])[
  #lorem(18)
]

// ============================================================
// 4. DISCUSSION
// ============================================================
= Discussion

== Interpretation

- #lorem(20)
- #lorem(18)
- #lorem(22)
- #lorem(16)

#v(6pt)
#infoblock(title: [Key Takeaway])[
  #lorem(30)
]

== Limitations

#alertblock(title: [Known Limitations])[
  - #lorem(16)
  - #lorem(14)
  - #lorem(18)
]

// Cita básica — genera [1] o (Doe, 2023) según el estilo
El método fue propuesto por @doe2023.

// Con número de página
El resultado fue verificado @doe2023[p. 52].

// Solo el año entre paréntesis
Como se ha demostrado previamente #cite(<doe2023>, form: "year").

// Solo el autor
#cite(<doe2023>, form: "author") demostró que lorem ipsum.

// Múltiples fuentes juntas
#cite(<doe2023>)#cite(<ipsum2021>)

#v(6pt)
#lorem(25)

== Open Questions

#grid(
  columns: (1fr, 1fr),
  gutter: 1cm,
  infoblock(title: [Unresolved])[
    - #lorem(10)
    - #lorem(11)
    - #lorem(9)
  ],
  infoblock(title: [Next Steps])[
    - #lorem(10)
    - #lorem(12)
    - #lorem(11)
  ],
)

// ============================================================
// 5. CONCLUSIONS
// ============================================================
= Conclusions

== Summary

#infoblock(title: [Key Findings])[
  + #lorem(20)
  + #lorem(18)
  + #lorem(22)
]

== Outlook & Future Work

- #lorem(18)
- #lorem(16)
- #lorem(20)

#v(6pt)
#lorem(28)

// ============================================================
// FOCUS SLIDE — Q&A
// ============================================================
#focus-slide[
  Thank you! \
  Questions?
]

#slide(header: none, title: none)[
  #align(left)[*References*]
  // #bibliography(
  //   "refs.bib",
  //   title: none, // evita doble título
  //   full: true,
  //   style: "gb-7714-2015-numeric",
  // )
  // APA (autor-año: "Doe, 2023")
  // #bibliography("refs.bib", title: none, full: true, style: "apa")

  // // IEEE (numérico: [1], [2]...)
  #bibliography("refs.bib", title: none, full: true, style: "ieee")

  // // Chicago autor-fecha
  // #bibliography("refs.bib", title: none, full: true, style: "chicago-author-date")

  // // MLA
  // #bibliography("refs.bib", title: none, style: "mla")
]



// ============================================================
// APPENDIX
// ============================================================
= Appendix

== Supplementary: Definitions

#infoblock(title: [Onset Criteria])[
  An event is flagged if:
  + #lorem(16)
  + #lorem(14)
  + #lorem(12)
]

== Supplementary: Hyperparameter Table

#figure(
  table(
    columns: (auto, auto, auto),
    stroke: 0.5pt,
    align: (left, center, center),
    table.header([*Hyperparameter*], [*Value*], [*Search Range*]),
    [Hidden size], [256], [64–512],
    [Sequence length $K$], [10], [6–16],
    [Dropout], [0.30], [0.1–0.5],
    [Learning rate], [3e-4], [1e-5–1e-3],
    [Batch size], [1024], [256–4096],
  ),
  caption: [Final hyperparameters after grid search.],
)

== Supplementary: Figure with Caption Above

// Caption-above override for this slide only
#show figure.where(kind: image): set figure.caption(position: top)

#figure(
  // rect(width: 80%, height: 5cm, fill: luma(220))[
  //   #align(center + horizon)[_Timeline placeholder_]
  // ],
  image("figure.jpeg", width: 50%),
  caption: [Caption placed above the figure — useful for context-first slides.],
)

== Supplementary: Figure + Equation

#grid(
  columns: (0.50fr, 0.46fr),
  gutter: 1.2cm,
  [
    The index is defined as:

    $ "IDX"(t, w) = Phi^(-1) [hat(F)("PET"(t, w))] $

    where $Phi^(-1)$ is the probit function and
    $hat(F)$ is the empirical CDF of #lorem(30).
  ],
  figure(
    // rect(width: 100%, height: 5.5cm, fill: luma(220))[
    //   #align(center + horizon)[_Figure placeholder_]
    // ],
    image("figure.jpeg", width: 60%),
    caption: [#lorem(30)],
  ),
)


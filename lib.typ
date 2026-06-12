// ShuimuTouying
// a THU Touying theme.
// Authors: Mason Chen
// Inspired by Stargazer theme
//
// Fork maintained by: rjavierch
// Changes: extended figure caption wrapping, showcase template

#import "@preview/touying:0.7.4": *
#import "@preview/shadowed:0.3.0": shadow

/// Theme color configuration.
#let shuimu-colors(
  primary: rgb("#3333B2"),
  primary-dark: rgb("#191959"),
  primary-darker: rgb("#262686"),
  neutral-lightest: rgb("#ffffff"),
  neutral-darkest: rgb("#000000"),
) = (
  primary: primary,
  primary-dark: primary-dark,
  primary-darker: primary-darker,
  neutral-lightest: neutral-lightest,
  neutral-darkest: neutral-darkest,
)

/// Theme font and font size configuration.
#let shuimu-fonts(
  main: ("Liberation Sans", "Arial", "Helvetica", "Ubuntu Nerd Font"),
  body-size: 16pt,
  navigation-size: 0.6em,
  title-slide-title-size: 1.4em,
  title-slide-subtitle-size: 1.2em,
  title-slide-info-size: 0.9em,
  outline-size: 1.2em,
  outline-number-size: 0.75em,
  section-title-size: 2.5em,
  section-body-size: 0.8em,
  focus-size: 1.5em,
  footer-size: 9pt,
  caption-size: 0.6em,
  footnote-size: 0.6em,
  header-title-size: 1.3em,
) = (
  main: main,
  body-size: body-size,
  navigation-size: navigation-size,
  title-slide-title-size: title-slide-title-size,
  title-slide-subtitle-size: title-slide-subtitle-size,
  title-slide-info-size: title-slide-info-size,
  outline-size: outline-size,
  outline-number-size: outline-number-size,
  section-title-size: section-title-size,
  section-body-size: section-body-size,
  focus-size: focus-size,
  footer-size: footer-size,
  caption-size: caption-size,
  footnote-size: footnote-size,
  header-title-size: header-title-size,
)


/// Basic visual component

/// Renders a content block with a title bar, used for content that needs to be emphasized, such as formulas, theorems, definitions, etc.

/// Internal base renderer - all colored blocks share this structure
#let _render-colorblock(self: none, accent: none, title: none, body) = {
  pad(
    bottom: 6pt,
    right: 6pt,
    shadow(
      dx: 3pt,
      dy: 3pt,
      blur: 6pt,
      spread: 0pt,
      fill: rgb(0, 0, 0, 40%),
      radius: 6pt,
      block(
        breakable: false,
        grid(
          columns: 1,
          row-gutter: 0pt,

          // Top title bar
          block(
            fill: accent,
            width: 100%,
            radius: (top: 6pt),
            inset: (top: 0.4em, bottom: 0.3em, left: 0.5em, right: 0.5em),
            text(fill: self.colors.neutral-lightest, weight: "bold", title),
          ),

          // Gradient divider line connecting title bar and content area
          rect(
            fill: gradient.linear(accent, accent.lighten(90%), angle: 90deg),
            width: 100%,
            height: 4pt,
          ),
          v(-0.01em),
          // Content area
          block(
            fill: accent.lighten(90%),
            width: 100%,
            radius: (bottom: 6pt),
            inset: (top: 0.4em, bottom: 0.5em, left: 0.5em, right: 0.5em),
            body,
          ),
        ),
      ),
    ),
  )
}

/// Info block - theme primary color, for definitions, theorems, or stage conclusions
#let _render-infoblock(self: none, title: none, body) = {
  _render-colorblock(self: self, accent: self.colors.primary, title: title, body)
}

/// Alert block - red, for warnings or critical points
#let _render-alertblock(self: none, title: none, body) = {
  _render-colorblock(self: self, accent: rgb("#C0392B"), title: title, body)
}

/// Example block - green, for examples or positive results
#let _render-exampleblock(self: none, title: none, body) = {
  _render-colorblock(self: self, accent: rgb("#27AE60"), title: title, body)
}

/// A content block with a title bar, used to emphasize formulas, theorems, definitions, or stage conclusions within the body text.
#let infoblock(title: none, body) = touying-fn-wrapper(
  _render-infoblock.with(
    title: title,
    body,
  ),
)

/// A red content block with a title bar, used for warnings or critical points.
#let alertblock(title: none, body) = touying-fn-wrapper(
  _render-alertblock.with(title: title, body),
)


/// A green content block with a title bar, used for examples or positive results.
#let exampleblock(title: none, body) = touying-fn-wrapper(
  _render-exampleblock.with(title: title, body),
)

/// Collects section navigation data used by the mini-frame and table of contents page.
///
/// Each section in the return value contains:
/// - heading-title: the level-1 heading content.
/// - heading-location: the location of the level-1 heading, used for linking back to the section start.
/// - slide-markers: navigable physical page markers under this section, excluding focus-slides and Touying skip pages.

#let _collect-navigation-sections() = {
  let section-headings = query(heading.where(level: 1, outlined: true))

  if section-headings.len() == 0 {
    ()
  } else {
    let focus-slide-skip-pages = query(<touying-skip-dot>).map(s => s.location().page())
    let touying-skip-pages = query(<touying:skip>).map(s => s.location().page())
    let skipped-pages = focus-slide-skip-pages + touying-skip-pages
    let heading-pages = section-headings.map(heading => heading.location().page())
    let slide-marker-locations = query(<touying-slide-page>).map(
      marker => marker.location(),
    )
    let slide-pages = slide-marker-locations.map(location => location.page())
    let known-pages = heading-pages + skipped-pages + slide-pages
    let last-known-page = calc.max(..known-pages)
    let navigation-sections = ()

    for (section-index, heading) in section-headings.enumerate() {
      let section-start-page = heading.location().page()
      let section-end-page = if section-index + 1 < section-headings.len() {
        section-headings.at(section-index + 1).location().page()
      } else {
        last-known-page + 1
      }

      navigation-sections.push((
        heading-title: heading.body,
        heading-location: heading.location(),
        slide-markers: slide-marker-locations
          .filter(location => (
            section-start-page <= location.page() and location.page() < section-end-page
          ))
          .filter(location => location.page() not in skipped-pages)
          .map(location => (page: location.page(), location: location)),
      ))
    }

    navigation-sections
  }
}


/// Mini-frames navigation bar
#let _render-mini-frame-navigation(self: none) = {
  let navigation-background = self.colors.primary-dark
  let navigation-text-color = self.colors.neutral-lightest
  let fonts = self.store.fonts

  context {
    let navigation-sections = _collect-navigation-sections()
    let current-page = here().page()

    // The current section is the last level-1 heading whose starting page is no later than the current page.
    let current-section-index = -1
    for (section-index, section) in navigation-sections.enumerate() {
      if section.heading-location.page() <= current-page {
        current-section-index = section-index
      }
    }

    block(
      width: 100%,
      fill: navigation-background,
      inset: (top: 0.25em, bottom: 0.25em, x: 0.5em),
      {
        set text(size: fonts.navigation-size)
        set align(left + horizon)

        grid(
          columns: navigation-sections.map(_ => auto),
          column-gutter: 1.5em,

          ..navigation-sections
            .enumerate()
            .map(((section-index, section)) => {
              let is-current-section = (section-index == current-section-index)

              // Active section uses solid color; inactive sections have reduced opacity.
              let navigation-item-color = if is-current-section {
                navigation-text-color
              } else {
                navigation-text-color.transparentize(60%)
              }

              let section-title-link = link(
                section.heading-location,
                text(
                  fill: navigation-item-color,
                  // weight: "bold",
                  section.heading-title,
                ),
              )

              let slide-dot-links = if section.slide-markers.len() > 0 {
                stack(
                  dir: ltr,
                  spacing: 3pt,
                  ..section.slide-markers.map(slide-marker => {
                    let is-current-slide-marker = (
                      slide-marker.page == current-page
                    )

                    link(
                      slide-marker.location,
                      box(
                        circle(
                          radius: 2.5pt,
                          stroke: (
                            paint: navigation-item-color,
                            thickness: 0.8pt,
                          ),
                          fill: if is-current-slide-marker {
                            navigation-item-color
                          } else {
                            none
                          },
                        ),
                      ),
                    )
                  }),
                )
              } else {
                v(5pt)
              }

              stack(
                dir: ttb,
                spacing: 0.4em,
                section-title-link,
                slide-dot-links,
              )
            })
        )
      },
    )
  }
}




/// Page blueprint
/// Defines the logic for different types of slides (normal pages, cover, table of contents, section pages, ending page)
/// 1. Body page (Slide)
///
/// Inherits the theme's default header, footer, and body alignment, while also allowing individual pages to temporarily override these settings.
#let slide(
  title: auto,
  header: auto,
  footer: auto,
  align: auto,
  config: (:),
  repeat: auto,
  setting: body => body,
  composer: auto,
  ..bodies,
) = touying-slide-wrapper(self => {
  // Handle parameter overrides: if the user has passed in specific header/footer, override the global store
  if align != auto {
    self.store.align = align
  }
  if title != auto {
    self.store.header-title = title
  }
  if header != auto {
    self.store.slide-header = header
  }
  if footer != auto {
    self.store.footer-bar = footer
  }
  let slide-setting = body => {
    show: std.align.with(self.store.align)
    show: setting
    // The mini-frame navigation locates each physical page using this hidden marker.
    [#hide[#"" <touying-slide-page>]]
    body
  }
  touying-slide(
    self: self,
    config: config,
    repeat: repeat,
    setting: slide-setting,
    composer: composer,
    ..bodies,
  )
})



/// 2. Cover page (Title Slide)
/// Splits multiple names under the same role into a grid with a fixed number of columns, to avoid an overly wide list of people on the cover.

#let _render-cover-person-grid(
  self: none,
  role-label,
  person-list,
  max-person-columns: 3,
) = {
  if person-list.len() == 0 {
    none
  } else {
    let grid-cells = ()

    let row-start = 0
    let role-row-index = 0
    while row-start < person-list.len() {
      let person-row = person-list.slice(row-start, calc.min(
        row-start + max-person-columns,
        person-list.len(),
      ))

      grid-cells.push(text(fill: self.colors.neutral-darkest, if role-row-index == 0 {
        role-label
      } else { [] }))
      for person in person-row {
        grid-cells.push(text(fill: self.colors.neutral-darkest, person))
      }
      grid-cells += ([],) * (max-person-columns - person-row.len())

      row-start += max-person-columns
      role-row-index += 1
    }

    grid(
      columns: (auto,) + (auto,) * max-person-columns,
      column-gutter: 0.5em,
      row-gutter: 0.5em,
      ..grid-cells,
    )
  }
}

/// Cover page.
#let title-slide(config: (:), ..args) = touying-slide-wrapper(self => {
  self = utils.merge-dicts(
    self,
    config,
    config-page(header: none), // ← no header
  )
  // self.store.header-title = none // Cover page does not need a header title
  let presentation-info = self.info + args.named()

  let title-slide-body = {
    let fonts = self.store.fonts

    show: std.align.with(center + horizon)
    pad(
      bottom: 6pt,
      right: 6pt,
      shadow(
        dx: 3pt,
        dy: 3pt,
        blur: 6pt,
        spread: 0pt,
        fill: rgb(0, 0, 0, 40%),
        radius: 6pt,
        // Title box
        block(
          fill: self.colors.primary,
          inset: 1.5em,
          width: 100%,
          radius: 0.5em,
          breakable: false,
          {
            text(
              size: fonts.title-slide-title-size,
              fill: self.colors.neutral-lightest,
              // weight: "bold",
              presentation-info.title,
            )
            if presentation-info.subtitle != none {
              parbreak()
              text(
                size: fonts.title-slide-subtitle-size,
                fill: self.colors.neutral-lightest,
                // weight: "bold",
                presentation-info.subtitle,
              )
            }
          },
        ),
      ),
    )

    // Author
    if "author" in presentation-info and presentation-info.author != none {
      v(0.5em)
      text(size: fonts.title-slide-info-size, presentation-info.author)
    }

    // Advisor
    if "advisor" in presentation-info and presentation-info.advisor != none {
      v(-0.5em)
      text(size: fonts.title-slide-info-size, [*Advisor:* #presentation-info.advisor])
    }

    v(1.6em)

    // Institution
    for i in range(1, 5) {
      let field = "institution-" + str(i)
      if field in presentation-info and presentation-info.at(field) != none {
        v(-0.5em)
        text(size: fonts.title-slide-info-size, presentation-info.at(field))
      }
    }

    v(1.6em)

    // Event type
    if "event" in presentation-info and presentation-info.at("event") != none {
      v(-0.5em)
      text(size: fonts.title-slide-info-size, presentation-info.at("event"))
    }

    // Date
    if presentation-info.date != none {
      v(-0.5em)
      text(size: fonts.title-slide-info-size, presentation-info.date.display("[month repr:short] [day], [year]"))
    }
  }
  touying-slide(self: self, title-slide-body)
})



/// 3. Table of contents page (Outline Slide)
/// The outline page generates a section list based on level-1 headings and links to the start of each section.
#let outline-slide(
  config: (:),
  title: utils.i18n-outline-title,
) = touying-slide-wrapper(self => {
  self.store.header-title = title
  touying-slide(
    self: self,
    config: config,
    std.align(
      horizon,
      context {
        let fonts = self.store.fonts

        set text(
          fill: self.colors.neutral-darkest,
          weight: "bold",
          size: fonts.outline-size,
        )

        let navigation-sections = _collect-navigation-sections()

        if navigation-sections.len() > 0 {
          let row-count = navigation-sections.len()

          layout(size => context {
            // Measure a sample item to get real height in absolute units
            let sample = box(
              stack(
                dir: ltr,
                spacing: 0.5em,
                box(width: 1.1em, height: 1.1em),
                [Sample],
              ),
            )
            let item-height = measure(sample).height
            let total-items-height = row-count * item-height
            let available = size.height

            let gap-count = calc.max(row-count - 1, 1)
            let dynamic-spacing = (available - total-items-height) / gap-count

            // max-spacing measured in absolute units to allow comparison
            let max-spacing = measure(v(1.2em)).height

            // Now both values are in pt - comparison works
            let spacing = if dynamic-spacing < max-spacing {
              dynamic-spacing
            } else {
              max-spacing
            }

            stack(
              dir: ttb,
              spacing: spacing,
              ..navigation-sections
                .enumerate()
                .map(((section-index, section)) => {
                  let section-number-badge = box(
                    width: 1.1em,
                    height: 1.1em,
                    radius: 50%,
                    fill: self.colors.primary,
                    place(
                      center + horizon,
                      text(
                        fill: self.colors.neutral-lightest,
                        weight: "bold",
                        size: fonts.outline-number-size,
                        top-edge: "bounds",
                        bottom-edge: "bounds",
                        str(section-index + 1),
                      ),
                    ),
                  )
                  box(
                    stack(
                      dir: ltr,
                      spacing: 0.5em,
                      section-number-badge,
                      link(section.heading-location, section.heading-title),
                    ),
                  )
                }),
            )
          })
        } else {
          [No sections found.]
        }
      },
    ),
  )
})

/// 4. Section page (New Section Slide)
/// Essentially an outline page with a title

#let new-section-slide(
  config: (:),
  title: auto,
  ..args,
) = touying-slide-wrapper(self => {
  let section-slide-body = args.pos().sum(default: none)

  touying-slide(
    self: self,
    config: config,
    std.align(center + horizon, {
      let fonts = self.store.fonts

      set text(
        fill: self.colors.primary,
        weight: "bold",
        size: fonts.section-title-size,
      )

      if title != auto {
        title
        if section-slide-body != none {
          parbreak()
          v(0.5em)
          set text(size: fonts.section-body-size)
          section-slide-body
        }
      } else if section-slide-body != none {
        section-slide-body
      } else {
        utils.display-current-heading(level: 1)
      }
    }),
  )
})


/// 5. Focus page (Focus Slide)
/// Displays a short phrase or Q&A on a solid-color background, and is not counted in the slide page numbers.
#let focus-slide(
  config: (:),
  align: horizon + center,
  body,
) = touying-slide-wrapper(self => {
  self = utils.merge-dicts(
    self,
    config-common(freeze-slide-counter: true),
    config-page(
      fill: self.colors.primary,
      margin: 2em,
      header: none,
      footer: none,
    ),
  )
  set text(
    fill: self.colors.neutral-lightest,
    weight: "bold",
    size: self.store.fonts.focus-size,
  )
  touying-slide(self: self, config: config, {
    [#hide[#"" <touying-skip-dot>]]
    std.align(align, body)
  })
})


/// Theme entry point and global configuration.
///
/// header-title controls the header title on normal pages; footer-* parameters respectively control
/// the presenter, author, report title, and page count in the footer.

#let shuimu-touying-theme(
  aspect-ratio: "16-9",
  align: horizon,
  theme-colors: shuimu-colors(),
  theme-fonts: shuimu-fonts(),
  display-section-slides: false,
  header-title: self => utils.display-current-heading(depth: self.slide-level),
  // Footer slots - cada uno acepta contenido, función self=>..., o none
  footer-top-left: self => self.info.title,
  footer-top-mid: none,
  footer-top-right: none,
  footer-bottom-left: self => self.info.author,
  footer-bottom-mid: context utils.slide-counter.display() + " / " + utils.last-slide-number,
  footer-bottom-right: none,
  ..args,
  body,
) = {
  let fonts = theme-fonts
  // Define the global header layout
  let render-header(self) = {
    set std.align(top)
    set text(font: fonts.main)
    stack(
      dir: ttb, // Arrange from top to bottom
      spacing: 0em, // Remove the gap in the middle

      // 1. The navigation bar at the top
      _render-mini-frame-navigation(self: self),

      // 2. The slide title bar below
      utils.call-or-display(self, self.store.slide-header),
    )
  }

  // Define the global footer layout
  let render-footer(self) = {
    set text(font: fonts.main, size: fonts.footer-size)
    set std.align(center + bottom)
    utils.call-or-display(self, self.store.footer-bar)
  }

  // Initialize the Touying system (assemble the theme)
  show: touying-slides.with(
    config-page(
      ..utils.page-args-from-aspect-ratio(aspect-ratio),
      header: render-header,
      footer: render-footer,
      header-ascent: 0em,
      footer-descent: 0em,
      margin: (top: 4.5em, bottom: 2.5em, x: 2.5em),
    ),
    config-common(
      slide-fn: slide,
      new-section-slide-fn: if display-section-slides {
        new-section-slide
      } else {
        none
      },
      receive-body-for-new-section-slide-fn: true,
    ),
    config-methods(
      init: (self: none, body) => {
        set text(font: fonts.main, size: fonts.body-size)
        set list(marker: "•")
        set ref(supplement: it => {
          if it.func() == figure { [Fig.] } else { it.supplement }
        })
        show figure.caption: set text(size: fonts.caption-size)
        show figure.caption: it => [
          *#it.supplement #context it.counter.display(it.numbering)#it.separator*#it.body
        ]
        show figure: it => {
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
              stack(
                dir: ttb,
                spacing: 0.65em,
                caption-block,
                it.body,
              )
            } else {
              stack(
                dir: ttb,
                spacing: 0.65em,
                it.body,
                caption-block,
              )
            })
          })
        }
        show footnote.entry: set text(size: fonts.footnote-size)
        show heading: set text(fill: self.colors.neutral-darkest, weight: "black")
        set super(typographic: false) // Disable the font's default superscript style to prevent conflicts
        show link: link-element => if type(link-element.dest) == str {
          set text(fill: self.colors.primary)
          link-element
        } else {
          link-element
        }
        show figure.where(kind: table): set figure.caption(position: top)
        body
      },
      // alert: utils.alert-with-primary-color,
      infoblock: _render-infoblock,
    ),
    config-colors(..theme-colors),
    // Save the theme configuration to the Touying store, for the header, footer, and per-page override logic to read.
    config-store(
      align: align,
      fonts: fonts,
      header-title: header-title,
      footer-top-left: footer-top-left,
      footer-top-mid: footer-top-mid,
      footer-top-right: footer-top-right,
      footer-bottom-left: footer-bottom-left,
      footer-bottom-mid: footer-bottom-mid,
      footer-bottom-right: footer-bottom-right,
      slide-header: self => if self.store.header-title != none {
        block(
          width: 100%,
          height: 2em,
          fill: self.colors.primary,
          place(
            left + horizon,
            text(
              fill: self.colors.neutral-lightest,
              // weight: "bold",
              size: self.store.fonts.header-title-size,
              utils.call-or-display(self, self.store.header-title),
            ),
            dx: 1.5em,
          ),
        )
      },

      footer-bar: self => {
        show strong: strong-content => strong-content.body

        let tl = utils.call-or-display(self, self.store.footer-top-left)
        let tm = utils.call-or-display(self, self.store.footer-top-mid)
        let tr = utils.call-or-display(self, self.store.footer-top-right)
        let bl = utils.call-or-display(self, self.store.footer-bottom-left)
        let bm = utils.call-or-display(self, self.store.footer-bottom-mid)
        let br = utils.call-or-display(self, self.store.footer-bottom-right)

        let fonts = self.store.fonts

        stack(
          dir: ttb,
          spacing: 0pt,

          rect(
            width: 100%,
            height: 14pt,
            fill: self.colors.primary-darker,
            inset: (x: 6pt, y: 2pt),
            stroke: self.colors.primary-darker,
          )[#std.align(center + horizon)[
            #grid(
              columns: (3fr, 1fr, 3fr),
              gutter: 0pt,
              align: (left + horizon, center + horizon, right + horizon),
              text(size: fonts.footer-size, fill: self.colors.neutral-lightest, tl),
              text(size: fonts.footer-size, fill: self.colors.neutral-lightest, tm),
              text(size: fonts.footer-size, fill: self.colors.neutral-lightest, tr),
            )
          ]],

          rect(
            width: 100%,
            height: 14pt,
            fill: self.colors.primary-dark,
            inset: (x: 6pt, y: 2pt),
            stroke: self.colors.primary-dark,
          )[#std.align(center + horizon)[
            #grid(
              columns: (3fr, 1fr, 3fr),
              gutter: 0pt,
              align: (left + horizon, center + horizon, right + horizon),
              text(size: fonts.footer-size, fill: self.colors.neutral-lightest, bl),
              text(size: fonts.footer-size, fill: self.colors.neutral-lightest, bm),
              text(size: fonts.footer-size, fill: self.colors.neutral-lightest, br),
            )
          ]],
        )
      },
    ),
    ..args,
  )
  body
}


/// Positive finding - bold blue
#let pos(body) = text(fill: rgb("#1A6FBF"), weight: "bold", body)

/// Negative finding - bold red
#let neg(body) = text(fill: rgb("#C0392B"), weight: "bold", body)

/// Warning / caution - bold amber
#let warn(body) = text(fill: rgb("#D4A017"), weight: "bold", body)

/// Highlight / emphasis - bold green
#let pos-green(body) = text(fill: rgb("#27AE60"), weight: "bold", body)

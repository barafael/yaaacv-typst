// ============================================================================
// yaaacv — Yet Another Also Awesome CV
//
// A Typst port of the `yaac-another-awesome-cv` LaTeX class
// (c) Christophe Roger, LPPL 1.3c.  Spacing started out from the class
// definitions and has since been tuned; the code is authoritative.
//
// Requires the system fonts "Source Sans Pro" (Light/Regular) and
// "Font Awesome 6 Free" (Solid + Regular) / "Font Awesome 6 Brands".
// See README.md and template/main.typ for usage.
// ============================================================================

// ---------------------------------------------------------------------------
// Colors, named after the class's color macros.
// ---------------------------------------------------------------------------

/// The base accent color of the template (YAAC blue).
#let base-color = rgb("0000aa")

/// Color of names, section titles, taglines (`accentcolor` in the class).
#let accent-color = base-color.lighten(10%)

/// Color of icons and the email address (`symbolcolor`).
#let symbol-color = base-color.lighten(15%)

/// Color of hyperlinks (`linkcolor`).
#let link-color = base-color

/// Color of the skill dots (`accentcolor!80`).
#let accent-dots = base-color.lighten(20%)

/// Border color of tag chips (`darkGrey!70`).
#let tag-border = rgb("b6b6b6")

// ---------------------------------------------------------------------------
// Font Awesome 6 glyph helpers.
//
// FA6 Free ships Solid (900) and Regular (400) faces.  Some systems expose
// the Solid face only under its own family name ("Font Awesome 6 Free
// Solid"); weight-based selection alone then misses it.  The Regular face
// resolves reliably via "Font Awesome 6 Free" + weight 400.
// ---------------------------------------------------------------------------

/// A Font Awesome 6 Solid glyph from a unicode codepoint.
#let fa-solid(cp) = text(font: ("Font Awesome 6 Free Solid", "Font Awesome 6 Free"), weight: 900, str.from-unicode(cp))

/// A Font Awesome 6 Regular glyph from a unicode codepoint.
#let fa-regular(cp) = text(font: "Font Awesome 6 Free", weight: 400, str.from-unicode(cp))

/// A Font Awesome 6 Brands glyph from a unicode codepoint.
#let fa-brands(cp) = text(font: "Font Awesome 6 Brands", str.from-unicode(cp))

#let fa-at           = fa-solid(0xf1fa)
#let fa-map-marker   = fa-solid(0xf3c5)
#let fa-info         = fa-solid(0xf05a)
#let fa-linkedin     = fa-brands(0xf0e1)
#let fa-mobile       = fa-solid(0xf3cd)
#let fa-github       = fa-brands(0xf09b)
#let fa-tasks        = fa-solid(0xf0ae)
#let fa-suitcase     = fa-solid(0xf0f2)
#let fa-mortar-board = fa-solid(0xf19d)
#let fa-globe        = fa-solid(0xf0ac)
#let fa-plus         = fa-solid(0xf067)
#let fa-laptop       = fa-solid(0xf109)
#let fa-external     = fa-solid(0xf08e)
#let fa-angle-right  = fa-solid(0xf105)
/// Filled circle (FA6 Solid `circle`), used for filled skill dots.
#let fa-circle       = fa-solid(0xf111)
/// Thin-ring circle (FA6 Regular `circle`, ≈ the class's `\faCircleThin`),
/// used for empty skill dots.
#let fa-circle-o     = fa-regular(0xf111)

/// Renders an icon in the template's symbol color.
#let fa-icon(sym) = text(baseline: 0.2pt, fill: symbol-color, sym)

/// Renders an icon centered in a fixed-width box, so icons stacked in a
/// column line up regardless of each glyph's advance width.
#let fa-icon-cell(sym) = box(width: 1.2em, align(center, fa-icon(sym)))

// ---------------------------------------------------------------------------
// Layout constants
// ---------------------------------------------------------------------------

/// Width of the date/name column in education and skill entries.
#let left-column = 1.8cm

/// Width of the date column in `experience` entries; narrower than
/// `left-column` so the entry bodies get more room.
#let experience-column = 1.6cm

/// Diameter of the circular profile photo.
#let photo-diameter = 2.5cm

/// Body leading.  Reproduces the class's 18pt line pitch (`\baselinestretch
/// 1.5` at 10pt): Typst's pitch is the 6.6pt line box plus leading.
#let body-leading = 1.14em

/// Project body leading (`\linespread{1.25}`, a 15pt pitch).
#let project-body-leading = 0.84em

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// A hyperlink in the template's link color.
#let cv-link(url, body) = link(url, text(fill: link-color, body))

/// External-link label: a small external-link icon plus a colored link
/// (LaTeX `\weblink{\scriptsize{\faExternalLink}}{url}{label}`).
#let website(url, label) = box[
  #text(baseline: 1pt, size: 0.7em, text(fill: symbol-color, fa-external))
  #h(0.3em)
  #link(url, text(fill: link-color, label))
]

/// A tag chip (LaTeX `\cvtag`: rounded tikz node, `darkGrey!70` border).
#let cvtag(body) = box(
  inset: (x: 0.5em, y: 0.28em),
  outset: (y: 0.25em),
  radius: 0.25em,
  stroke: (paint: tag-border, thickness: 0.4pt),
  body,
)

/// A row of small tag chips.  Accepts an array of strings or content.
#let tag-row(tags) = {
  set text(size: 8pt)
  if type(tags) == array { tags.map(cvtag).join(h(0.5em)) } else { tags }
}

/// A circular profile photo cropped to `photo-diameter`.
///
/// Accepts image *content* (not a path — paths inside a package resolve
/// against the package root): `image("photo.jpg", width: 2.5cm, height: 2.5cm, fit: "cover")`.
#let idphoto(photo) = box(
  width: photo-diameter,
  height: photo-diameter,
  radius: photo-diameter / 2,
  clip: true,
)[#photo]

// ---------------------------------------------------------------------------
// CV header (alternative layout).
// LaTeX \makecvheader: name, tagline and social table on the left, photo on
// the right, vertically centered.
// ---------------------------------------------------------------------------

/// The CV header: name, tagline, contact/social rows, circular photo.
///
/// - author: a dictionary with `firstname`, `lastname`, `tagline`, `photo`
///   (image content, e.g. `image("photo.jpg", width: 2.5cm, height: 2.5cm, fit: "cover")`),
///   and any of `linkedin`, `github`, `github-pages` (handles), `phone`,
///   `email`, `address`, `info`.  Set a key to `none` to omit it.
///
/// #example ```typst
/// #yaaacv.cvheader((
///   firstname: [Jane], lastname: [Doe],
///   tagline: [Professional Title], photo: image("photo.jpg"),
///   github: "janedoe", email: "jane@example.com",
/// ))
/// ```
#let cvheader(author) = {
  let sep = text[ #h(0.25em) | #h(0.25em) ]
  // Social links as (icon, link) pairs, in LaTeX order: linkedin, github,
  // github-pages.  LaTeX puts the first social's icon in the icon column and
  // repeats the others' icons inline (the yaac cls hardcodes this row).
  let socials = ()
  if author.linkedin != none {
    let handle = author.linkedin
    socials.push((
      fa-linkedin,
      link("http://www.linkedin.com/in/" + handle,
        text(fill: link-color, "linkedin.com/in/" + handle)),
    ))
  }
  if author.github != none {
    let handle = author.github
    socials.push((
      fa-github,
      link("http://www.github.com/" + handle,
        text(fill: link-color, "github.com/" + handle)),
    ))
  }
  if author.github-pages != none {
    let handle = author.github-pages
    socials.push((
      fa-github,
      link("https://" + handle + ".github.io",
        text(fill: link-color, handle + ".github.io")),
    ))
  }

  let cells = ()
  if socials.len() > 0 {
    // Icon column: icon of the first social.
    let (first-icon, first-link) = socials.first()
    let rest = socials.slice(1).map(((icon, lnk)) => text[
      #fa-icon(icon)
      #lnk
    ])
    cells.push(fa-icon-cell(first-icon))
    cells.push(
      if rest.len() > 0 { [#first-link#sep#rest.join(sep)] } else { first-link },
    )
  }
  if author.phone != none {
    cells.push(fa-icon-cell(fa-mobile))
    cells.push(author.phone)
  }
  if author.email != none {
    cells.push(fa-icon-cell(fa-at))
    // LaTeX colors the email symbolcolor, not linkcolor.
    cells.push(link("mailto:" + author.email,
      text(fill: symbol-color, author.email)))
  }
  if author.address != none {
    cells.push(fa-icon-cell(fa-map-marker))
    cells.push(author.address)
  }
  if author.info != none {
    cells.push(fa-icon-cell(fa-info))
    cells.push(author.info)
  }

  // LaTeX: text and photo minipages, vertically centered against each other.
  grid(
    columns: (1fr, photo-diameter),
    column-gutter: 2em,
    align: (left + top, center + horizon),
    grid(
      columns: 1fr,
      row-gutter: (0pt, 0pt, 0pt),
      // Name: \LARGE, last name in small caps + bold.
      text(
        size: 17.28pt, fill: accent-color, weight: 300,
        [#author.firstname #smallcaps[#text(weight: 400, author.lastname)]]
      ),
      // Tagline: \large, bold.
      {
        set par(leading: 8.58pt)
        pad(top: 25pt)[
          #text(size: 12pt, weight: 400, fill: accent-color, author.tagline)
        ]
      },
      // Social table: \small.
      {
        pad(top: 41pt)[
          #text(size: 9pt, grid(
            columns: (auto, auto),
            column-gutter: 0.5em,
            row-gutter: 9pt,
            align: (right + horizon, left + horizon),
            ..cells,
          ))
        ]
      },
    ),
    idphoto(author.photo),
  )
}

// ---------------------------------------------------------------------------
// Section title: icon + small-caps title + rule.
// LaTeX: \titleformat{\section}{\Large\raggedright}{}{0em}{}[\titlerule].
// ---------------------------------------------------------------------------

/// A section heading: icon, small-caps title, horizontal rule.
///
/// #example ```typst
/// #yaaacv.section-title[Experience][#yaaacv.fa-suitcase]
/// ```
#let section-title(title, icon) = {
  v(1em)
  block(
    width: 100%,
    inset: (bottom: 4.5pt, top: 0pt),
    stroke: (bottom: (paint: black, thickness: 0.4pt)),
    text(size: 14.4pt, fill: accent-color)[
      #fa-icon(icon)
      #h(0.5em)
      #smallcaps(title)
    ],
  )
  v(6pt)
}

// ---------------------------------------------------------------------------
// Keywords (competences).
// ---------------------------------------------------------------------------

/// Creates one label/content pair for `keywords`.
#let keywords-entry(label, content) = (label, content)

/// A label/content list, e.g. for a "Competences" section: bold right-aligned
/// labels, wrapped content.
///
/// #example ```typst
/// #yaaacv.keywords(
///   yaaacv.keywords-entry("Languages", [*Rust*, C, Python]),
///   yaaacv.keywords-entry("Tools", [git, Linux]),
/// )
/// ```
#let keywords(..entries) = {
  set par(leading: body-leading)
  let cells = ()
  for e in entries.pos() {
    cells.push(text(weight: 400, e.at(0)))
    cells.push(e.at(1))
  }
  grid(
    columns: (auto, 1fr),
    column-gutter: 1em,
    row-gutter: 1.3em,
    align: (right + top, left + top),
    ..cells,
  )
}

// ---------------------------------------------------------------------------
// Skills with 6-level dots (LaTeX: \faCircle/\faCircleThin in a longtable).
// ---------------------------------------------------------------------------

/// One skill row: a name and 1–6 filled dots out of 6 (empty = thin ring).
/// The name sits on its own line; the dot row is indented by about two
/// left columns and, like the class's longtable, may overflow a half-width
/// column.
#let skill(name, level) = {
  let dots = for i in range(1, 7) {
    if i > level {
      text(size: 1em, fill: accent-dots, fa-circle-o)
    } else {
      text(size: 1em, fill: accent-dots, fa-circle)
    }
    h(0.35em)
  }
  grid(
    columns: (left-column + 6pt, 1fr),
    column-gutter: 0pt,
    row-gutter: 3pt,
    align: (right + top, left + top),
    text(weight: 400, name),
    grid.cell(x: 1, y: 1)[
      #place(dx: left-column + 12pt, dots)
      #v(3.5mm)
    ],
  )
}

/// A list of `skill` rows.
///
/// #example ```typst
/// #yaaacv.skills(
///   yaaacv.skill("German", 6),
///   yaaacv.skill("English", 5),
/// )
/// ```
#let skills(..items) = block(below: 0.5em)[
  #grid(columns: 1, row-gutter: 1.25em, ..items)
]

// ---------------------------------------------------------------------------
// Experience entry: date column | vertical rule | content.
// LaTeX: longtable{R|E} — right-aligned dates, ragged-right body.
// ---------------------------------------------------------------------------

/// One experience entry.
///
/// - end-date: end of the period, shown bold in the first row (`none` hides it)
/// - title-text: job title
/// - org-link: employer; content (often `website(...)`) or `none`
/// - location: shown after the title; `none` to omit
/// - start-date: shown bold above the body; `none` to omit
/// - body: description; `- item` lines become angle-right bullets
/// - tags: array of tag strings
///
/// #example ```typst
/// #yaaacv.experience(
///   [May 2024], [Engineer at ACME], none, [Berlin], [June 2020],
///   [Did things.
///    - One thing
///    - Another thing],
///   ("tag", "tag"),
/// )
/// ```
#let experience(end-date, title-text, org-link, location, start-date, body, tags) = {
  let org-part = if org-link == none { [] } else { [, #smallcaps(org-link)] }
  let loc-part = if location == none { [] } else { [, #location] }
  let title-line = [#title-text#org-part#loc-part]
  let vstroke = 0.4pt + black
  let inset-x = 3pt
  block(breakable: false)[
    #table(
      // Insets eat into the column width; widen by both insets so the dates
      // get the full `experience-column`.
      columns: (experience-column + 2 * inset-x, 1fr),
      column-gutter: 0pt,
      row-gutter: 0pt,
      stroke: none,
      align: (right + top, left + top),
      inset: (x: inset-x, y: 4pt),
      table.cell(stroke: (right: vstroke))[#strong(end-date)],
      strong(title-line),
      table.cell(stroke: (right: vstroke))[#if start-date != none { strong(start-date) } else { [] }],
      {
        set par(spacing: 0pt)
        // Tighter bullets than the document default, to save width.
        set list(indent: 0.5em, body-indent: 0.25em)
        body
      },
      table.cell(stroke: (right: vstroke))[],
      tag-row(tags),
    )
  ]
  v(0.4em)
}

/// Small vertical space between consecutive experience entries.
#let empty-separator() = v(0.5em)

// ---------------------------------------------------------------------------
// Scholarship (education): right-aligned date | content, no vertical rule.
// ---------------------------------------------------------------------------

/// One education entry (bold date in the left column, content to the right).
/// Returns a (date, content) pair for `scholarship`.
#let scholarship-entry(date, content) = (text(weight: 400, date), content)

/// A list of `scholarship-entry` rows, e.g. under an "Education" heading.
/// All rows live in one grid so the distance between entries is uniform
/// and larger than the line pitch within an entry.
#let scholarship(..entries) = {
  set par(leading: body-leading)
  let cells = ()
  for e in entries.pos() {
    cells.push(e.at(0))
    cells.push(e.at(1))
  }
  block(below: 0.5em, grid(
    columns: (left-column, 1fr),
    column-gutter: 1em,
    row-gutter: 1.3em,
    align: (right + top, left + top),
    ..cells,
  ))
}

// ---------------------------------------------------------------------------
// Project entry.
// LaTeX: minipage with small-caps bold name and dates flush right, links
// row, \linespread{1.25} body, tags.
// ---------------------------------------------------------------------------

/// One project entry.
///
/// - links: optional content row (often `website(...)`); omit or pass `none`
/// - visible: set to `false` to hide this project entirely (handy for
///   tailoring a CV per application without deleting content)
///
/// #example ```typst
/// #yaaacv.project(
///   [Project], [2024],
///   links: yaaacv.website("https://example.com", [example.com]),
///   [What it is and what you did.],
///   ("tag", "tag"),
/// )
/// ```
#let project(name, dates, desc, tags, links: none, visible: true) = if visible {
  block(width: 100% - 1.5em, breakable: false)[
    #grid(
      columns: (1fr, auto),
      align: (left + horizon, right + horizon),
      strong(smallcaps(name)),
      smallcaps(dates),
    )
    #v(1pt)
    #if links != none [
      #links
      #v(1pt)
    ]
    #{
      set par(leading: project-body-leading)
      desc
    }
    #v(2pt)
    #tag-row(tags)
  ]
  v(1.8em)
}

// ---------------------------------------------------------------------------
// Two-column section.
// LaTeX: two minipages separated by \hfill.
// ---------------------------------------------------------------------------

/// Places two content blocks side by side (e.g. Languages | Interests).
#let two-column-section(left-content, right-content) = grid(
  columns: (1fr, 1fr),
  column-gutter: 6em,
  align: (left + top, left + top),
  left-content,
  right-content,
)

// ---------------------------------------------------------------------------
// Document setup.
// ---------------------------------------------------------------------------

/// The main entry point: a show rule that lays out the whole document.
///
/// Requires the system fonts "Source Sans Pro" and "Font Awesome 6 Free"
/// (Solid + Regular) / "Font Awesome 6 Brands".
///
/// - language: document language code (e.g. `"en"`, `"de"`); sets hyphenation
///
/// #example ```typst
/// #show yaaacv.cv.with(language: "en")
/// = Your CV content
/// ```
#let cv(body, language: "en") = {
  set page(
    paper: "a4",
    margin: (left: 1.5cm, right: 1.5cm, top: 1.5cm, bottom: 1.5cm),
  )
  set text(
    font: "Source Sans Pro",
    weight: 300, // Light as the main weight, as in the class
    size: 10pt,
    lang: language,
    fill: black,
  )
  // Bold (strong) maps to Regular (400) as in the LaTeX class.
  show strong: it => text(weight: 400, it.body)

  // LaTeX itemize with \faAngleRight labels.
  set list(
    marker: text(fill: black, fa-angle-right),
    indent: 1em,
    body-indent: 0.5em,
    spacing: body-leading,
  )

  // LaTeX: \parskip and \baselinestretch (see `body-leading`).
  set par(leading: body-leading, justify: false, spacing: 1em)

  body
}

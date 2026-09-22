// Condensed two-column example CV using the yaaacv package.
// Development version — imports the package sources directly:
//   typst compile --root .. template/condensed.typ

#import "../lib.typ": *

#cv-condensed(
  sidebar: [
    #condensed-header((
      firstname: [First],
      lastname: [Lastname],
      tagline: [Job Title | One-line personal pitch],
      photo: image("photo.jpg", width: photo-diameter, height: photo-diameter, fit: "cover"),
      linkedin: "handle",
      github: "handle",
      phone: [+00 000 000 00 00],
      email: "your.name@example.com",
      address: [Street 1, 00000 City],
      info: [Born on 01.01.1990],
    ))

    #condensed-section-title[Competences][#fa-tasks]
    #keywords(
      keywords-entry("Label", [*Highlight*, plain]),
      keywords-entry("Label", [item, item, linked]),
    )

    #condensed-section-title[Languages][#fa-globe]
    #condensed-skills(
      condensed-skill("Native language", 6),
      condensed-skill("Fluent language", 5),
      condensed-skill("Conversational", 3),
    )

    #condensed-section-title[Interests][#fa-plus]
    [
      - Interest or volunteering one
      - Interest or volunteering two
      - Interest or hobby three
    ]
  ],
)[
  #condensed-section-title[Experience][#fa-suitcase]

  #experience(
    [Month 20XX],
    [Job Title at Company],
    website("https://www.example.com", []),
    [City],
    [Month 20XX],
    [
      One-paragraph summary of role and responsibilities.
      - Achievement or duty one
      - Achievement or duty two
    ],
    ("Tag one", "Tag two", "Tag three"),
    date-column: 1.7cm,
    inset-x: 4pt,
    inset-y: 4pt,
    gap: 0.5em,
  )

  #experience(
    [Month 20XX],
    [Job Title at Company],
    none,
    [City],
    none,
    [
      One-paragraph summary of role and responsibilities.
      - Achievement or duty one
      - Achievement or duty two
    ],
    ("Tag one", "Tag two", "Tag three"),
    date-column: 1.7cm,
    inset-x: 4pt,
    inset-y: 4pt,
    gap: 0.5em,
  )

  #experience(
    [Month 20XX],
    [Job Title at Company],
    none,
    [City],
    none,
    [
      - One-line responsibility
    ],
    ("Tag one", "Tag two"),
    date-column: 1.7cm,
    inset-x: 4pt,
    inset-y: 4pt,
    gap: 0.5em,
  )

  #condensed-section-title[Education][#fa-mortar-board]

  #scholarship(
    scholarship-entry([*20XX - 20XX*], [
      Degree at #website("https://www.example.edu", [University Name]).
      Thesis on topic X, grade Y.
    ], date-column: 1.9cm, gutter: 0.7em, gap: 0.25em),
    scholarship-entry([*20XX - 20XX*], [
      Entry-level degree at #website("https://www.example.edu", [School Name])
    ], date-column: 1.9cm, gutter: 0.7em, gap: 0.25em),
  )

  #condensed-section-title[Projects][#fa-laptop]

  #project(
    [Project Name],
    [20XX],
    links: website("https://www.example.com", [example.com]),
    [One-paragraph description of the project and your contribution.],
    ("Tag one", "Tag two", "Tag three"),
    gap: 0.8em,
  )

  #project(
    [Project Name],
    [20XX - 20XX],
    links: website("https://www.example.com", [example.com]),
    [
      Description paragraph. \
      Second paragraph after a linebreak.
    ],
    ("Tag one", "Tag two"),
    gap: 0.8em,
  )
]

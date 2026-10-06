// RenoDat — Deliverable 1.2
#let deliverable = (
  id: "D1.2",
  title: "Analysis of Existing Data Sources and their Compliance with Identified Requirements",
  wp: "WP1",
  due: "M24",
  status: "Draft",
  version: "0.1",
  authors: ("TBD",),
  date: datetime.today(),
)

#set document(title: deliverable.id + " – " + deliverable.title, author: deliverable.authors)
#set page(
  paper: "a4",
  margin: (x: 2.5cm, y: 2.5cm),
  numbering: "1",
  header: context if counter(page).get().first() > 1 [
    #set text(9pt, fill: gray)
    RenoDat — #deliverable.id #h(1fr) #deliverable.title
  ],
)
#set text(font: "Libertinus Serif", size: 11pt, lang: "en")
#set par(justify: true)
#set heading(numbering: "1.1")
#show heading.where(level: 1): it => { pagebreak(weak: true); it; v(0.4em) }

// ---------- Title page ----------
#page(numbering: none, header: none)[
  #v(4cm)
  #text(14pt, fill: gray)[RenoDat Project]
  #v(0.5cm)
  #text(28pt, weight: "bold")[#deliverable.id]
  #v(0.2cm)
  #text(20pt)[#deliverable.title]
  #v(2cm)
  #table(
    columns: (auto, 1fr),
    stroke: none,
    inset: 6pt,
    [*Work package*], deliverable.wp,
    [*Due date*], deliverable.due,
    [*Status*], deliverable.status,
    [*Version*], deliverable.version,
    [*Authors*], deliverable.authors.join(", "),
    [*Date*], deliverable.date.display("[day] [month repr:long] [year]"),
  )
]

// ---------- Document history ----------
#heading(numbering: none, outlined: false)[Document History]
#table(
  columns: (auto, auto, 1fr, 2fr),
  [*Version*], [*Date*], [*Author*], [*Changes*],
  [0.1], [], [], [Initial structure],
)

#outline(depth: 2)

#heading(numbering: none)[Executive Summary]
// TODO

= Introduction
== Purpose and Scope
== Relation to D1.1

= Methodology
== Source Identification
== Assessment Criteria

= Inventory of Existing Data Sources
== Public Data Sources (cadastre, EPC registers, 3D city models)
== Private Data Sources
== Other Sources (sensors, BIM, statistics)

= Compliance Analysis
== Coverage of Requirements
== Data Quality Assessment
== Accessibility and Licensing
== Compliance Matrix

= Gap Analysis

= Conclusions and Recommendations

#heading(numbering: none)[References]
// #bibliography("refs.bib")

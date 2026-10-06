// RenoDat — Deliverable 1.3
#let deliverable = (
  id: "D1.3",
  title: "Data Integration Strategy for Coupling Public and Private Building Data",
  wp: "WP1",
  due: "Milestone M36 · Final M48",
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
== Relation to D1.1 and D1.2

= Integration Challenges
== Heterogeneity of Sources
== Identifiers and Linking Keys
== Semantic and Geometric Mismatch

= Integration Architecture
== Overall Architecture
== Data Ingestion and Harmonisation
== Linking and Matching Methods
== Storage and Access

= Semantic Interoperability
== Ontologies and Data Models
== Mappings to Standards

= Data Quality and Provenance

= Implementation and Validation
== Pilot Cases
== Evaluation

= Roadmap: Milestone (M36) to Final Version (M48)

= Conclusions

#heading(numbering: none)[References]
// #bibliography("refs.bib")
